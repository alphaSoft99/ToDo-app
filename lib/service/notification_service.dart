import 'package:http/http.dart' as http;
import 'package:todo/service/send_data.dart';

sendData(SendData data) async {
  print("TTT: ${data.toJson()}");
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  await http.post(url, body: data.toJson(), headers: {
    "Authorization":
        "key=AAAAdXuNKLA:APA91bHJEpQmPkDa78jS6dlR04yMezcFb4L6NjtiyjhG-yvv8pvElnTWmXPzU_OCzj3ILmk_p5zdFdgTm_6GO84IbY4SlZ7-lzrVw8-AnSv31ydvMsZA77twnRuy5HuNqGv-he5Da4jx"
  });
}
