import 'package:bulk_sms_app/feature/widgets/background_colors.dart';
import 'package:bulk_sms_app/services/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SendMessageView extends StatefulWidget {
  const SendMessageView({super.key});

  @override
  State<SendMessageView> createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  BackgroundColors colors = BackgroundColors();
  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final messages = messageProvider.messages;

    return Scaffold(
        backgroundColor: colors.backgroundColor,
        appBar: AppBar(
          backgroundColor: colors.backgroundColor,
          title: Text(
            "Sort a Messages",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
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
                subtitle: Text(
                  message.content,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(DateFormat("dd MM yyyy, HH:mm:ss")
                    .format(message.timestamp.toLocal())),
                leading: CircleAvatar(
                  child: Text(message.phoneNumber.characters.first),
                ),
              ),
            );
          },
        ));
  }
}
