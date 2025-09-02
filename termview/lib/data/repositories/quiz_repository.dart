import 'dart:convert';

import 'package:http/http.dart' as http;

class QuizRepository {
  final String baseUrl = 'https://termview.onrender.com';

  Future<Map<String , dynamic>> quiz({
    required String token,
    required String ques,
    required String a1,
    required String a2,
    required String a3,
    required String a4,
    required String ans
  })async{
    final response = await http.post(
      Uri.parse('$baseUrl/quiz/createquiz'),
      headers: {
        'Authorization' : 'Bearer $token',
        'Content-Type' : 'application/json'
      },
      body: jsonEncode({
        "ques" : ques,
        "a1" : a1,
        "a2" : a2, 
        "a3" : a3,
        "a4" : a4,
        "ans" : ans
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