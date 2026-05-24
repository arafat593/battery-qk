import 'package:dio/dio.dart';

void main() async {
  var dio = Dio();
  dio.options.baseUrl = "https://olabisiolai.maktechlaravel.cloud/api/v1";

  try {
    var response = await dio.get("/businesses/4");
    print("STATUS: ${response.statusCode}");
    print("DATA: ${response.data}");
  } catch (e) {
    if (e is DioException) {
      print("ERR STATUS: ${e.response?.statusCode} - ${e.response?.data}");
    } else {
      print("ERROR: $e");
    }
  }
}
