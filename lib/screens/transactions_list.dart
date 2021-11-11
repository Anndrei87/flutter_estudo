import 'package:bytebank_contato_2/components/centered_message.dart';
import 'package:bytebank_contato_2/components/progress.dart';
import 'package:bytebank_contato_2/http/webclients/transaction_webclient.dart';
import 'package:bytebank_contato_2/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  TransactionsList({Key? key}) : super(key: key);

  final TransactionWebClient _webClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Transaction>>(
          future: _webClient.findAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                const Progress();
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if(snapshot.hasData){
                  final List<Transaction>? transactions = snapshot.data;
                  if (transactions!.isNotEmpty) { // se a resposta do body for diferente de vazio
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final Transaction transaction = transactions[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.monetization_on),
                            title: Text(transaction.value.toString(),
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(transaction.contact.accountNumber.toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: transactions.length,
                    );
                  }
                }
                return const CenteredMessage(
                  message: 'No transactions found', icon: Icons.warning,);
            }
            return const Progress();
          }
      ),


    );
  }
}
