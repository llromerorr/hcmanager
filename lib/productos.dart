import 'package:flutter/material.dart';
import 'package:pedidos/globals.dart' as globals;
import 'package:pedidos/types/producto.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  ProductosState createState() => ProductosState();
}

class ProductosState extends State<Productos>
    with SingleTickerProviderStateMixin {
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
          title: Text(productosEnCategoria[index].producto),
          subtitle: Text(productosEnCategoria[index].tipo),
        );
      },
    );
  }
}
