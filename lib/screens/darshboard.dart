import 'package:bytebank_contato_2/components/container.dart';
import 'package:bytebank_contato_2/components/localization.dart';
import 'package:bytebank_contato_2/models/name.dart';
import 'package:bytebank_contato_2/screens/contacts_list.dart';
import 'package:bytebank_contato_2/screens/name.dart';
import 'package:bytebank_contato_2/screens/transactions_list.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardContainer extends BlocContainer {
  const DashboardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return
     BlocBuilder<NameCubit, String>(
       bloc: NameCubit('Nemo'),
       builder: (context, state) => const Dashboard(),
      );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = DashboardViweILazy18N(context);
    final name = context.read<NameCubit>().state;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title:  BlocBuilder<NameCubit, String>(builder: (context, state){
          return Text("Welcome $state");
        },),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // eixo main na vertical
        crossAxisAlignment: CrossAxisAlignment.start,
        // eixo main na horizontal
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/logo_nu.png'),
          ),
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Cadastre ou acesse sua lista de contact bank",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              )),
          SingleChildScrollView(
            // ajustar o scroll da linha pra n quebrar o width da largura do celular ou poderia usar um listView sobre um container e no listview setar horizontal
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _IconsDashboard(
                  name: i18n.transfer,
                  icon: Icons.monetization_on,
                  onClick: () => _showContactsList(context),
                ),
                _IconsDashboard(
                  name: i18n.transaction_feed,
                  icon: Icons.description,
                  onClick: () => _showTransactionList(context),
                ),
                _IconsDashboard(
                  name: i18n.change_name,
                  icon: Icons.person_outline,
                  onClick: () => _showChangeName(context),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }



  void _showChangeName(BuildContext blocContext) {
    // FirebaseCrashlytics.instance.crash();
    Navigator.of(blocContext).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NameCubit>(blocContext),
          child: const NameContainer(),
        ),
      ),
    );
  }

  void _showContactsList(BuildContext context) {
    // FirebaseCrashlytics.instance.crash();
    push(context,  ContactsListContainer());
  }

  void _showTransactionList(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => TransactionsList()));
  }
}

class DashboardViweILazy18N extends ViewI18N {
  DashboardViweILazy18N(BuildContext context) : super (context);

  String get transfer => localize({'pt-br': 'Transferir', 'en': 'Transfer'});

  String get transaction_feed => localize({'pt-br': 'Transações', 'en': 'Transaction Feed'});

  String get change_name => localize({'pt-br': 'Mudar Nome', 'en': 'Change Name'});
}


class _IconsDashboard extends StatelessWidget {
  const _IconsDashboard({
    Key? key,
    required this.name,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  final String name;
  final IconData icon;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          // Uma área retangular de um material que responde ao toque.
          onTap: () => onClick(),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.deepPurple),
            padding: const EdgeInsets.all(8),
            height: 100,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 32.0,
                  color: Colors.white,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
