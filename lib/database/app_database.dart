import 'package:bytebank_contato_2/database/dao/contact_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db'); // essa linha so sera executada apos a resposta do getdatabase
  return openDatabase(path, onCreate: (db, version) {
         db.execute(ContactDao.tableSql);
         }, version: 1);
  // onDowngrade: onDatabaseDowngradeDelete); altera a versão, vai onde quer que apague os dados, dps volta para  versão anterior

  // return getDatabasesPath().then((dbPah){
  //   final String path = join(dbPath, 'bytebank.db');
  //   return openDatabase(path)...
  // })
}

