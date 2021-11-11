import 'package:bytebank_contato_2/components/container.dart';
import 'package:bytebank_contato_2/components/progress.dart';
import 'package:bytebank_contato_2/database/dao/contact_dao.dart';
import 'package:bytebank_contato_2/models/contact.dart';
import 'package:bytebank_contato_2/screens/formulario.dart';
import 'package:bytebank_contato_2/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class ContactsListState {
  const ContactsListState();
}

@immutable
class LoadingContacsListState extends ContactsListState {
  const LoadingContacsListState();
}

@immutable
class InitContactsListState extends ContactsListState {
  const InitContactsListState();
}

@immutable
class LoadedContactsList extends ContactsListState {
  final List<Contact> _contacts;

  const LoadedContactsList(this._contacts);
}

class FatalErrorContactsList extends ContactsListState {
  const FatalErrorContactsList();
}

class ContactsListCubit extends Cubit<ContactsListState> {
  ContactsListCubit() : super(const InitContactsListState());

  void reload(ContactDao dao) async {
    emit(const LoadingContacsListState());
    final List<Contact> teste = await dao.findAll();
    emit(LoadedContactsList(teste));
  }
}

class ContactsListContainer extends BlocContainer {
  ContactsListContainer({Key? key}) : super(key: key);
  final ContactDao dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsListCubit>(
      create: (context) {
        final cubit = ContactsListCubit();
        cubit.reload(dao);
        return cubit;
      },
      child: ContactsList(dao),
    );
  }
}

class ContactsList extends StatefulWidget {
  final ContactDao _dao;

  const ContactsList(this._dao, {Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState(_dao);
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao;

  _ContactsListState(this._dao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Transfer'),
      ),
      body: BlocBuilder<ContactsListCubit, ContactsListState>(
          builder: (context, state) {
        if (state is InitContactsListState ||
            state is LoadingContacsListState) {
          return const Progress();
        }
        if (state is LoadedContactsList) {
          final contacts =
              state._contacts; // acessa o conteudo da resposta do findAll
          return ListView.builder(
            itemBuilder: (context, int index) {
              final Contact contact = contacts[index];
              return _ContactItem(
                contact: contact,
                onClick: () =>
                    {push(context, TransactionFormContainer(contact))},
              );
            },
            itemCount: contacts.length,
          );
        }
        return const Text('Unknown error');
      }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ContactForm()));
            context
                .read<ContactsListCubit>()
                .reload(_dao); // atualizar a lista do FutureBuilder
          },
          child: const Icon(Icons.add)),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  const _ContactItem({Key? key, required this.contact, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () => onClick(),
      title: Text(
        contact.name,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
      subtitle: Text(contact.accountNumber.toString(),
          style: const TextStyle(fontSize: 16)),
    ));
  }
}
