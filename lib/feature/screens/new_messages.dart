import 'package:bulk_sms_app/feature/provider/contact_provider.dart';
import 'package:bulk_sms_app/feature/screens/messages.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMessagesPage extends StatefulWidget {
  const NewMessagesPage({super.key});

  @override
  State<NewMessagesPage> createState() => _NewMessagesPageState();
}

class _NewMessagesPageState extends State<NewMessagesPage> {
  final controller = TextEditingController();
  final List<String> selectedContacts = [];

  @override
  void initState() {
    super.initState();
    final contactProvider =
        Provider.of<ContactProvider>(context, listen: false);
    contactProvider.loadContacts();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sendsms() {
    String sms1 = "sms: 9292 ";
    // ignore: deprecated_member_use
    launch(sms1);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final contactProvider = Provider.of<ContactProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Messages",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.1,
            child: TextField(
              onChanged: (value) {
                contactProvider.searchContacts(value);
              },
              controller: controller,
              decoration: const InputDecoration(
                hintText: " Search:",
              ),
            ),
          ),
          Expanded(
            child: contactProvider.results.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: contactProvider.results.length,
                    itemBuilder: (context, index) {
                      var contact = contactProvider.results[index];
                      return ListTile(
                          title: Text(contact.displayName ?? "Name Not Found"),
                          subtitle: contact.phones!.isNotEmpty
                              ? Text(contact.phones![0].value ??
                                  "Phone Number Not Found")
                              : const Text("Phone Number Not Found"));
                    },
                  ),
          ),
        ]));
  }
}
