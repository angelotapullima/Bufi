import 'dart:async';
import 'dart:io';

import 'package:bufi/src/api/token_api.dart';
import 'package:bufi/src/models/ReceivedNotification.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../main.dart' as main;

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;
  static StreamController<String> _messageStreamController = new StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStreamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    //aplicacion minimizada
    print('_backgroundHandler');
    print(message.data);
    //_messageStreamController.add(message.data.toString());
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //primer plano  app abierta
    print('_onMessageHandler');
    print(message.data);

    String title;
    String body;
    if (Platform.isAndroid) {
      title = message.notification.title;
      body = message.notification.title;
    } else {
      title = message.notification.title;
      body = message.notification.body;
    }

    ReceivedNotification notification = ReceivedNotification();
    notification.title = title;
    notification.body = body;
    notification.payload = message.data.toString();
    main.showNotificationWithIconBadge(notification);

    NotificationModel notificationModel = NotificationModel();
    notificationModel.tipo = message.data['tipo'];
    notificationModel.contenido = message.data['Contenido'];
    notificationModel.id = message.data['id'];

    //_messageStreamController.add(message.data.toString());
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //aplicacion terminada
    print('_onMessageOpenApp');
    print(message.data);
    //_messageStreamController.add(message.data.toString());
  }

  static Future initializeApp() async {
    final tokenApi = TokenApi();
    final preferences = Preferences();
    // Push Notification
    await Firebase.initializeApp();

    messaging.requestPermission();
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    print('initialMessage $initialMessage');

    token = await FirebaseMessaging.instance.getToken();
    tokenApi.enviarToken(token);
    preferences.tokenFirebase = token;
    print('Token Firebase: ${preferences.tokenFirebase}');

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //Local Notification
  }

  static closeStreams() {
    _messageStreamController.close();
  }
}

/*
class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  final tokenApi = TokenApi();
  Stream<String> get mensajesPush => _mensajesStreamController.stream;

  initNotification() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      tokenApi.enviarToken(token);
      print('=====FCM TOKEN=====');
      print(token);
    });

    _firebaseMessaging.configure(onMessage: (info) async {
      print('=====On Message========');

      String argumento;
      String title;
      String body;
      if (Platform.isAndroid) {
        argumento = info['data']['id_pedido'];

        title = info['notification']['title'];
        body = info['notification']['body'];
      } else {
        argumento = info['id_pedido'];

        title = info['notification']['title'];
        body = info['notification']['body'];
      }

      ReceivedNotification notification = ReceivedNotification();
      notification.title = title;
      notification.body = body;
      notification.payload = argumento;
      showNotificationWithIconBadge(notification);

      //_mensajesStreamController.sink.add(event)
    }, onLaunch: (info) async {
      print('===== onLaunch========');
      String argumento;
      if (Platform.isAndroid) { 
        argumento = info['data']['id_pedido'];
      } else {
        argumento = info['id_pedido'];
      }

      _mensajesStreamController.sink.add(argumento);
    }, onResume: (info) async {
      print('=====onResume========');
      String argumento;
      if (Platform.isAndroid) {
        argumento = info['data']['id_pedido'];
      } else {
        argumento = info['id_pedido'];
      }

      _mensajesStreamController.sink.add(argumento);
    });
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}*/
