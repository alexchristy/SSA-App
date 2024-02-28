// A new widget to display the PDF
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewPage extends StatelessWidget {
  final String filePath;

  const PDFViewPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Document"),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
