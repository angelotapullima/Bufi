//0B:CD:3F:47:BA:CC:67:63:B4:E6:7A:B4:CA:91:2A:88:1E:08:93:58
import 'dart:async';

import 'package:bufi/src/api/token_api.dart';
import 'package:bufi/src/preferencias/preferencias_usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;
  static StreamController<String> _messageStreamController =
      new StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStreamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    _messageStreamController.add(message.notification.title);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    _messageStreamController.add(message.notification.title);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    _messageStreamController.add(message.notification.title);
  }

  static Future initializeApp() async {
    final preferences = Preferences();
    final tokenApi = TokenApi();
    // Push Notification
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    preferences.tokenFirebase = token;
    print('Token Firebase: ${preferences.tokenFirebase}');
    tokenApi.enviarToken();

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
