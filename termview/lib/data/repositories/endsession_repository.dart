import 'dart:convert';

import 'package:http/http.dart' as http;

class EndsessionRepository {
  final String baseUrl = 'https://termview-backend.onrender.com';

  Future<Map<String,dynamic>> endsession({
    required String post_id,
  })async{
    final response = await http.post(
      Uri.parse('$baseUrl/end/endsession'),
      headers: {
        'Content-Type' : 'application/json'
      },
      body: jsonEncode(
        {
          "id" :int.parse(post_id)
        }
      )
    );
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception("Something went wrong. Please try again");
    }
  }
}