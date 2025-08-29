import 'dart:convert';

import 'package:http/http.dart' as http;

class DelaccRepository {
  final String baseUrl = 'http://192.168.1.6:8000';

  Future<Map<String , dynamic>> delacc({
    required String old_p,
    required String token
  })async{
    final response = await http.post(
      Uri.parse('$baseUrl/auth/delacc'),
      headers: {
        'Authorization' : 'Bearer $token',
        'Content-Type' : 'application/json'
      },
      body: jsonEncode({
        "old_p" : old_p
      })
    );
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception(jsonDecode(response.body)['detail'] ?? "Something went wrong");
    }
  }
}