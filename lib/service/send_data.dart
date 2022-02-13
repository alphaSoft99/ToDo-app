class SendData {
  SendData({
      this.to, 
      this.notification, 
      this.data, 
      this.priority,});

  SendData.fromJson(dynamic json) {
    to = json['to'];
    notification = json['notification'] != null ? NotificationData.fromJson(json['notification']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    priority = json['priority'];
  }
  String to;
  NotificationData notification;
  Data data;
  String priority;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['to'] = to;
    if (notification != null) {
      map['notification'] = notification.toJson();
    }
    if (data != null) {
      map['data'] = data.toJson();
    }
    map['priority'] = priority;
    return map;
  }

}

class Data {
  Data({
      this.clickAction,
      this.scheduledTime,
      this.isScheduled,});

  Data.fromJson(dynamic json) {
    clickAction = json['click_action'];
    isScheduled = json['isScheduled'];
    scheduledTime = json['scheduledTime'];
  }
  String clickAction;
  String isScheduled;
  String scheduledTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['click_action'] = clickAction;
    map['scheduledTime'] = scheduledTime;
    map['isScheduled'] = isScheduled;
    return map;
  }

}

class NotificationData {
  NotificationData({
      this.title, 
      this.body, 
      this.sound,});

  NotificationData.fromJson(dynamic json) {
    title = json['title'];
    body = json['body'];
    sound = json['sound'];
  }
  String title;
  String body;
  String sound;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    map['sound'] = sound;
    return map;
  }

}