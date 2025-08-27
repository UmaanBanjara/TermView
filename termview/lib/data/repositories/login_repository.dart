import 'dart:convert';

import 'package:http/http.dart' as http;


class LoginRepository {
  final String baseUrl = 'http://192.168.1.6:8000';

  Future<Map<String , dynamic>> login({
    required String email,
    required String password,
  })async{
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type' : 'application/json'
      },
      body: jsonEncode({
        "email" : email,
        "password" : password
      })
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception(jsonDecode(response.body)['detail'] ?? "Something went wrong");
    }
  }
}