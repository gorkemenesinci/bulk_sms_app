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
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AccessContact()));
            },
            icon: const Icon(Icons.add_circle),
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
