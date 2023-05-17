library globals;

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pedidos/types/entrada.dart';
import 'package:pedidos/types/producto.dart';

Map<String, List<Entrada>> pedidos = {};
List<Producto> productos = [];

String pedidoActual = "";

void cargarProductos() async {
  String jsonString = await rootBundle.loadString('database/productos.json');
  List<dynamic> productosJson = json.decode(jsonString);

  for (dynamic element in productosJson) {
    // Lista temporal para evitar errores al asignar element["sabores"]
    // a sabores del producto
    List<String> saboresDelElemento = [];

    // agregar sabores a la lista temporal
    for (var saborElement in element["sabores"]) {
      saboresDelElemento.add(saborElement);
    }

    productos.add(Producto(
        categoria: element["categoria"],
        tipo: element["tipo"],
        producto: element["producto"],
        unidadesPorPaquete: element["unidadesPorPaquete"],
        precioCompra: element["precioCompra"],
        precioVenta: element["precioVenta"],
        sabores: saboresDelElemento));
  }
}
