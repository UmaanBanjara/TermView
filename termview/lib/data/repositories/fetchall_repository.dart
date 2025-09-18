import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:termview/models/live_model.dart';

class FetchallRepository {
  final String baseUrl = 'your-render-url';

  Future<List<LiveModel>> fetchall()async{
    final response = await http.get(Uri.parse('$baseUrl/fetch/fetchall'));

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final session = (data['sessions'] as List?) ?? [];
      return session.map((json) => LiveModel.fromJson(json)).toList();

    }
    else{
      throw Exception('Failed to Fetch Live Sessions');
    }
  }

}