import 'dart:typed_data';
import 'package:objectbox/objectbox.dart';

@Entity()
class PdfDocument {
  @Id(assignable: true)
  int id;

  String className;
  String selectedDate;
  Uint8List pdfBytes;

  PdfDocument({
    required this.id,
    required this.className,
    required this.selectedDate,
    required this.pdfBytes,
  });
}
