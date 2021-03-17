
import 'package:bufi/src/page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ModalLogin extends StatefulWidget {
  const ModalLogin({Key key}) : super(key: key);

  @override
  _ModalLoginState createState() => _ModalLoginState();
}

class _ModalLoginState extends State<ModalLogin> {
  

  @override
  Widget build(BuildContext rootContext) {
    
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Container(),
          middle: Text('Login'),
        ),
        child: SafeArea(
          bottom: false,
          child: LoginPage()),
      ),
    );
  }
}