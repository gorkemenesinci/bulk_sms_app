import 'package:bulk_sms_app/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }
}
