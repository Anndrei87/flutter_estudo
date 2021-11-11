import 'package:bytebank_contato_2/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import '../app_database.dart';

class ContactDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      'id INTEGER PRIMARY KEY, '
      'name TEXT, '
      'account INTEGER)';

  static const String _tableName = 'contacts';

  Future<int> save(Contact contact) async {
    // return getDatabase().then((db){ linhas 24 a 27})
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap);
  }

  Map<String, dynamic> _toMap(Contact contact) {
     final Map<String, dynamic> contactMap = {};
    contactMap['name'] = contact.name;
    contactMap['account'] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {

    final Database db = await getDatabase(); // get no banco
    final List<Map<String, dynamic>> result = await db.query(_tableName); // salvar o retorno do get em uma variavel do tipo list<map<string, dynamic>>
    List<Contact> contacts = _toList(result);
    return contacts;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = []; // lista para salvar dados
    for (Map<String, dynamic> row in result) {
      final Contact contact = Contact(
        row['name'],
        row['account'],
        row['id'],
      );
      contacts.add(contact);
    }
    return contacts;
  }
}


// SEM O ASYNC
// return getDatabase().then((db) {
//   return db.query('contacts').then((maps) {
//     final List<Contact> contacts = [];
//     for (Map<String, dynamic> row in maps) {
//       final Contact contact = Contact(
//         row['name'],
//         row['account'],
//         row['id'],
//       );
//       contacts.add(contact);
//     }
//     return contacts;
//   });
// });
