// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'pdf_viewer_page.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:dsf1/database/aluno.dart';

class MyPrintPage extends StatefulWidget {
  final List<Aluno> alunos;
  final List<bool> presencaAlunos;
  final String selectedDate;
  final String className;

  const MyPrintPage({
    super.key,
    required this.alunos,
    required this.presencaAlunos,
    required this.selectedDate,
    required this.className,
  });

  @override
  _MyPrintPageState createState() => _MyPrintPageState();
}

class _MyPrintPageState extends State<MyPrintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumo Geral'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Turma: ${widget.className}           '
                  'Data: ${widget.selectedDate}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),

              //================================< body >=================================>//

              for (int index = 0; index < widget.alunos.length; index++)
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //=======================< Aluno e presença >===========================>//
                            Text(
                              'Aluno: ${widget.alunos[index].nome}',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Presença: ${widget.presencaAlunos[index] ? "Presente" : "Ausente"}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Divider(),
                          ],
                        ),
                      ),

                      //========================< Icone Presença >=================================>//

                      Icon(
                        widget.presencaAlunos[index]
                            ? Icons.check
                            : Icons.close,
                        color: widget.presencaAlunos[index]
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                ),

              //================================< Criar PDF >=================================>//

              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await _createPDF();
                          final dir = await getApplicationDocumentsDirectory();
                          final path = '${dir.path}/ListChamada.pdf';

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerScreen(
                                path: path,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.print),
                      ),
                      Text('Gerar PDF'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createPDF() async {
    final pdf = pw.Document();

    final List<pw.TableRow> tableRows = [];
    for (int index = 0; index < widget.alunos.length; index++) {
      tableRows.add(
        pw.TableRow(
          children: [
            pw.Container(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text(
                '${index + 1} - ${widget.alunos[index].nome}',
                style: pw.TextStyle(fontSize: 30),
              ),
            ),
            pw.Container(
              padding: pw.EdgeInsets.all(8.0),
              alignment: pw.Alignment.center,
              child: pw.Text(
                widget.presencaAlunos[index] ? 'Presente' : 'Ausente',
                style: pw.TextStyle(
                  color: widget.presencaAlunos[index]
                      ? PdfColors.green
                      : PdfColors.red,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Container(
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Turma: ${widget.className}     -     ',
                  style: pw.TextStyle(
                      fontSize: 30, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  widget.selectedDate,
                  style: pw.TextStyle(
                      fontSize: 30, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
          // Espaço em branco após o texto
          pw.SizedBox(height: 20),
          // Tabela com os dados dos alunos
          pw.Table(
            border: pw.TableBorder.all(),
            children: tableRows,
          ),
        ],
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/ListChamada.pdf';

    final file = File(path);
    await file.writeAsBytes(pdfBytes);
  }
}
