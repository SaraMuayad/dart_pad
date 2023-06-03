import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class APICompiler {
  String result = "";
  String output = "";
  String language = "dart";
  String versionIndex = "4";
  String clientId = dotenv.get('CLIENT_ID');
  String clientSecret = dotenv.get('CLIENTSECRET');

  Future getCompiler(String code) async {
    final headers = {'Content-Type': 'application/json'};
    Map<String, String> body = {
      "script": code,
      "language": language,
      "versionIndex": versionIndex,
      "clientId": clientId,
      "clientSecret": clientSecret,
    };

    String jsonBody = jsonEncode(body);
    final url = Uri.parse(dotenv.get('APIUrl'));
    try {
      Response response = await post(
        url,
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print("Compiling successful");
        var data = jsonDecode(response.body.toString());

        output = data['output'];
      } else {
        print("Failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
