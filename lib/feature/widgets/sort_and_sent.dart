import 'dart:convert';
import 'package:bulk_sms_app/feature/widgets/background_colors.dart';
import 'package:bulk_sms_app/services/provider/contact_provider.dart';
import 'package:bulk_sms_app/services/provider/message_provider.dart';
import 'package:bulk_sms_app/feature/screens/view_message.dart';
import 'package:bulk_sms_app/models/message_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  BackgroundColors colors = BackgroundColors();

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    var select = contactProvider.select;
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: contactProvider.select.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _showDeleteConfirmationDialog(context, index);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green[100],
                    ),
                    margin: const EdgeInsets.all(5),
                    child: Text(
                      select[index],
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: widget.screenHeight * 0.10,
            child: TextFormField(
              controller: widget._messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  gapPadding: 8,
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: "Send Message",
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black),
                suffixIcon: IconButton(
                  onPressed: () {
                    String message = widget._messageController.text;

                    if (message.isNotEmpty) {
                      sendBulkSms(select, message);
                      showToast("Send is Successfuly", colors.trueSend);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SendMessageView(),
                      ));
                      widget._messageController.clear();
                    } else {
                      showToast("Message Cannot Be Empty", colors.falseSend);
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          timestamp: DateTime.now(),
        ));
      } else {
        showToast("ERROR", colors.falseSend);
      }
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Do You Want To Remove The Name?"),
          content: Text(
            "Are You Sure?",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                setState(() {
                  widget.select.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showToast(String message, Color background) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: background,
        textColor: Colors.black,
        fontSize: 16);
  }
}
