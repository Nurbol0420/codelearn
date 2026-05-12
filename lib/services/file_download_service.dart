import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloadService {
  Future<String> downloadFile(String url, String fileName) async {
    try {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (sdkInt >= 30) {
        if (!await Permission.manageExternalStorage.isGranted) {
          final status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            throw Exception('Storage permission denied');
          }
        }
      } else {
        if (!await Permission.storage.isGranted) {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception('Storage permission denied');
          }
        }
      }

      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Unable to get external storage directory');
      }
      final downloadDir = Directory('${directory.path}/Download');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download file');
      }

      final filePath = '${downloadDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception('Failed to open file: ${result.message}');
      }
    } catch (e) {
      throw Exception('Failed to open file: $e');
    }
  }
}
