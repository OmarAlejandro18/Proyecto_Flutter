import 'package:flutter/material.dart';
import 'package:notas_isadata/home/agregar_nota.dart';
import 'package:notas_isadata/home/buscar_notas.dart';
import 'package:notas_isadata/home/comentarios.dart';
import 'package:notas_isadata/home/editar_nota.dart';
import 'package:notas_isadata/home/home_page.dart';
import 'package:notas_isadata/home/opciones_tema.dart';

Map<String, WidgetBuilder> getRutasVentanas() {
  return <String, WidgetBuilder>{
    "/": (BuildContext context) => const HomePage(),
    "AgregarNota": (BuildContext context) => const AgregarNota(),
    "EditarNota": (BuildContext context) => const EditarNota(),
    "Comentarios": (BuildContext context) => const Comentarios(),
    "BuscarNotaPage": (BuildContext context) => const SearchNotePage(),
    "TemaPage": (BuildContext context) => const OpcionTemas(),
  };
}
