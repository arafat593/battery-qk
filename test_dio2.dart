import 'package:dio/dio.dart';

void main() async {
  var dio = Dio();
  dio.options.baseUrl = "https://olabisiolai.maktechlaravel.cloud/api/v1";
  
  try {
    var response = await dio.post("/reviews", data: {"business_id": 8});
    print(response.data);
  } catch (e) {
    if (e is DioException) {
      print("ERR STATUS: ${e.response?.statusCode}");
      print("ERR DATA: ${e.response?.data}");
    }
  }
}
