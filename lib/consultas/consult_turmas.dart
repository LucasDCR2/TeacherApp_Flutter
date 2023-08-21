// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dsf1/theme.dart';
import 'package:dsf1/main/home_page.dart';
import 'package:logger/logger.dart';
import 'package:dsf1/database/turma.dart';
import 'package:dsf1/database/database_helper.dart';

class ConsultTurmasPage extends StatefulWidget {
  const ConsultTurmasPage({super.key});

  @override
  _ConsultTurmasPageState createState() => _ConsultTurmasPageState();
}

class _ConsultTurmasPageState extends State<ConsultTurmasPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Turma> _turmas = [];
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    loadTurmas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Turmas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                filterTurmas(value);
              },
              decoration: InputDecoration(
                labelText: 'Pesquisar por nome da turma',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),

          //============================< ListBuilder >=============================//

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: ThemeSwitch.containerBackgroundColor
              ),
              child: _turmas.isEmpty
                  ? Center(
                      child: Text(
                        "Nenhuma turma encontrada.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _turmas.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                  turma: _turmas[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                'Turma ${_turmas[index].id} - ${_turmas[index].nome}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          //============================< Excluir turmas >=============================//

          if (_turmas.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmar Exclusão'),
                      content: Text(
                          'Tem certeza de que deseja excluir todas as turmas?'),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () {
                            DatabaseHelper.excluirTodasAsTurmas();

                            setState(() {
                              _turmas.clear();
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
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              ),
              child: Text(
                'Excluir Todas',
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

//============================< Load Turmas >=============================//

  void loadTurmas() {
    try {
      final turmas = DatabaseHelper.turmaBox.getAll();

      setState(() {
        _turmas = turmas;
      });
    } catch (e) {
      logger.e('Erro ao carregar turmas: $e');
    }
  }

  //============================< Filter turmas >=============================//

  void filterTurmas(String query) {
    setState(() {
      if (query.isEmpty) {
        _turmas = DatabaseHelper.turmaBox.getAll();
      } else {
        _turmas = _turmas.where((turma) {
          final lowerCaseQuery = query.toLowerCase();
          return turma.nome.toLowerCase().contains(lowerCaseQuery) ||
              turma.id.toString().contains(lowerCaseQuery); // Verifica o ID
        }).toList();
      }
    });
  }
}

//====================================< Fim >===================================//