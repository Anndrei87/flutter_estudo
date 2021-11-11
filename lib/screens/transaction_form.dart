import 'dart:async';

import 'package:bytebank_contato_2/components/container.dart';
import 'package:bytebank_contato_2/components/progress.dart';
import 'package:bytebank_contato_2/components/response_dialog.dart';
import 'package:bytebank_contato_2/components/transaction_auth_alert.dart';
import 'package:bytebank_contato_2/http/webclients/transaction_webclient.dart';
import 'package:bytebank_contato_2/models/contact.dart';
import 'package:bytebank_contato_2/models/transaction.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';


@immutable
abstract class TransactionFromState {
  const TransactionFromState();
}

@immutable
class SendingState extends TransactionFromState {
  const SendingState();
}

@immutable
class ShowFormState extends TransactionFromState {
  const ShowFormState();
}

@immutable
class SentState extends TransactionFromState {
  final List<Contact> _contacts;
  const SentState(this._contacts);
}

class FatalErrorContactsList extends TransactionFromState {
  const FatalErrorContactsList();
}


class TransformtCubit extends Cubit<TransactionFromState> {
  TransformtCubit() : super(const ShowFormState());
}

class TransactionFormContainer extends BlocContainer{
  final Contact _contact;
  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransformtCubit>(
        create: (context) =>TransformtCubit(),
    child: TransactionFormStateles(_contact)
    );}
  }

class TransactionFormStateles extends StatelessWidget {
  final TransactionWebClient _webClient = TransactionWebClient();

  final Contact _contact;
  TransactionFormStateles(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransformtCubit, TransactionFromState>(
        builder: (context, state){
          if(state is ShowFormState){
            return _BasicForm(_contact);
          }
          if(state is SendingState){
            return const BasicProgess();
          }
          return const Text('Error!!');
        },
    );
  }

  // void tryParseInput(BuildContext context) {
  //   final double? value = double.tryParse(_valueController.text);
  //   final transactionCreated = Transaction(value!, _contact, transactionId);
  //   showDialog(context: context, builder: (contextDialog) {
  //     return  TransactionDialog(onConfirm: (String password) {
  //       _save(transactionCreated, password, context);
  //     },);
  //   });
  // }

  void _save(Transaction transactionCreated, String password, BuildContext context) async {
    // setState(() {
    //   _sending = true;
    // });
    await Future.delayed(const Duration(seconds: 1));

     final Transaction transaction = await _webClient.save(transactionCreated, password).catchError((e){ // tratar o erro do timeout
       if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
         FirebaseCrashlytics.instance.setCustomKey('exeption', e.toString());
         FirebaseCrashlytics.instance.setCustomKey('http_body', transactionCreated.toString());
         FirebaseCrashlytics.instance.recordError(e, null);
       }
       // setState(() {
       //   _sending = false;
       // });
       showDialog(context: context, builder: (dialogContext){
         return FailureDialog(e.message);
       });

     }, test: (e) => e is TimeoutException).catchError((e){
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.recordError(e, null);
        FirebaseCrashlytics.instance.setCustomKey('exeption', e.toString());
        // FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
        FirebaseCrashlytics.instance.setCustomKey(
            'http_body', transactionCreated.toString());
      }
       // setState(() {
       //   _sending = false;
       // });
       showDialog(context: context, builder: (dialogContext){ // tratar o erro da exeception
         return FailureDialog(e.message);
       });
     }, test: (e) => e is Exception).whenComplete(() {
       // setState(() {
       //   _sending = false;
       // });
     });


    if(transaction != null){
      await showDialog(context: context, builder: (dialogSucess) {
        return const SuccessDialog('A transação foi um sucesso');
      });
      Navigator.pop(context);
    }
  }
}

class _BasicForm  extends StatelessWidget{
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = const Uuid().v4();
  final Contact _contact;
  _BasicForm(this._contact);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _contact.name,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Transfer'),
                    onPressed: () {
                      final double? value = double.tryParse(_valueController.text);
                      final transactionCreated = Transaction(value!, _contact, transactionId,
                      );
                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionDialog(
                              onConfirm: (String password) {

                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
