// ignore_for_file: unnecessary_import, depend_on_referenced_packages

import 'package:objectbox/objectbox.dart';
import 'aluno.dart';
import 'turma.dart';
import 'objectbox.g.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final Logger _logger = Logger();
  static late Store _store;
  static late Box<Aluno> _alunoBox;
  static late Box<Turma> _turmaBox;

//==========================================< inicializar >========================================//

  static Future<Store> init() async {
    try {
      final model = getObjectBoxModel();

      final appDocDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocDir.path, 'teacherDB');

      _store = Store(model, directory: dbPath);
      _alunoBox = Box<Aluno>(_store);
      _turmaBox = Box<Turma>(_store);

      _logger.d("Banco de dados criado com sucesso em: $dbPath");

      //clearDatabase();

      return _store;
    } catch (e) {
      _logger.e("Erro ao criar o banco de dados: $e");
      rethrow;
    }
  }

//==========================================< insert >========================================//

  static Box<Aluno> get alunoBox => _alunoBox;
  static Box<Turma> get turmaBox => _turmaBox;

  static void insertAluno(Aluno aluno) {
    try {
      _alunoBox.put(aluno);
      _logger.d("Aluno inserido com sucesso: ${aluno.nome}");
    } catch (e) {
      _logger.e("Erro ao inserir aluno: $e");
      rethrow;
    }
  }

  static void insertTurma(Turma turma) {
    try {
      _turmaBox.put(turma);
      _logger.d("Turma inserida com sucesso: ${turma.nome}");
    } catch (e) {
      _logger.e("Erro ao inserir turma: $e");
      rethrow;
    }
  }

//==========================================< Add Aluno a Turma >========================================//

  static void adicionarAlunoNaTurma(Aluno aluno, Turma turma) {
    try {
      turma.alunos.add(aluno);
      aluno.turmas.add(turma);

      _turmaBox.put(turma);
      _alunoBox.put(aluno);

      // Imprimir os alunos da turma após a associação
      //printTurmasEAlunos();
      //printAlunos();
    } catch (e) {
      _logger.e("Erro ao adicionar aluno à turma: $e");
      rethrow;
    }
  }

//=======================================< Remov Aluno da Turma >========================================//

//=======================================< Remov Todos da Turma >========================================//

  static void excluirAlunosDaTurma(Turma turma) {
    try {
      for (final aluno in turma.alunos) {
        aluno.turmas.remove(turma);
        _alunoBox.put(aluno);
      }

      turma.alunos.clear();
      _turmaBox.put(turma);

      printTurmasEAlunos();
      //printAlunos();

      _logger.d("Alunos removidos da turma ${turma.nome}");
    } catch (e) {
      _logger.e("Erro ao excluir alunos da turma: $e");
      rethrow;
    }
  }

//=======================================< Remov Todas as Turmas >========================================//

  static void excluirTodasAsTurmas() {
    try {
      final alunos = _alunoBox.getAll();

      // Remove referências das turmas nos alunos
      for (final aluno in alunos) {
        aluno.turmas.clear();
        _alunoBox.put(aluno);
      }

      // Remove todas turmas 
      _turmaBox.removeAll();

      _logger.d(
          "Todas as turmas foram excluídas do banco de dados e as referências dos alunos foram atualizadas");
    } catch (e) {
      _logger.e("Erro ao excluir todas as turmas: $e");
      rethrow;
    }
  }

//=======================================< Remov Todas os Alunos >========================================//

  static void excluirTodosOsAlunos() {
    try {
      final turmas = _turmaBox.getAll();

      // Remove referências dos alunos nas turmas
      for (final turma in turmas) {
        for (final aluno in turma.alunos.toList()) {
          aluno.turmas.remove(turma);
          _alunoBox.put(aluno);
        }
        turma.alunos.clear();
        _turmaBox.put(turma);
      }

      // Remove todos os alunos
      _alunoBox.removeAll();

      _logger.d(
          "Todos os alunos foram excluídos com sucesso e as referências nas turmas foram atualizadas");
    } catch (e) {
      _logger.e("Erro ao excluir todos os alunos: $e");
      rethrow;
    }
  }

//=======================================< Edita os Alunos >========================================//

  static void updateAlunoNome(int alunoId, String novoNome) {
    final aluno = _alunoBox.get(alunoId);
    if (aluno != null) {
      aluno.nome = novoNome;
      _alunoBox.put(aluno);
    }
  }

  static void updateAlunoMatricula(int alunoId, String novaMatricula) {
    final aluno = _alunoBox.get(alunoId);
    if (aluno != null) {
      aluno.matricula = novaMatricula;
      _alunoBox.put(aluno);
    }
  }

  static void updateAlunoIdade(int alunoId, int novaIdade) {
    final aluno = _alunoBox.get(alunoId);
    if (aluno != null) {
      aluno.idade = novaIdade;
      _alunoBox.put(aluno);
    }
  }

  static void updateAlunoSerie(int alunoId, String novaSerie) {
    final aluno = _alunoBox.get(alunoId);
    if (aluno != null) {
      aluno.serie = novaSerie;
      _alunoBox.put(aluno);
    }
  }

  //==========================================< Check Matricula >========================================//

  static Future<bool> checkMatriculaExists(String matricula) async {
    try {
      final query = _alunoBox
          .query(
            Aluno_.matricula.equals(matricula),
          )
          .build();

      final results = query.find();
      query.close();

      return results.isNotEmpty; // Retorna true se a matrícula existe
    } catch (e) {
      _logger.e("Erro ao verificar matrícula: $e");
      rethrow;
    }
  }

  static Aluno findAlunoByMatricula(String matricula) {
    final query = _alunoBox.query(Aluno_.matricula.equals(matricula)).build();
    final alunosEncontrados = query.find();

    return alunosEncontrados.first;
  }

//==========================================< Print pra verificar >========================================//

  static void printTurmasEAlunos() {
    try {
      final turmas = _turmaBox.getAll();

      for (final turma in turmas) {
        _logger.d("Turma ${turma.nome}:");

        final alunosAssociados = turma.alunos.toList();
        for (final aluno in alunosAssociados) {
          _logger.d(" - ${aluno.nome} (${aluno.matricula})");
        }
      }
    } catch (e) {
      _logger.e("Erro ao imprimir turmas e alunos: $e");
      rethrow;
    }
  }

//==========================================< Clear database >========================================//

  /* 
    static void clearDatabase() {
      try {
        _alunoBox.removeAll(); // Remove all Aluno objects
        _turmaBox.removeAll(); // Remove all Turma objects
        _logger.d("Banco de dados limpo com sucesso");
      } catch (e) {
        _logger.e("Erro ao limpar o banco de dados: $e");
        rethrow;
      }
    }
  */

  // Métodos para verificar matrícula, remover alunos da turma, remover aluno da turma, etc.
  // Implemente esses métodos de acordo com suas necessidades
}
