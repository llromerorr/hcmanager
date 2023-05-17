import 'package:flutter/material.dart';
import 'package:pedidos/pedido.dart';
import 'globals.dart' as globals;

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    globals.cargarProductos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Helados Carabobo"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                globals.pedidoActual = globals.pedidos.keys.elementAt(index);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Pedido()));
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar pedido'),
                      content: Text(
                          "¿desea eliminar el pedido de ${globals.pedidos.keys.elementAt(index)}?"),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            globals.pedidos
                                .remove(globals.pedidos.keys.elementAt(index));
                            Navigator.of(context).pop();
                            setState(() {}); // Actualizar la lista de pedidos
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              },
              leading: CircleAvatar(
                child: Text(globals.pedidos.keys
                    .elementAt(index)
                    .toString()
                    .toUpperCase()
                    .substring(0, 1)),
              ),
              title: Text(globals.pedidos.keys.elementAt(index)),
            );
          },
          itemCount: globals.pedidos.length,
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // obetener el foco para el textformfield
                  final focusNode = FocusNode();
                  focusNode.requestFocus();

                  return AlertDialog(
                    title: const Text('Agregar pedido'),
                    content: TextFormField(
                        focusNode: focusNode,
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del cliente',
                        ),
                        onFieldSubmitted: (value) {
                          globals.pedidos.addAll({_nombreController.text: []});
                          _nombreController.clear();
                          Navigator.of(context).pop();
                          setState(() {}); // Actualizar la lista de pedidos
                        }),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          globals.pedidos.addAll({_nombreController.text: []});
                          _nombreController.clear();
                          Navigator.of(context).pop();
                          setState(() {}); // Actualizar la lista de pedidos
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  );
                },
              );
            },
            label: const Text('Agregar pedido')));
  }
}
