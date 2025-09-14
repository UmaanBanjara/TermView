import 'dart:convert';

import 'package:http/http.dart' as http;

class ForpassRepository {
  final String baseUrl = 'https://termview-backend.onrender.com';

  Future<Map<String , dynamic>> forpass({
    required String old_p,
    required String new_p,
    required String token,
  })async{
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forpass'),
      headers: {
        'Authorization' : 'Bearer $token',
        'Content-Type' : 'application/json'
      },
      body: jsonEncode({
        "old_p" : old_p,
        "new_p" : new_p,
      })
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception(jsonDecode(response.body)['detail']?? "Something went wrong");
    }
  }
}