import '../theme.dart';
import 'package:flutter/material.dart';
import 'principal_page.dart';
import 'package:dsf1/database/database_helper.dart';
import 'package:objectbox/objectbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await DatabaseHelper.init(); // Inicializa o banco de dados

  runApp(MyApp(store: store));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.store}) : super(key: key);

  final Store store;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final Store _store;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    ThemeSwitch.setTheme();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _store.close(); // Fecha o banco de dados
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    ThemeSwitch.setTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeSwitch.theme,
      builder: (BuildContext context, Brightness theme, _) => MaterialApp(
        title: 'Sistema de Chamada',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          brightness: theme,
        ),
        home: const PrincipalPage(),
      ),
    );
  }
}
