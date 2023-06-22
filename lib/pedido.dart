import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidos/globals.dart' as globals;
import 'package:pedidos/productos.dart';
import 'package:pedidos/types/entrada.dart';

class Pedido extends StatefulWidget {
  const Pedido({super.key});

  @override
  PedidoState createState() => PedidoState();
}

class PedidoState extends State<Pedido> {

  double montoTotal(){
    double total = 0;

    for (var entrada in globals.pedidos[globals.pedidoActual]!) {
      if(entrada.producto != "delivery" && entrada.tipo != "delivery"){
        total += entrada.precioVenta * entrada.cantidad * entrada.unidadesPorPaquete;
      }
    }

    return total;
  }

  double montoTotalConDelivery(){
    double total = 0;

    for (var entrada in globals.pedidos[globals.pedidoActual]!) {
      total += entrada.precioVenta * entrada.cantidad * entrada.unidadesPorPaquete;
    }

    return total;
  }

  double ganaciaTotal(){
    double total = 0;

    for (var entrada in globals.pedidos[globals.pedidoActual]!) {
      if(entrada.producto != "delivery" && entrada.tipo != "delivery"){
        total += entrada.precioCompra * entrada.cantidad * entrada.unidadesPorPaquete;
      }
    }

    return montoTotal() - total;
  }

  double deliveryTotal(){
    double total = 0;

    for (var entrada in globals.pedidos[globals.pedidoActual]!) {
      if(entrada.producto == "delivery" && entrada.tipo == "delivery"){
        total = entrada.precioVenta;
      }
    }

    return total;
  }

  void agregarDelivery(double costo){
    int indice = -1;

    for(int i = 0; i < globals.pedidos[globals.pedidoActual]!.length; i++){
      if(globals.pedidos[globals.pedidoActual]!.elementAt(i).producto == "delivery" && globals.pedidos[globals.pedidoActual]!.elementAt(i).tipo == "delivery"){
        indice = i;
      }
    }

    // Agregar delivery
    if(indice == -1){
      globals.pedidos[globals.pedidoActual]!.add(
        Entrada(
          producto: "delivery",
          tipo: "delivery",
          categoria: "delivery",
          sabor: "delivery",
          cantidad: 1,
          unidadesPorPaquete: 1,
          precioCompra: 0,
          precioVenta: costo
        )
      );
    } 
    
    // EL DELIVERY YA EXISTER SE PROCEDE A REESCRIBIR
    else {
      globals.pedidos[globals.pedidoActual]![indice] = Entrada(
        producto: "delivery",
        tipo: "delivery",
        categoria: "delivery",
        sabor: "delivery",
        cantidad: 1,
        unidadesPorPaquete: 1,
        precioCompra: costo,
        precioVenta: costo
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(globals.pedidoActual),
          actions: [
            IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {

                    int indiceProductosFactura = 0;

                    return Scaffold(
                      appBar: AppBar(
                        title: const Text("Vista previa"),
                        elevation: 0,
                      ),
                      body: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Helados Carabobo', style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20, color: globals.colorfront)),
                                    Text('RECIBO DE COMPRA', style: TextStyle(fontSize: MediaQuery.of(context).size.width / 17, color: globals.colorfront, fontWeight: FontWeight.bold)),
                                    Text('RIF: J-29466945-0', style: TextStyle(fontSize: MediaQuery.of(context).size.width / 30, color: globals.colorfront)),
                                  ],
                                ),
                    
                                const Spacer(),
                    
                                Image.asset('img/logo.png', height: MediaQuery.of(context).size.width / 5, filterQuality: FilterQuality.medium),
                              ],
                            ),
                    
                            
                            Divider(height: 10, thickness: 1, color: globals.colorfront,),
                            
                            // Nombre del cliente
                            Row(
                              children: [
                                Text('Cliente: ', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold),),
                                const Spacer(),
                                Text(globals.pedidoActual, style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront)),
                              ],
                            ),
                            
