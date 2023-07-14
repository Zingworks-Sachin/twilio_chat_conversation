import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_chat_conversation_example/chat/common/api/custom_exception.dart';
import 'package:twilio_chat_conversation_example/chat/common/api_constant.dart';
import 'package:twilio_chat_conversation_example/chat/common/models/chat_model.dart';
import 'package:twilio_chat_conversation_example/chat/common/models/models_model.dart';

class ApiProvider {
  Future<dynamic> get(String request, [String? token]) async {
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + request);
      // PrintUtility.printText("Url---------->$url");

      final response = await http.get(url, headers: {
        "content-type": "application/json",
      });

      responseJson = _response(response);

      // ignore: empty_catches
    } on SocketException {}
    return responseJson;
  }

  Future<dynamic> delete(String request) async {
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + request);
      final response = await http.delete(url, headers: {
        "content-type": "application/json",
      });
      responseJson = _response(response);
      // ignore: empty_catches
    } on SocketException {}
    return responseJson;
  }

  Future<dynamic> post(String request, Map body, [String? userToken]) async {
    // ignore: prefer_typing_uninitialized_variables

    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + request);

      final response = await http.post(url,
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ${ApiConstants.apiKey}'
          },
          body: jsonEncode(body));

      responseJson = _response(response);

      return responseJson;
    } catch (error) {
      return responseJson;
    }
  }

  Future<dynamic> postWithoutParameters(String request,
      [String? userToken]) async {
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + request);

      final response = await http.post(url, headers: {
        "content-type": "application/json",
        'Authorization': 'Bearer ${ApiConstants.apiKey}'
      });

      responseJson = _response(response);
      return responseJson;
    } catch (error) {
      return responseJson;
    }
  }

  Future<dynamic> put(String request, Map body, [String? token]) async {
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + request);
      Map<String, String> headers = {
        "content-type": "application/json",
      };
      final response =
          await http.put(url, headers: headers, body: jsonEncode(body));
      responseJson = _response(response);
      // ignore: empty_catches
    } on SocketException {}
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
      case 500:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  static Future<List<ModelsModel>> getModels() async {
    String? apiKey = await getEnvironmentKey();
    try {
      var response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/models"),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      rethrow;
    }
  }

  // Send Message using ChatGPT API
  static Future<List<ChatModel>> sendMessageGPT(
      {required String message, required String modelId}) async {
    String? apiKey = await getEnvironmentKey();
    //print("sendMessageGPT=$message-$modelId");
    try {
      var response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/chat/completions"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      // Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      //print("jsonResponse $jsonResponse");
      if (jsonResponse['error'] != null) {
        //print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      rethrow;
    }
  }

  // Send Message fct
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    String? apiKey = await getEnvironmentKey();
    try {
      var response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/completions"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );

      // Map jsonResponse = jsonDecode(response.body);

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      rethrow;
    }
  }

  static Future<String?> getEnvironmentKey() async {
    final env = await parseStringToMap(assetsFileName: '.env');
    //print("env");
    //print(env['API_KEY']);
    return env['API_KEY'];
  }
  static Future<String> getEnvironmentKeyByName({required String keyName}) async {
    final env = await parseStringToMap(assetsFileName: '.env');
    return env[keyName]?? "";
  }

  static Future<Map<String, String>> parseStringToMap(
      {String assetsFileName = '.env'}) async {
    final lines = await rootBundle.loadString(assetsFileName);
    Map<String, String> environment = {};
    for (String line in lines.split('\n')) {
      line = line.trim();
      if (line.contains('=') //Set Key Value Pairs on lines separated by =
          &&
          !line.startsWith(RegExp(r'=|#'))) {
        //No need to add emty keys and remove comments
        List<String> contents = line.split('=');
        environment[contents[0]] = contents.sublist(1).join('=');
      }
    }
    //print("environment.toString()");
    //print(environment.toString());
    return environment;
  }
}
