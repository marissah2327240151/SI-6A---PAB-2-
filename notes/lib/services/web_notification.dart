// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void showWebNotification(String title, String body) {
  if (html.Notification.permission == 'granted') {
    html.Notification(title, body: body, icon: '/favicon.png');
  } else {
    html.Notification.requestPermission().then((permission) {
      if (permission == 'granted') {
        html.Notification(title, body: body, icon: '/favicon.png');
      }
    });
  }
}