                            // Nombre del vendedor
                            Row(
                              children: [
                                Text('Asesor: ', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold),),
                                const Spacer(),
                                Text(globals.usuario_nombre, style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront)),
                              ],
                            ),
                    
                            // Nombre del vendedor
                            Row(
                              children: [
                                Text('Contacto: ', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold),),
                                const Spacer(),
                                Text(globals.usuario_telefono, style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront)),
                              ],
                            ),
                            
                            // fecha
                            Row(
                              children: [
                                Text('Fecha: ', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold),),
                                const Spacer(),
                                Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront)),
                              ],
                            ),
                    
                            Divider(height: 10, thickness: 1, color: globals.colorfront,),
                    
                            // barra de titulo con nomrbes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width: MediaQuery.of(context).size.width / 15, alignment: Alignment.centerLeft, child: Text('#', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold))),
                                Text('Producto', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold)),
                                const Spacer(),
                                SizedBox(width: MediaQuery.of(context).size.width / 9, child: Center(child: Text('Cant.', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold)))),
                                const SizedBox(width: 3),
                                Container(width: MediaQuery.of(context).size.width / 6.8, alignment: Alignment.centerRight, child: Text('Precio', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold))),
                              ],
                            ),
                    
                            Flexible(
                              child:  ListView.builder(
                                itemCount: globals.pedidos[globals.pedidoActual]!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index){
                                  
                                  Widget item = const SizedBox();
                                  
                                  if(globals.pedidos[globals.pedidoActual]!.elementAt(index).producto != "delivery" && globals.pedidos[globals.pedidoActual]!.elementAt(index).tipo != "delivery"){
                                    indiceProductosFactura += 1;
                    
                                    item = Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(width: MediaQuery.of(context).size.width / 15, alignment: Alignment.centerLeft, child: Text('$indiceProductosFactura. ', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold))),
                                        Text("${globals.pedidos[globals.pedidoActual]!.elementAt(index).producto}${globals.pedidos[globals.pedidoActual]!.elementAt(index).tipo == "" ? "" : " "}${globals.pedidos[globals.pedidoActual]!.elementAt(index).tipo}${globals.pedidos[globals.pedidoActual]!.elementAt(index).sabor == "" ? "" : " "}${globals.pedidos[globals.pedidoActual]!.elementAt(index).sabor}".replaceAll('Medio Litro', '1/2L').replaceAll('Napolitano Napolitano', 'Napolitano').replaceAll('4.4 Litros', '4.4L').replaceAll('Litro', '1L').replaceAll('Fresa con Sirope de Fresa', 'Fresa y Sirop Fresa').replaceAll('Galleta de Chocolate', 'Galleta Chocolate'), style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront)),
                                        const Spacer(),
                                        SizedBox(width: MediaQuery.of(context).size.width / 9, child: Center(child: Text(globals.pedidos[globals.pedidoActual]![index].cantidad.toString(), style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront)))),
                                        const SizedBox(width: 3),
                                        Container(width: MediaQuery.of(context).size.width / 6.8, alignment: Alignment.centerRight, child: Text("${(globals.pedidos[globals.pedidoActual]![index].precioVenta * globals.pedidos[globals.pedidoActual]![index].unidadesPorPaquete * globals.pedidos[globals.pedidoActual]![index].cantidad).toStringAsFixed(2)}\$".replaceAll('.0\$', '\$').replaceAll('.00\$', '\$'), style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront))),
                                      ]
                                    );
                                  }
                    
                                  return item;
                                },
                              ),
                            ),
                    
                            Divider(height: 10, thickness: 1, color: globals.colorfront,),
                    
                            // consto de envio
                            Row(
                              children: [
                                const Spacer(flex: 10,),
                                Text('Envio: ', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold),),
                                Container(width: MediaQuery.of(context).size.width / 6, alignment: Alignment.centerRight, child: Text('${deliveryTotal().toStringAsFixed(2)}\$'.replaceAll('.0\$', '\$').replaceAll('.00\$', '\$'), style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront))),
                              ],
                            ),
                    
                            Divider(height: 10, thickness: 1, indent: MediaQuery.of(context).size.width / 2.15, color: globals.colorfront,),
                    
                            // total
                            Row(
                              children: [
                                const Spacer(flex: 10,),
                                Text('Total: ', style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: globals.colorfront, fontWeight: FontWeight.bold),),
                                Container(width: MediaQuery.of(context).size.width / 6, alignment: Alignment.centerRight, child: Text('${montoTotalConDelivery().toStringAsFixed(2)}\$'.replaceAll('.0\$', '\$').replaceAll('.00\$', '\$'), style: TextStyle(fontSize: MediaQuery.of(context).size.width / globals.textSizeDivision, color: Colors.green[600], fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.receipt_rounded)
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: globals.pedidos[globals.pedidoActual]!.length,
          itemBuilder: (BuildContext context, int index) {

            Widget tile = const ListTile();

            if(globals.pedidos[globals.pedidoActual]!.elementAt(index).producto == "delivery"){
              tile = const SizedBox();
            }

            else {
              tile = ListTile(
                leading: Text("${globals.pedidos[globals.pedidoActual]!.elementAt(index).cantidad}"),
                title: Text("${globals.pedidos[globals.pedidoActual]!.elementAt(index).producto}${globals.pedidos[globals.pedidoActual]!.elementAt(index).tipo == "" ? "" : " "}${globals.pedidos[globals.pedidoActual]!.elementAt(index).tipo}${globals.pedidos[globals.pedidoActual]!.elementAt(index).sabor == "" ? "" : " "}${globals.pedidos[globals.pedidoActual]!.elementAt(index).sabor}"),
                trailing: Text("${(globals.pedidos[globals.pedidoActual]!.elementAt(index).precioVenta * globals.pedidos[globals.pedidoActual]!.elementAt(index).cantidad * globals.pedidos[globals.pedidoActual]!.elementAt(index).unidadesPorPaquete).toStringAsFixed(2)}\$"),
                onLongPress: (){

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('¿Eliminar producto?'),
                        content: Text("${globals.pedidos[globals.pedidoActual]!.elementAt(index).producto}${globals.pedidos[globals.pedidoActual]!.elementAt(index).tipo == "" ? "" : " "}${globals.pedidos[globals.pedidoActual]!.elementAt(index).tipo}${globals.pedidos[globals.pedidoActual]!.elementAt(index).sabor == "" ? "" : " "}${globals.pedidos[globals.pedidoActual]!.elementAt(index).sabor}"),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                globals.pedidos[globals.pedidoActual]!.removeAt(index);  
                              });

                              Navigator.of(context).pop();
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );


                  
                },
              );
            }

            return tile;
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.lightBlue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Productos())).then((value){setState(() {});});
          },
          label: const Text('Agregar producto', style: TextStyle(color: Colors.white),)
        ),

        bottomNavigationBar: Container(
          height: 55,
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
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
                      Text('${ganaciaTotal().toStringAsFixed(2)}\$', style: const TextStyle(fontSize: 14))
                    ],
                  ),

                  // Delivery
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // obetener el foco para el textformfield
                          final TextEditingController _cantidadController = TextEditingController();
                          final focusNode = FocusNode();
                          focusNode.requestFocus();

                          return AlertDialog(
                            title: const Text("Delivery"),
                            content: TextFormField(
                                focusNode: focusNode,
                                controller: _cantidadController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                
                                decoration: const InputDecoration(labelText: 'Costo'),
                                onFieldSubmitted: (value) {
                                  agregarDelivery(int.parse(_cantidadController.text).toDouble());
                                  _cantidadController.clear();
                                  Navigator.of(context).pop();
                                  setState(() {}); // Actualizar la lista de pedidos
                                }),

                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  agregarDelivery(int.parse(_cantidadController.text).toDouble());
                                  _cantidadController.clear();
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Delivery', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('${deliveryTotal().toStringAsFixed(2)}\$', style: const TextStyle(fontSize: 14))
                      ],
                    ),
                  ),
                  
                  // Pedido
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Pedido', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
        )
    );
  }
}
