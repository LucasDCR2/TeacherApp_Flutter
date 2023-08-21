// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:dsf1/theme.dart';
import 'package:dsf1/database/aluno.dart';
import 'package:dsf1/database/database_helper.dart';
import 'package:logger/logger.dart';

class ConsultAlunoPage extends StatefulWidget {
  const ConsultAlunoPage({Key? key}) : super(key: key);

  @override
  _ConsultAlunoPageState createState() => _ConsultAlunoPageState();
}

class _ConsultAlunoPageState extends State<ConsultAlunoPage> {
  final Logger logger = Logger();
  List<Aluno> _alunos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAlunos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Alunos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                filterAlunos(value);
              },
              decoration: InputDecoration(
                labelText: 'Pesquisar por nome do aluno',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),

          //============================< List Builder >=============================//

          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: ThemeSwitch.containerBackgroundColor),
              child: ListView.builder(
                itemCount: _alunos.length,
                itemBuilder: (context, index) {
                  final aluno =
                      _alunos[index]; // Pega o aluno correspondente ao índice
                  return GestureDetector(
                    onTap: () => _showAlunoDetails(aluno),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                aluno.nome,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Matrícula: ${aluno.matricula}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showAlunoDetails(aluno);
                                },
                                icon: Icon(Icons.remove_red_eye,
                                    color: Colors.blue),
                              ),

                              IconButton(
                                onPressed: () {
                                 _showNotas(aluno);
                                },
                                icon: Icon(Icons.book, color: Colors.orange),
                              ),

                              IconButton(
                                onPressed: () {
                                  _showAlunoEditPopup(context, aluno);
                                },
                                icon: Icon(Icons.edit, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          //============================< Excluir nomes >=============================//

          if (_alunos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmar Exclusão'),
                        content: Text(
                            'Tem certeza de que deseja excluir todos os alunos?'),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () {
                              DatabaseHelper.excluirTodosOsAlunos();

                              setState(() {
                                _alunos.clear();
                              });

                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.check, color: Colors.green),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  'Excluir Todos',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

//============================< Load Alunos >=============================//

  void loadAlunos() {
    try {
      final alunos = DatabaseHelper.alunoBox.getAll();

      setState(() {
        _alunos = alunos;
      });
    } catch (e) {
      logger.e('Erro ao carregar alunos: $e');
    }
  }

  //============================< Filter alunos >=============================//

  void filterAlunos(String query) {
    setState(() {
      if (query.isEmpty) {
        _alunos = DatabaseHelper.alunoBox.getAll();
      } else {
        _alunos = _alunos.where((aluno) {
          final lowerCaseQuery = query.toLowerCase();
          return aluno.nome.toLowerCase().contains(lowerCaseQuery) ||
              aluno.matricula.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  //=============================< Aluno Details >==============================//

  _showAlunoDetails(Aluno aluno) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: double.infinity,
          color: Theme.of(context).colorScheme.background,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Resumo do Aluno',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: ThemeSwitch.containerBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nome: ${aluno.nome}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            SizedBox(height: 10),
                            Text('Idade: ${aluno.idade ?? "-"}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            SizedBox(height: 180),
                            Text('Nota P1: ${aluno.notaP1 ?? "-"}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            SizedBox(height: 10),
                            Text('Nota P2: ${aluno.notaP2 ?? "-"}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            SizedBox(height: 40),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 170),
                            Text(
                              'Notas: ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 250),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Média:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  aluno.media == null
                                      ? "0.0"
                                      : aluno.media.toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Matrícula: ${aluno.matricula}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            SizedBox(height: 10),
                            Text('Série: ${aluno.serie ?? "-"}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            SizedBox(height: 180),
                            Text('Nota T1: ${aluno.notaT1 ?? "-"}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            SizedBox(height: 10),
                            Text('Nota T2: ${aluno.notaT2 ?? "-"}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            SizedBox(height: 40),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  

  void _showAlunoEditPopup(BuildContext context, Aluno aluno) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes do Aluno'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text('Nome:'),
                  SizedBox(width: 8),
                  Text(aluno.nome),
                  IconButton(
                    onPressed: () {
                      // Função para editar o nome do aluno
                    },
                    icon: Icon(Icons.edit, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.format_list_numbered),
                  SizedBox(width: 8),
                  Text('Matrícula:'),
                  SizedBox(width: 8),
                  Text(aluno.matricula),
                  IconButton(
                    onPressed: () {
                      // Função para editar a matrícula do aluno
                    },
                    icon: Icon(Icons.edit, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.cake),
                  SizedBox(width: 8),
                  Text('Idade:'),
                  SizedBox(width: 8),
                  Text(aluno.idade?.toString() ?? "-"),
                  IconButton(
                    onPressed: () {
                      // Função para editar a idade do aluno
                    },
                    icon: Icon(Icons.edit, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.school),
                  SizedBox(width: 8),
                  Text('Série:'),
                  SizedBox(width: 8),
                  Text(aluno.serie ?? "-"),
                  IconButton(
                    onPressed: () {
                      // Função para editar a série do aluno
                    },
                    icon: Icon(Icons.edit, color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      },
    );
  }

  void _showNotas(Aluno aluno) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notas do Aluno'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nota P1: ${aluno.notaP1 ?? "-"}'),
              SizedBox(height: 8),
              Text('Nota P2: ${aluno.notaP2 ?? "-"}'),
              SizedBox(height: 8),
              Text('Nota T1: ${aluno.notaT1 ?? "-"}'),
              SizedBox(height: 8),
              Text('Nota T2: ${aluno.notaT2 ?? "-"}'),
              SizedBox(height: 8),
              Text('Média: ${aluno.media ?? "-"}'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}

//====================================< Fim >===================================//