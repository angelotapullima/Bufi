import 'dart:io';
import 'dart:convert';
import 'package:bufi/src/models/PedidosModel.dart';
import 'package:bufi/src/models/productoModel.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:bufi/src/utils/constants.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

Future<int> guardarProducto(File _image,  ProductoModel producModel, PedidosModel pedidoModel) async {
    final preferences = Preferences();

    // open a byteStream
    var stream = new http.ByteStream(Stream.castFrom(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse("$apiBaseURL/api/Pedido/valorar_pedido");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["tn"] = preferences.token;
    request.fields["app"] = 'true';
    request.fields["id_subsidiary_good"] = producModel.idProducto;
    request.fields["id_delivery"] = pedidoModel.idPedido;
    request.fields["valoracion"] = producModel.productoStatus;
    //Cambiar por el verdadero
    request.fields["comentario"] = producModel.productoName;
    

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('imagen', stream, length,
        filename: basename(_image.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        // print(value);

        final decodedData = json.decode(value);
        final int code = decodedData['result']['code'];

        if (decodedData['result']['code'] == 1) {
          print('amonos');
          return 1;
        } else if (code == 2) {
          return 2;
        } else {
          return code;
        }
      }
      
      );
      
    }
     
    ).catchError((e) {
      print(e);
    });
     return 1;
  }