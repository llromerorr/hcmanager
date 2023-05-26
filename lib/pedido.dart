import 'package:flutter/material.dart';
import 'package:pedidos/globals.dart' as globals;
import 'package:pedidos/productos.dart';

class Pedido extends StatefulWidget {
  const Pedido({super.key});

  @override
  PedidoState createState() => PedidoState();
}

class PedidoState extends State<Pedido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(globals.pedidoActual),
        ),
        body: ListView.builder(
          itemCount: globals.pedidos[globals.pedidoActual]!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Text("${globals.pedidos[globals.pedidoActual]!.elementAt(index).cantidad}"),
              title: Text("${globals.pedidos[globals.pedidoActual]!.elementAt(index).producto} ${globals.pedidos[globals.pedidoActual]!.elementAt(index).sabor}"),
              trailing: Text("${(globals.pedidos[globals.pedidoActual]!.elementAt(index).precioVenta * globals.pedidos[globals.pedidoActual]!.elementAt(index).cantidad * globals.pedidos[globals.pedidoActual]!.elementAt(index).unidadesPorPaquete).toStringAsFixed(2)}\$"),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Productos())).then((value){setState(() {
                
              });});
            },
            label: const Text('Agregar producto')));
  }
}
