// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_extend/share_extend.dart';

class PDFViewerScreen extends StatefulWidget {
  final String path;

  const PDFViewerScreen({Key? key, required this.path, required}) : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  PDFViewController? _pdfViewController;
  // ignore: unused_field
  int _totalPages = 0;
  bool _isLoading = true;
  // ignore: unused_field

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar PDF'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save_alt,
              color: Colors.white,
            ),
            onPressed: () {},
          ),

          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              _sharePDF(widget.path);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.path,
            onViewCreated: (PDFViewController pdfViewController) {
              _pdfViewController = pdfViewController;
              _initPDF();
            },
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }

  void _initPDF() async {
    final total = await _pdfViewController!.getPageCount() ?? 0;

    setState(() {
      _totalPages = total;
      _isLoading = false;
    });
  }

  void _sharePDF(String filePath) {
    ShareExtend.share(filePath, "file", 
    sharePanelTitle: "Enviar PDF", 
    subject: "ListChamada-pdf");
  }
}
