import 'package:bulk_sms_app/feature/screens/view_message.dart';
import 'package:bulk_sms_app/feature/widgets/colors.dart';
import 'package:bulk_sms_app/services/provider/contact_provider.dart';
import 'package:bulk_sms_app/feature/screens/access_contact.dart';
import 'package:bulk_sms_app/feature/widgets/sort_and_sent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessagePage extends StatefulWidget {
  const SendMessagePage({super.key});

  @override
  State<SendMessagePage> createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  final TextEditingController _messageController = TextEditingController();
  BackgroundColors colors = BackgroundColors();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final contactProvider = Provider.of<ContactProvider>(context);
    var select = contactProvider.select;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colors.backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SendMessageView()));
            },
            icon: const Icon(
              Icons.send,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AccessContact()));
            },
            icon: const Icon(
              Icons.add_circle,
              color: Colors.black,
            ),
          ),
        ],
        title: Text(
          "Messages",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SortAndSent(
          contactProvider: contactProvider,
          select: select,
          screenHeight: screenHeight,
          messageController: _messageController),
    );
  }
}
