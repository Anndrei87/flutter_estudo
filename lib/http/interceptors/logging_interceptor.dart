

import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract { // usado tambem para interceptar a comunicação pelo console.log
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // utilizado para pegar a o envio da requisição
    // print(data.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    // ... a resposta
    // print(data.toString());
    // print('code: ${data.statusCode}');
    return data;
  }
}