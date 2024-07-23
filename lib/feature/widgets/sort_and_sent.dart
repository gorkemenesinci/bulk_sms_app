import 'dart:convert';

import 'package:bulk_sms_app/services/provider/contact_provider.dart';
import 'package:bulk_sms_app/services/provider/message_provider.dart';
import 'package:bulk_sms_app/feature/screens/view_message.dart';
import 'package:bulk_sms_app/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortAndSent extends StatefulWidget {
  const SortAndSent({
    super.key,
    required this.contactProvider,
    required this.select,
    required this.screenHeight,
    required TextEditingController messageController,
  }) : _messageController = messageController;

  final ContactProvider contactProvider;
  final List<String> select;
  final double screenHeight;
  final TextEditingController _messageController;

  @override
  State<SortAndSent> createState() => _SortAndSentState();
}

class _SortAndSentState extends State<SortAndSent> {
  void sendBulkSms(List<String> phoneNumbers, String message) async {
    const String apiKey = 'd6936c33';
    const String apiSecret = 'LyZAP3pfpJi3NpNP';
    const String from = '+905455505358';

    for (String phoneNumber in phoneNumbers) {
      final response = await http.post(
        Uri.parse('https://rest.nexmo.com/sms/json'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'api_key': apiKey,
          'api_secret': apiSecret,
          'to': phoneNumber,
          'from': from,
          'text': message,
        }),
      );

      if (response.statusCode == 200) {
        final messageProvider =
            Provider.of<MessageProvider>(context, listen: false);
        messageProvider.addMessage(Message(
            phoneNumber: phoneNumber,
            content: message,
            timestamp: DateTime.now()));
        print('SMS sent to $phoneNumber');
      } else {
        print('Failed to send SMS to $phoneNumber');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    var select = contactProvider.select;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: contactProvider.select.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green[100]),
                margin: const EdgeInsets.all(5),
                child: Text(
                  select[index],
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: widget.screenHeight * 0.1,
          child: TextFormField(
            controller: widget._messageController,
            decoration: InputDecoration(
              labelText: "Send Message",
              suffixIcon: IconButton(
                onPressed: () {
                  String message = widget._messageController.text;
                  if (message.isNotEmpty) {
                    sendBulkSms(select, message);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SendMessageView()));
                  } else {
                    print("Message Cannot Be Empty");
                  }
                },
                icon: const Icon(Icons.send),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
