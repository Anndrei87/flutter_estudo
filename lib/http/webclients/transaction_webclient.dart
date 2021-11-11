import 'dart:convert';
import 'package:bytebank_contato_2/http/interceptors/logging_interceptor.dart';
import 'package:bytebank_contato_2/models/transaction.dart';
import 'package:bytebank_contato_2/webapi/webcliente.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

class TransactionWebClient {


  Future<List<Transaction>> findAll() async {
    const String uri = 'http://10.0.0.106:8080/transactions'; // para simular url de api é melhor usar o end IP para o emulador acompanhar
    final Response response = await client.get(Uri.parse(uri)); // timout usado para controlar o tempo de requisição caso o end ip estiver errado;
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json) => Transaction.fromJson(json)).toList();
    //final List<Transaction> transaction = decodedJson.map((dynamic json) => Transaction.fromJson(json)).toList(); // converte o interable em uma lista
    // final List<Transaction> transaction = [];
    // for (Map<String, dynamic> elements in decodedJson) {// percorrer o objt json e colocar em uma lista
    //   transaction.add(Transaction.fromJson(elements));
    // }
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson()); // converte o objt dart para o objt json
    const String uri = 'http://10.0.0.106:8080/transactions';

    final Response response = await client.post(Uri.parse(uri),
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJson);

    if(response.statusCode == 400){
      throw Exception('Aconteceu um erro ao enviar uma transferencia');
    }
    if(response.statusCode == 401){
      throw Exception('Falha na autenticação');
    }
    if(response.statusCode == 409){
      throw Exception('Essa transação ja foi feita');
    }
    return Transaction.fromJson(jsonDecode(response.body));
  }
}