import 'package:objectbox/objectbox.dart';
import 'turma.dart';

@Entity()
class Aluno {
  @Id(assignable: true)
  int id;

  String nome;
  String matricula;
  int? idade;
  String? serie;
  double? notaP1 = 0.0;
  double? notaP2 = 0.0;
  double? notaT1 = 0.0;
  double? notaT2 = 0.0; 
  double? media = 0.0; // Campo média
  final turmas = ToMany<Turma>();

  Aluno({
    required this.id,
    required this.nome,
    required this.matricula,
    this.idade,
    this.serie,
    this.notaP1,
    this.notaP2,
    this.notaT1,
    this.notaT2,
    this.media,
  }) {
    // Calcular a média com base nas notas
    if (notaP1 != null && notaP2 != null && notaT1 != null && notaT2 != null) {
      media = (notaP1! + notaP2! + notaT1! + notaT2!) / 4;
    }
  }
}
