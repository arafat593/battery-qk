import 'package:dio/dio.dart';

void main() async {
  var dio = Dio();
  dio.options.baseUrl = "https://olabisiolai.maktechlaravel.cloud/api/v1";
  
  try {
    var response = await dio.get("/businesses/home");
    print("URL: ${response.requestOptions.uri}");
    print("STATUS: ${response.statusCode}");
  } catch (e) {
    if (e is DioException) {
      print("ERR URL: ${e.requestOptions.uri}");
      print("ERR STATUS: ${e.response?.statusCode}");
    }
  }
}
