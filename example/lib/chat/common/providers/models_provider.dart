import 'package:flutter/cupertino.dart';
import 'package:twilio_chat_conversation_example/chat/common/api/api_provider.dart';
import 'package:twilio_chat_conversation_example/chat/common/models/models_model.dart';

class ModelsProvider with ChangeNotifier {
  // String currentModel = "text-davinci-003";
  String currentModel = "gpt-3.5-turbo-0301";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiProvider.getModels();
    return modelsList;
  }
}
