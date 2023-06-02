library globals;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidos/types/entrada.dart';
import 'package:pedidos/types/producto.dart';

Map<String, List<Entrada>> pedidos = {};
List<Producto> productos = [];

// usuarios disponibles
List<Map<String, String>> usuarios = [];

// Usuario
int usuario_index = 0;
String usuario_nombre = "";
String usuario_cedula = "";
String usuario_telefono = "";

// Pedido abierto
String pedidoActual = "";

// factura
Color colorBack = Colors.white;
Color colorfront = Colors.grey[800] as Color;
double textSizeDivision = 27;


// funciones
Future<void> cargarProductos(int index) async {

  usuario_index = index;
  usuario_nombre = usuarios[index]["nombre"]!;
  usuario_cedula = usuarios[index]["cedula"]!;
  usuario_telefono = usuarios[index]["telefono"]!;

  String jsonString = await rootBundle.loadString('database/productos/$usuario_cedula.json');
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

Future<void> cargarUsuarios() async {
  String jsonString = await rootBundle.loadString('database/usuarios.json');
  List<dynamic> usuariosJson = json.decode(jsonString);

  for (var i = 0; i < usuariosJson.length; i++) {
    usuarios.insert(i, {});
    usuarios.elementAt(i)["nombre"] = usuariosJson[i]["nombre"];
    usuarios.elementAt(i)["cedula"] = usuariosJson[i]["cedula"];
    usuarios.elementAt(i)["telefono"] = usuariosJson[i]["telefono"];
  }
}