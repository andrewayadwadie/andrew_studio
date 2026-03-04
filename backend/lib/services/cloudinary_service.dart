import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName;
  final String apiKey;
  final String apiSecret;
  final String uploadPreset;

  CloudinaryService()
      : cloudName = Platform.environment['CLOUDINARY_CLOUD_NAME']!,
        apiKey = Platform.environment['CLOUDINARY_API_KEY']!,
        apiSecret = Platform.environment['CLOUDINARY_API_SECRET']!,
        uploadPreset = Platform.environment['CLOUDINARY_UPLOAD_PRESET']!;

  String get _uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  /// Upload raw bytes (from AI generation or device upload)
  Future<String> uploadBytes(List<int> bytes, {String? folder}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final folderParam = folder != null ? 'folder=$folder&' : '';
    final sigString =
        '${folderParam}timestamp=$timestamp&upload_preset=$uploadPreset$apiSecret';
    final signature =
        sha1.convert(utf8.encode(sigString)).toString();

    final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl))
      ..fields['api_key'] = apiKey
      ..fields['timestamp'] = timestamp.toString()
      ..fields['signature'] = signature
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: 'image.jpg'),
      );

    if (folder != null) request.fields['folder'] = folder;

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final json = jsonDecode(body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception('Cloudinary upload failed: ${json['error']?['message']}');
    }

    return json['secure_url'] as String;
  }

  /// Upload from a public URL (e.g. Unsplash)
  Future<String> uploadFromUrl(String imageUrl, {String? folder}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final folderParam = folder != null ? 'folder=$folder&' : '';
    final sigString =
        '${folderParam}timestamp=$timestamp&upload_preset=$uploadPreset$apiSecret';
    final signature =
        sha1.convert(utf8.encode(sigString)).toString();

    final response = await http.post(
      Uri.parse(_uploadUrl),
      body: {
        'file': imageUrl,
        'api_key': apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
        'upload_preset': uploadPreset,
        if (folder != null) 'folder': folder,
      },
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception('Cloudinary upload failed: ${json['error']?['message']}');
    }

    return json['secure_url'] as String;
  }
}
