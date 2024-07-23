import 'package:bulk_sms_app/services/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessageView extends StatefulWidget {
  const SendMessageView({super.key});

  @override
  State<SendMessageView> createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final messages = messageProvider.messages;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Sort a Messages"),
          actions: const [],
        ),
        body: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];

            return Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.orange[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Text(message.phoneNumber),
                subtitle: Text(message.content),
                trailing: Text(message.timestamp.toLocal().toString()),
                leading: CircleAvatar(
                  child: Text(message.phoneNumber.characters.first),
                ),
              ),
            );
          },
        ));
  }
}
