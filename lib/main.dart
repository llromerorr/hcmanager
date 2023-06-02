import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidos/pedido.dart';
import 'package:pedidos/usuarios.dart';
import 'globals.dart' as globals;

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: const Usuarios(),
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
    super.initState();
  }

  double montoTotal(){
    double total = 0;

    for (var pedido in globals.pedidos.values) {
      for (var entrada in pedido) {
        if(entrada.producto != "delivery" && entrada.tipo != "delivery"){
          total += entrada.precioVenta * entrada.cantidad * entrada.unidadesPorPaquete;
        }
      }
    }

    return total;
  }

  double montoTotalConDelivery(){
    double total = 0;

    for (var pedido in globals.pedidos.values) {
      for (var entrada in pedido) {
        total += entrada.precioVenta * entrada.cantidad * entrada.unidadesPorPaquete;
      }
    }

    return total;
  }

  double empresaTotal(){
    double total = 0;

    for (var pedido in globals.pedidos.values) {
      for (var entrada in pedido) {
        if(entrada.producto != "delivery" && entrada.tipo != "delivery"){
          total += entrada.precioCompra * entrada.cantidad * entrada.unidadesPorPaquete;
        }
      }
    }

    return total;
  }

  double deliveryTotal(){
    double total = 0;

    for (var pedido in globals.pedidos.values) {
      for (var entrada in pedido) {
        if(entrada.producto == "delivery" && entrada.tipo == "delivery"){
          total = entrada.precioVenta;
        }
      }
    }

    return total;
  }

  double gananciaTotal() => montoTotal() - empresaTotal();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Helados Carabobo"),
              Text(globals.usuario_nombre, style: const TextStyle(fontSize: 14)),
            ],
          )
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                globals.pedidoActual = globals.pedidos.keys.elementAt(index);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Pedido())).then((value){setState(() {});});
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar pedido'),
                      content: Text("¿desea eliminar el pedido de ${globals.pedidos.keys.elementAt(index)}?"),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            globals.pedidos.remove(globals.pedidos.keys.elementAt(index));
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

        bottomNavigationBar: Container(
          height: 55,
          decoration: const BoxDecoration(
            color: Colors.pink,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black,
              )
            ]
          ),

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
            
                children: [    
                  // Ganancia
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Ganancia', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('${gananciaTotal().toStringAsFixed(2)}\$', style: const TextStyle(fontSize: 14))
                    ],
                  ),

                  // Empresa
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Empresa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('${empresaTotal().toStringAsFixed(2)}\$', style: const TextStyle(fontSize: 14))
                    ],
                  ),

                  // Total
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Delivery', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('${deliveryTotal().toStringAsFixed(2)}\$', style: const TextStyle(fontSize: 14))
                    ],
                  ),
                  
                  // Pedidos
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Pedidos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('${montoTotal().toStringAsFixed(2)}\$', style: const TextStyle(fontSize: 14))
                    ],
                  ),

                  // Total
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('${montoTotalConDelivery().toStringAsFixed(2)}\$', style: const TextStyle(fontSize: 14))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.pink,
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
                          if(_nombreController.text != ""){
                            globals.pedidos.addAll({_nombreController.text: []});
                            _nombreController.clear();
                            Navigator.of(context).pop();
                            setState(() {}); // Actualizar la lista de pedidos
                          }
                        }),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          if(_nombreController.text != ""){
                            globals.pedidos.addAll({_nombreController.text: []});
                            _nombreController.clear();
                            Navigator.of(context).pop();
                            setState(() {}); // Actualizar la lista de pedidos
                          }
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  );
                },
              );
            },
            label: const Text('Agregar pedido', style: TextStyle(color: Colors.white))));
  }
}
