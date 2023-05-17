class Producto {
  final String categoria;
  final String tipo;
  final String producto;
  final int unidadesPorPaquete;
  final double precioCompra;
  final double precioVenta;
  final List<String> sabores;

  Producto(
      {this.categoria = "",
      this.tipo = "",
      this.producto = "",
      this.unidadesPorPaquete = 0,
      this.precioCompra = 0,
      this.precioVenta = 0,
      this.sabores = const []});
}
