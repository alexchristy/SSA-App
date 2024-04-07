import 'package:flutter/material.dart';
import 'package:ssa_app/utils/pdf_utils.dart';
import 'package:path/path.dart' as path;

class TerminalDetailPage extends StatelessWidget {
  final Map<String, dynamic> terminalData;
  final PDFService _pdfService = PDFService();
  static const Key testKey = Key('TerminalDetailPage');

  TerminalDetailPage({super.key, required this.terminalData});

  @override
  Widget build(BuildContext context) {
    // All your existing method implementations (requestStoragePermission, downloadPdf, fetchPdfDetails, openPdf)

    // Existing Scaffold and body setup...
    return Scaffold(
      appBar: AppBar(
        title: Text(terminalData['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...buildPdfButtons(
                  context), // This dynamically creates your buttons
              // Any other widgets you want to include
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildPdfButtons(BuildContext context) {
    List<Widget> buttons = [];
    Map<String, String> pdfLabels = {
      'pdf72HourHash': '72 Hour Schedule',
      'pdf30DayHash': '30 Day Schedule',
      'pdfRollcallHash': 'Rollcall Schedule',
    };

    pdfLabels.forEach((hashKey, label) {
      String? hash = terminalData[hashKey];
      if (hash != null && hash.isNotEmpty) {
        buttons.add(ElevatedButton(
          child: Text(label),
          onPressed: () async {
            await _pdfService.requestStoragePermission();
            var pdfDetails = await _pdfService.fetchPdfDetails(hash);
            if (pdfDetails != null) {
              final fileName = path.basename(pdfDetails['cloud_path']);
              final filePath =
                  await _pdfService.downloadPdf(pdfDetails['link'], fileName);
              if (filePath != null) {
                _pdfService.openPdf(context, filePath);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not download PDF.')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF details not found.')),
              );
            }
          },
        ));
      }
    });

    return buttons;
  }
}
