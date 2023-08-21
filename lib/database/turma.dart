import 'package:objectbox/objectbox.dart';
import 'aluno.dart';

@Entity()
class Turma {
  @Id(assignable: true)
  int id;

  String nome;
  final alunos = ToMany<Aluno>(); // Lista de alunos associados

  Turma({required this.id, required this.nome});
}


