import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';


class CloudinaryService {
  // ⚡ Tus datos de Cloudinary
  static const String cloudName = "dvw5h3ccw"; // tu cloud_name
  static const String uploadPreset = "flutter"; // tu preset

  static Future<String?> uploadImage(File imageFile) async {
    final mimeType = lookupMimeType(imageFile.path)!.split('/');


    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload"),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ),
    );

    request.fields['upload_preset'] = uploadPreset;

    final response = await request.send();
    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final secureUrl = RegExp(r'"secure_url":"([^"]+)"')
          .firstMatch(resStr)
          ?.group(1)
          ?.replaceAll(r'\/', '/');
      return secureUrl;
    } else {
      throw Exception("Error al subir la imagen: ${response.statusCode}");
    }
  }
}
