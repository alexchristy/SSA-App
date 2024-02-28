// pdf_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

import '../screens/pdf-view/pdf_view_page.dart';

class PDFService {
  final Logger _logger = Logger('PDFService');

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<String?> downloadPdf(String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = path.join(dir.path, fileName);
      await Dio().download(url, filePath);
      return filePath;
    } catch (e) {
      _logger.warning("Error downloading file: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchPdfDetails(String hash) async {
    var doc = await FirebaseFirestore.instance
        .collection('PDF_Archive')
        .doc(hash)
        .get();
    return doc.exists ? doc.data() : null;
  }

  void openPdf(BuildContext context, String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PDFViewPage(filePath: filePath)),
    );
  }
}
