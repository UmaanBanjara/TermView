import 'dart:convert';

import 'package:http/http.dart' as http;

class SignupRepository {
  final String baseUrl = 'https://termview.onrender.com';

  Future<Map<String , dynamic>> signup({
    required String fname,
    required String lname,
    required String username,
    required String email,
    required String password,
  })async{ 
    final reponse = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {
        "Content-Type" : 'application/json'
      },
      body: jsonEncode({
        "fname" : fname,
        "lname" : lname,
        "username" : username,
        "email" : email,
        "password" : password
      })
    );
    if(reponse.statusCode == 200){
      return jsonDecode(reponse.body);
    }else{
      throw Exception(jsonDecode(reponse.body)['detail']??"Something went wrong");
    }
  }
}