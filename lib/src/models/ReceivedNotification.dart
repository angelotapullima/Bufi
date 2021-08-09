class ReceivedNotification {
  int id;
  String title;
  String body;
  String payload;

  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });
}

class NotificationModel {
  String tipo;
  String contenido;
  String id;

  NotificationModel({
    this.tipo,
    this.contenido,
    this.id,
  });
}
