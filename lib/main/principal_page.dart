// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, use_build_context_synchronously, prefer_const_declarations

import 'package:dsf1/consultas/consult_alunos.dart';
import 'package:flutter/material.dart';
import 'package:dsf1/theme.dart';
import 'home_page.dart';
import 'package:dsf1/database/database_helper.dart';
import 'package:dsf1/database/turma.dart';
import 'package:dsf1/database/aluno.dart';
import 'package:dsf1/consultas/consult_turmas.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TeacherCheck',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.school,
              color: Colors.white,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //=============================< Texto Container >==========================//

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: const Text(
                'Seja bem-vindo ao TeacherCheck!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),

            //=============================< Botoes Container >==========================//

            ValueListenableBuilder(
                valueListenable: ThemeSwitch.theme,
                builder: (context, value, child) {
                  
                  return Container(
                    margin: EdgeInsets.all(20),
                    width: 360,
                    height: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: ThemeSwitch.containerBackgroundColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 60),
                      child: Column(
                        children: [
                          //=============================< Botao Consult Turma >==========================//

                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                width: 280,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/verdd.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ConsultTurmasPage(),
                                      ),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF00AE28),
                                  fixedSize: Size(225, 40),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Consultar Turmas',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.groups_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          //=============================< Botao Consult Aluno >==========================//

                          SizedBox(height: 20),

                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                width: 280,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/laranjj.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ConsultAlunoPage(),
                                      ),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF7D2D),
                                  fixedSize: Size(225, 40),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Consultar Alunos',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.group_add_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          //=============================< Botao Consult Resumo >==========================//

                          SizedBox(height: 20),

                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                width: 280,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/azurr.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0500FF),
                                  fixedSize: Size(225, 40),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Consultar Resumos',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.summarize,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          //=============================< Botao Consult PDF´s >==========================//

                          SizedBox(height: 20),

                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                width: 280,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/roxx.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFDB00FF),
                                  fixedSize: Size(225, 40),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Consultar PDFs',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),

      //=============================< bottom botoes >==========================//

      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //=============================< botao aluno >==========================//

          ElevatedButton(
            onPressed: () {
              _addAluno(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              minimumSize: const Size(180, 40),
            ),
            child: const Text(
              'Novo Aluno',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),

          //=============================< botao turma>==========================//

          ElevatedButton(
            onPressed: () {
              _showTurmaName(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(180, 40),
            ),
            child: const Text(
              'Nova Turma',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

//====================================< Add Turma >=============================//

  void _showTurmaName(BuildContext context) {
    String className = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Inserir Nome da Turma"),
          content: TextField(
            onChanged: (value) {
              className = value;
            },
            maxLength: 8,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: Colors.red),
            ),
            IconButton(
              onPressed: () {
                if (className.isNotEmpty) {
                  Turma novaTurma = Turma(id: 0, nome: className);
                  DatabaseHelper.insertTurma(novaTurma);

                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        turma: novaTurma,
                      ),
                    ),
                  );
                }
              },
              icon: Icon(Icons.check, color: Colors.green),
            ),
          ],
        );
      },
    );
  }

//====================================< Add Aluno >=============================//

  void _addAluno(BuildContext context) {
    String nomeAlu = '';
    String matriculaAlu = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Text('Adicionar Aluno'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onChanged: (value) {
                    nomeAlu = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome do Aluno',
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    matriculaAlu = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Matrícula do Aluno',
                  ),
                ),
              ],
            ),

            //====================================< Verificar >=============================//

            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child:
                        Text('Cancelar', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 16),
                  TextButton(
                    onPressed: () async {
                      if (nomeAlu.trim().isEmpty ||
                          nomeAlu.length < 2 ||
                          matriculaAlu.trim().isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Erro'),
                              content: Text(
                                  'Campos vazios ou menores que o permitido.'),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.check, color: Colors.green),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        //====================================< Verificar Matricula >=============================//

                        bool matriculaExists =
                            await DatabaseHelper.checkMatriculaExists(
                                matriculaAlu);
                        if (matriculaExists) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Erro'),
                                content: Text(
                                    'A matrícula já existe no banco de dados.'),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon:
                                        Icon(Icons.check, color: Colors.green),
                                  ),
                                ],
                              );
                            },
                          );

                          //====================================< Add Aluno >=============================//
                        } else {
                          Navigator.pop(context);
                          _mostrarSnackbar(
                              context, 'Aluno adicionado com sucesso!');
                          Aluno novoAluno = Aluno(
                              id: 0, nome: nomeAlu, matricula: matriculaAlu);
                          DatabaseHelper.insertAluno(novoAluno);
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepPurple),
                    ),
                    child: Text('Adicionar',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarSnackbar(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

//====================================< Fim >==================================//