import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;


class PostRepository {
  final String baseUrl = 'https://termview-backend.onrender.com';

  Future<Map<String , dynamic>> post({
    required String title,
    required String desc,
    required Uint8List fileBytes, //can't directly send file on web , only raw bytes
    required String fileName,
    required bool enableChat,
    required bool islive,
    required String token,
  })async{
    final url = Uri.parse('$baseUrl/auth/upload/thumbnail');
    final request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromBytes('file', fileBytes , filename: fileName)); // attach thumbnail & and send it as File Field

    request.fields['title'] = title; // adding title form field
    request.fields['desc'] = desc; // adding description form field
    request.fields['is_chat'] = enableChat.toString(); // adding enable_chat form field
    request.fields['is_live'] = islive.toString();

    request.headers['Authorization'] = 'Bearer $token';

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception("Failed to upload post : ${response.body}");
    }
    


  }
}