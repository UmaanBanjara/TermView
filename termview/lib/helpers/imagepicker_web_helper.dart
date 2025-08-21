import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImagepickerWebHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<Uint8List?> pickImageFromGallery() async{
    try{
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if(pickedFile != null){
        return await pickedFile.readAsBytes();
      }
      else{
        return null;
      }
    }
    catch(err){
      return null;
    }
  }
  
}