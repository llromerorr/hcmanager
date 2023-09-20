import 'package:flutter/material.dart';



SnackBar snackbarProductoAgregado({required String producto, required  String sabor, required  String cantidad}){
  return SnackBar(
      content: Text(
        "Agregado: $cantidad $producto${(sabor == "" ? "" : " de $sabor")}",
        style: const TextStyle(fontWeight: FontWeight.bold)
      ),

      duration: const Duration(seconds: 1, milliseconds: 500),
      
      backgroundColor: Colors.green.shade300,
    );
}