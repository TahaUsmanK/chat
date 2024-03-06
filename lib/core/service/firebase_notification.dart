import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificaiton {
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> getDeviceToken() async {
    final token = await _firebaseMessaging.getToken();
    await _firebaseMessaging.requestPermission();
    print(token);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
