import 'package:bufi/src/models/carritoModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/utils/responsive.dart';
import 'package:bufi/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';

class CantidadCarrito extends StatefulWidget {
  final CarritoModel carrito;
  final Function llamada;
  final String idSudsidiaryGood;
  final String tallaProducto;
  final String modeloProducto;
  final String marcaProducto;

  CantidadCarrito(
      {Key key,
      @required this.carrito,
      @required this.llamada,
      @required this.idSudsidiaryGood,
      @required this.tallaProducto,
      @required this.modeloProducto,
      @required this.marcaProducto})
      : super(key: key);

  @override
  _CantidadCarritoState createState() => _CantidadCarritoState();
}

class _CantidadCarritoState extends State<CantidadCarrito> {
  int _counter = 1;

  void _increase() {
    setState(() {
      _counter++;
      widget.llamada();
    });
  }

  void _decrease() {
    setState(() {
      _counter--;
      widget.llamada();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    ProductoModel producto = ProductoModel();
    producto.idProducto = widget.carrito.idSubsidiaryGood;
    producto.idSubsidiary = widget.carrito.idSubsidiary;
    producto.productoName = widget.carrito.nombre;
    producto.productoImage = widget.carrito.image;
    producto.productoPrice = widget.carrito.precio;
    _counter = int.parse(widget.carrito.cantidad);

    return _cantidad(responsive, producto);
  }

  Widget _cantidad(Responsive responsive, ProductoModel producto) {
    final pad = responsive.hp(1);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pad),
      child: Container(
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        width: responsive.wp(50),
        height: responsive.hp(3.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  _decrease();
                  utils.agregarAlCarritoContador(
                      context, widget.idSudsidiaryGood,widget.tallaProducto,widget.modeloProducto,widget.marcaProducto, _counter);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      "-",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 6,
              child: Container(
                color: Colors.grey[100],
                height: double.infinity,
                child: Center(
                  child: Text('$_counter UND',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: responsive.ip(1.5),
                      )),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  _increase();
                  utils.agregarAlCarritoContador(
                      context, widget.idSudsidiaryGood,widget.tallaProducto,widget.modeloProducto,widget.marcaProducto, _counter);

                  //utils.agregarAlCarrito(context, _counter.toString());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      "+",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
