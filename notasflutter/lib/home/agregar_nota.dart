import 'package:flutter/Material.dart';
import 'package:notasflutter/sqlite/modelo/nota.dart';
import 'package:notasflutter/sqlite/sqlite_insertar.dart';

class AgregarNota extends StatefulWidget {
  const AgregarNota({Key? key}) : super(key: key);

  @override
  State<AgregarNota> createState() => _AgregarNotaState();
}

class _AgregarNotaState extends State<AgregarNota> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Agregar Nota"),
      ),
      body: const Formulario(),
    );
  }
}

class Formulario extends StatefulWidget {
  const Formulario({Key? key}) : super(key: key);

  @override
  State<Formulario> createState() => FormularioState();
}

class FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _colorController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _activarAlarma = TextEditingController();

  @override
  void initState() {
    super.initState(); // 0xFF009688
    _colorController = TextEditingController(text: "0xFF616161");
  }

  int _selectedColor = 0;
  double margen = 25.0;
  String _fecha = "";
  String _fechaEditada = "";
  String _hora = "";
  String _horaEditada = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: margen,
        left: margen,
        top: 25,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(children: [
                const Text(
                  "Notificación",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 176,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notification_add_sharp,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _activarAlarma.text = "false";
                    });
                    _showDialog(context);
                  },
                  autofocus: false,
                ),
              ]),
              const SizedBox(
                height: 25,
              ),
              _formTitulo(),
              const SizedBox(
                height: 20,
              ),
              _formDescripcion(),
              const SizedBox(
                height: 20,
              ),
              /*_formColor(),
              const SizedBox(
                height: 15,
              ),*/
              Row(
                children: [
                  const Text(
                    "Color Nota",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 185,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.border_color_sharp,
                      size: 30,
                    ),
                    onPressed: () {
                      showColorDialog(context);
                      FocusScope.of(context).unfocus();
                    },
                    autofocus: false,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                label: const Text("Agregar"),
                icon: const Icon(Icons.save),
                onPressed: () => _guardar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _formColor() {
    return TextFormField(
      controller: _colorController,
      maxLines: 1,
      decoration: const InputDecoration(
        labelText: "Color de Nota",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      onTap: () {
        showColorDialog(context);
        FocusScope.of(context).unfocus();
      },
      enableInteractiveSelection: false,
    );
  }

  final List<String> colorNames = [
    "Azul Light",
    "Cafe Light",
    "Cafe",
    "Gris",
    "Naranja",
    "Peach",
    "Purpura Light",
    "Rojo",
    "Teal Light",
    "Teal",
    "Verde Light",
  ];

  void showColorDialog(BuildContext context) {
    Map<String, Color> _finalcolor = {
      "Azul Light": const Color(0xFF2196F3),
      "Cafe Light": const Color(0xFF795548),
      "Cafe": const Color(0xFF3E2723),
      "Gris": const Color(0xFF636363),
      "Naranja": const Color(0xFFFC571D),
      "Peach": const Color(0xFFE47C73),
      "Purpura Light": const Color(0xFF673AB7),
      "Rojo": const Color(0xFFF44336),
      "Teal Light": const Color(0xFF009688),
      "Teal": const Color(0xFF004D40),
      "Verde Light": const Color(0xFF36B37B),
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Color'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: colorNames.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.brightness_1,
                      color: _finalcolor[colorNames[index]]),
                  title: Text(colorNames[index]),
                  onTap: () {
                    _selectedColor = _finalcolor[colorNames[index]]!.value;
                    _colorController.text = _selectedColor.toString();
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Seleccione Fecha & Hora"),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _formFecha(context),
                const SizedBox(
                  height: 15,
                ),
                _formHora(context),
              ],
            ),
          ),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Ok"),
            )
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        );
      },
    );
  }

  TextFormField _formTitulo() {
    return TextFormField(
      controller: _tituloController,
      maxLength: 50,
      validator: (valor) => _validarTitulo(valor!),
      decoration: const InputDecoration(
        labelText: "Titulo",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

//FORMULARIO DEL CAMPO DESCRIPCIÓN DE LA TAREA
  TextFormField _formDescripcion() {
    return TextFormField(
      controller: _descripcionController,
      maxLength: 200,
      maxLines: 3,
      validator: (valor) => _validarDescripcion(valor!),
      decoration: const InputDecoration(
        labelText: "Descripción",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

//FORMULARIO DEL DATEPICKER
  TextFormField _formFecha(BuildContext context) {
    return TextFormField(
      controller: _fechaController,
      maxLength: 23,
      decoration: const InputDecoration(
        labelText: "Fecha",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      onTap: () {
        FocusScope.of(context).unfocus(); //oculta el teclado
        llamadaDatePicker();
      },
      enableInteractiveSelection: false,
    );
  }

//CREACIÓN DEL DATEPICKER
  void llamadaDatePicker() async {
    var selectedDate = await obtenerFechaPickerWidget();
    if (selectedDate != null) {
      setState(
        () {
          _fecha = selectedDate.toString();
          _fechaEditada = _fecha.toString();
          _fechaController.text = _fechaEditada.substring(0, 10);
        },
      );
    }
  }

  Future<DateTime?> obtenerFechaPickerWidget() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2028),
      //locale: const Locale('es','ES'),
    );
  }

//CREACION DEL TIMEPICKER
  TextFormField _formHora(BuildContext context) {
    return TextFormField(
      showCursor: true,
      controller: _horaController,
      maxLength: 13,
      decoration: const InputDecoration(
        labelText: "Hora",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        llamadaTimePicker();
      },
      focusNode: FocusNode(
          canRequestFocus: false,
          skipTraversal: true,
          descendantsAreFocusable: true),
      enableInteractiveSelection: false,
      //cursorColor: Colors.red,
    );
  }

  void llamadaTimePicker() async {
    var seleccionHora = await obtenerHoraPickerWidget();
    if (seleccionHora != null) {
      setState(() {
        _hora = seleccionHora.toString();
        _horaEditada = _hora.toString();
        _horaController.text = _horaEditada.substring(10, 15);
      });
    }
  }

  Future<TimeOfDay?> obtenerHoraPickerWidget() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

//VALIDAR LOS CAMPOS DE TITULO Y DESCRIPCIÓN DE LA TAREA
  String? _validarTitulo(String valor) {
    if (valor.trim().isEmpty) {
      return "Campo Vacio";
    } else {
      return null;
    }
  }

  String? _validarDescripcion(String valor) {
    if (valor.trim().isEmpty) {
      return "Campo Vacio";
    } else {
      return null;
    }
  }

//BOTON DE GUARDAR LO QUE HAYA SIDO LLENADO EN EL FORMULARIO
  void _guardar(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      SQLite_Insertar().nota(
        Nota(
          id: 1,
          titulo: _tituloController.text,
          descripcion: _descripcionController.text,
          fecha: _fechaController.text,
          hora: _horaController.text,
          boleano: _activarAlarma.text,
          color: _colorController.text,
          //fechayhora: _fechaController.text + " " + _horaController.text,
        ),
      );
      Navigator.pop(context);
    }
  }

//TEMA PARA EL DATE Y TIME PICKER

/* Theme temaDatePicker(context, child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.teal.shade800, // color de la cabecera
          onPrimary: Colors.white, // color del texto e icono de la cabecera
          onSurface: Colors.black, // color del cuerpo
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.amber, // button text color
          ),
        ),
      ),
      child: child!,
    );
  }*/
}
