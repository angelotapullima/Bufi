class NotificacionesModel {
    NotificacionesModel({
        this.idNotificacion,
        this.idUsuario,
        this.notificacionTipo,
        this.notificacionIdRel,
        this.notificacionMensaje,
        this.notificacionImagen,
        this.notificacionDatetime,
        this.notificacionEstado,
    });

    String idNotificacion;
    String idUsuario;
    String notificacionTipo;
    String notificacionIdRel;
    String notificacionMensaje;
    String notificacionImagen;
    String notificacionDatetime;
    String notificacionEstado;

    factory NotificacionesModel.fromJson(Map<String, dynamic> json) => NotificacionesModel(
        idNotificacion: json["id_notificacion"],
        idUsuario: json["id_usuario"],
        notificacionTipo: json["notificacion_tipo"],
        notificacionIdRel: json["notificacion_id_rel"],
        notificacionMensaje: json["notificacion_mensaje"],
        notificacionImagen: json["notificacion_imagen"],
        notificacionDatetime: json["notificacion_datetime"],
        notificacionEstado: json["notificacion_estado"],
    );

    Map<String, dynamic> toJson() => {
        "id_notificacion": idNotificacion,
        "id_usuario": idUsuario,
        "notificacion_tipo": notificacionTipo,
        "notificacion_id_rel": notificacionIdRel,
        "notificacion_mensaje": notificacionMensaje,
        "notificacion_imagen": notificacionImagen,
        "notificacion_datetime": notificacionDatetime,
        "notificacion_estado": notificacionEstado,
    };
}


