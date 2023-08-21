// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, sort_child_properties_last, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously

import 'package:dsf1/printPDF/print_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:dsf1/database/turma.dart';
import 'package:dsf1/database/aluno.dart';
import 'package:dsf1/database/database_helper.dart';
//import 'package:logger/logger.dart';

class MyHomePage extends StatefulWidget {
  final Turma turma;
  const MyHomePage({Key? key, required this.turma}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Aluno> alunos = [];
  List<Aluno> alunosSelecionados = [];
  List<bool> presencaAlunos = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getAlunosDaTurma();
  }

  void getAlunosDaTurma() {
    for (final aluno in widget.turma.alunos) {
      alunosSelecionados.add(aluno);

      setState(() {
        presencaAlunos.add(false);
      });
    }
  }

//=========================================< Scaffold >=========================================//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nova Turma',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 8),
            Container(
              margin: EdgeInsets.only(right: 60),
              child: Icon(
                Icons.groups_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      //===================================< Body >============================================//

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (alunosSelecionados.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Insira alunos clicando no botão abaixo',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),

            //============================< Inserir Dados >=======================================//

            if (alunosSelecionados.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                //===============< Editar Turma >========================================//

                                Text(
                                  'Turma: ${widget.turma.nome}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _editTurmaName(context);
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),

                          //=======================< Inserir Data >=======================================//

                          Text(
                            'Dia: ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              _showDatePopup(context);
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                        ],
                      ),

                      //=====================================================< ListView Builder >======================================================//

                      ListView.builder(
                        itemCount: alunosSelecionados.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          int displayIndex = index + 1;

                          //==================< Container >======================================//

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: EdgeInsets.only(bottom: 5.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 216, 214, 214),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),

                                //========================< Nomes >==========================//

                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          '$displayIndex - ${alunosSelecionados[index].nome}',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),

                                    //===================< Botão Presença >===================//

                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          presencaAlunos[index] =
                                              !presencaAlunos[index];
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: presencaAlunos[index]
                                            ? Colors.green
                                            : Colors.red,
                                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        presencaAlunos[index]
                                            ? "Presente"
                                            : "Ausente",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),

                                    //=====================< DropDown >=======================//

                                    IconButton(
                                      icon: Icon(Icons.person,
                                          color: Colors.blue),
                                      onPressed: () {
                                        _showDropDownMenu(context, index);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              //====================< Editar Slidable >======================//

                              secondaryActions: [
                                IconSlideAction(
                                  caption: 'Ver Perfil',
                                  color: Colors.deepPurple,
                                  icon: Icons.person,
                                  onTap: () {
                                    // metodo ver perfil
                                  },
                                ),

                                //===================< Excluir Slidable >======================//

                                IconSlideAction(
                                  caption: 'Excluir',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {},
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

            //============================< Botão Limpar Tudo >=================================//

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (alunosSelecionados.isNotEmpty)
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmar'),
                            content: Text(
                              'Isso removerá todos os alunos da lista da turma atual. Deseja continuar?',
                            ),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close, color: Colors.red),
                              ),
                              IconButton(
                                onPressed: () async {
                                  Turma turmaAtual = widget.turma;
                                  DatabaseHelper.excluirAlunosDaTurma(
                                      turmaAtual);

                                  setState(() {
                                    alunosSelecionados.clear();
                                    presencaAlunos.clear();
                                    selectedDate = DateTime.now();
                                  });
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.check, color: Colors.green),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(
                      'Limpar',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),

                //==================< Botao Adicionar Aluno >===============================//

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _carregarAlunos();
                      if (alunos.isNotEmpty) {
                        _mostrarDialogAlunos();
                      } else {
                        _mostrarSnackbar(context, 'Não há alunos disponíveis para seleção!');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: Text(
                      'Adicionar Aluno',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ),

                //=====================< Botao Relatorio >==================================//

                if (alunosSelecionados.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      DatabaseHelper.printTurmasEAlunos();
                      //printTurmas(_logger);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyPrintPage(
                            alunos: alunosSelecionados,
                            presencaAlunos: presencaAlunos,
                            selectedDate: DateFormat('dd/MM/yyyy').format(selectedDate),
                            className: widget.turma.nome,
                          ),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(
                      'Relatório',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//=======================================< Alunos Selecionar >============================================//

  Future<void> _carregarAlunos() async {
    alunos = DatabaseHelper.alunoBox.getAll();
  }

  void _mostrarDialogAlunos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione Alunos'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: alunos.map((aluno) {
                return ListTile(
                  title: Text(aluno.nome),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Matrícula: ${aluno.matricula}'),
                    ],
                  ),
                  onTap: () async {
                    if (!alunosSelecionados.contains(aluno)) {
                      DatabaseHelper.adicionarAlunoNaTurma(aluno, widget.turma);

                      setState(() {
                        alunosSelecionados.add(aluno);
                        presencaAlunos.add(false);
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  //=============================< Mostrar DropDownMenu >=================================//

  void _showDropDownMenu(BuildContext context, int index) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem<String>(
          value: 'ver',
          child: Text('Ver Perfil'),
        ),
      ],
    ).then(
      (value) {
        if (value == 'ver') {
          //metodo pra ver perfil
        }
      },
    );
  }

//=======================================< Inserir Data >==============================================//

  void _showDatePopup(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

//=======================================< Editar Turma >============================================//

  void _editTurmaName(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String updatedClassName = widget.turma.nome;

        return AlertDialog(
          title: Text("Editar Nome da Turma"),
          content: TextField(
            onChanged: (value) {
              updatedClassName =
                  value; // Atualiza o valor conforme o usuário digita
            },
            maxLength: 8,
            controller: TextEditingController(
                text: widget.turma.nome), // Define o valor atual no TextField
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: Colors.red),
            ),
            IconButton(
              onPressed: () async {
                if (updatedClassName.isNotEmpty) {
                  widget.turma.nome = updatedClassName;
                  DatabaseHelper.turmaBox.put(widget.turma);

                  _mostrarSnackbar(
                      context, 'Nome da turma editado com sucesso!');
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.check, color: Colors.green),
            ),
          ],
        );
      },
    );
  }

//============================================< SnackBar >==============================================//

  void _mostrarSnackbar(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

//=============================================< Fim >===============================================//