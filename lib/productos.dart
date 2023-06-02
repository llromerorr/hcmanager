import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidos/globals.dart' as globals;
import 'package:pedidos/types/entrada.dart';
import 'package:pedidos/types/producto.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  ProductosState createState() => ProductosState();
}

class ProductosState extends State<Productos> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Tab> tabs = [];
  List<String> categorias = [];
  List<Widget> secciones = [];

  @override
  void initState() {
    super.initState();
    inicializarCategorias();
    _tabController = TabController(
        length: categorias.length,
        vsync: this); // Reemplaza "3" con el número de categorías
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void inicializarCategorias() {
    // inicializar categorias
    for (Producto producto in globals.productos) {
      if (!categorias.contains(producto.categoria)) {
        categorias.add(producto.categoria);
        tabs.add(Tab(text: producto.categoria));
      }
    }

    // inicializar secciones
    for (String categoria in categorias) {
      secciones.add(_buildProductosPorCategoria(categoria));
    }
  }


  void agregarProductoSinSaborAlPedido(Producto producto, int cantidad){
    int indice = -1;

    for(int i = 0; i < globals.pedidos[globals.pedidoActual]!.length; i++){
      if(globals.pedidos[globals.pedidoActual]!.elementAt(i).producto == producto.producto && globals.pedidos[globals.pedidoActual]!.elementAt(i).tipo == producto.tipo){
        indice = i;
      }
    }

    // ES UN NUEVO PRODUCTO
    if(indice == -1){
      globals.pedidos[globals.pedidoActual]!.add(Entrada(
        producto: producto.producto,
        cantidad: cantidad,
        categoria: producto.categoria,
        precioCompra: producto.precioCompra,
        precioVenta: producto.precioVenta,
        sabor: "",
        tipo: producto.tipo,
        unidadesPorPaquete: producto.unidadesPorPaquete)
      );
    } 
    
    // EL PRODUCTO YA EXISTER CON EL MISMO SABOR SE PROCEDE A REESCRIBIR
    else {
      globals.pedidos[globals.pedidoActual]![indice] = Entrada(
        producto: producto.producto,
        cantidad: cantidad,
        categoria: producto.categoria,
        precioCompra: producto.precioCompra,
        precioVenta: producto.precioVenta,
        sabor: "",
        tipo: producto.tipo,
        unidadesPorPaquete: producto.unidadesPorPaquete
      );
    }
  }

  void agregarProductoAlPedido(Producto producto, int cantidad, int saborIndex) {
    
    int indice = -1;

    for(int i = 0; i < globals.pedidos[globals.pedidoActual]!.length; i++){
      if(globals.pedidos[globals.pedidoActual]!.elementAt(i).producto == producto.producto && globals.pedidos[globals.pedidoActual]!.elementAt(i).sabor == producto.sabores[saborIndex]){
        indice = i;
      }
    }
    
    // ES UN NUEVO PRODUCTO
    if(indice == -1){
      globals.pedidos[globals.pedidoActual]!.add(Entrada(
        producto: producto.producto,
        cantidad: cantidad,
        categoria: producto.categoria,
        precioCompra: producto.precioCompra,
        precioVenta: producto.precioVenta,
        sabor: producto.sabores[saborIndex],
        tipo: producto.tipo,
        unidadesPorPaquete: producto.unidadesPorPaquete)
      );
    } 
    
    // EL PRODUCTO YA EXISTER CON EL MISMO SABOR SE PROCEDE A REESCRIBIR
    else {
      globals.pedidos[globals.pedidoActual]![indice] = Entrada(
        producto: producto.producto,
        cantidad: cantidad,
        categoria: producto.categoria,
        precioCompra: producto.precioCompra,
        precioVenta: producto.precioVenta,
        sabor: producto.sabores[saborIndex],
        tipo: producto.tipo,
        unidadesPorPaquete: producto.unidadesPorPaquete
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        bottom: TabBar(controller: _tabController, tabs: tabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: secciones,
      ),
    );
  }

  Widget _buildProductosPorCategoria(String categoria) {
    // productos que pertenecen a la categoria
    List<Producto> productosEnCategoria = [];
    final TextEditingController _cantidadController = TextEditingController();
    int saborIndex = 0;

    // filtrar por categoria
    for (Producto producto in globals.productos) {
      if (producto.categoria == categoria) {
        productosEnCategoria.add(producto);
      }
    }

    // retornar ListView
    return ListView.builder(
      itemCount: productosEnCategoria.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            if (productosEnCategoria[index].sabores.isNotEmpty) {
              // Seleccionar sabor
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  var screenSize = MediaQuery.of(context).size;

                  return AlertDialog(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    title: const Text('Seleccione el sabor'),
                    content: Container(
                      height: screenSize.height - 50,
                      width: screenSize.width - 50,
                      constraints:
                          const BoxConstraints(maxHeight: 500, maxWidth: 300),
                      child: ListView.builder(
                        itemCount: productosEnCategoria[index].sabores.length,
                        itemBuilder: (context, i) => ListTile(
                          onTap: () {
                            // Seleccianar sabor
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // obetener el foco para el textformfield
                                final focusNode = FocusNode();
                                focusNode.requestFocus();

                                return AlertDialog(
                                  title: Text(productosEnCategoria[index].unidadesPorPaquete == 1 ? "Unidades" : "Paquetes"),
                                  content: TextFormField(
                                      focusNode: focusNode,
                                      controller: _cantidadController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(labelText: 'Cantidad'),
                                      onFieldSubmitted: (value) {
                                        agregarProductoAlPedido(productosEnCategoria[index], int.parse(_cantidadController.text), i);
                                        _cantidadController.clear();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        setState(() {}); // Actualizar la lista de pedidos
                                      }),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        agregarProductoAlPedido(productosEnCategoria[index], int.parse(_cantidadController.text), i);
                                        _cantidadController.clear();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
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
                            child: Text(productosEnCategoria[index]
                                .sabores[i]
                                .toUpperCase()
                                .substring(0, 1)),
                          ),
                          title: Text(productosEnCategoria[index].sabores[i]),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            
            else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // obetener el foco para el textformfield
                  final focusNode = FocusNode();
                  focusNode.requestFocus();

                  return AlertDialog(
                    title: Text(productosEnCategoria[index].unidadesPorPaquete == 1 ? "Unidades" : "Paquetes"),
                    content: TextFormField(
                        focusNode: focusNode,
                        controller: _cantidadController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(labelText: 'Cantidad'),
                        onFieldSubmitted: (value) {
                          agregarProductoSinSaborAlPedido(productosEnCategoria[index], int.parse(_cantidadController.text));
                          _cantidadController.clear();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          setState(() {}); // Actualizar la lista de pedidos
                        }),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          agregarProductoSinSaborAlPedido(productosEnCategoria[index], int.parse(_cantidadController.text));
                          _cantidadController.clear();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          setState(() {}); // Actualizar la lista de pedidos
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          title: Text(productosEnCategoria[index].producto),
          subtitle: Text(productosEnCategoria[index].tipo),
          trailing: Text("${productosEnCategoria[index].precioVenta.toStringAsFixed(2)}\$"),
        );
      },
    );
  }
}
