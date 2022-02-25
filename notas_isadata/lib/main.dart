import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notas_isadata/constant/routes.dart';
import 'package:notas_isadata/constant/tema_principal.dart';
import 'package:notas_isadata/providers/icono_provider.dart';
import 'package:notas_isadata/providers/tema_provider.dart';
import 'package:notas_isadata/sqlite/sqlite_query.dart';

main() {
  runApp(
    const AppNotas(),
  );
}

class AppNotas extends StatelessWidget {
  const AppNotas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SQLiteQuery()),
        ChangeNotifierProvider(create: (context) => IconoProvider()),
        ChangeNotifierProvider(
            create: (context) => ThemeChanger(temaPrincipal()))
      ],
      child: const MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notas Flutter",
      theme: theme.getTheme(),
      initialRoute: "/",
      routes: getRutasVentanas(),
    );
  }
}
