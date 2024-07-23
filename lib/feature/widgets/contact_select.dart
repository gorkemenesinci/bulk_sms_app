import 'package:bulk_sms_app/services/provider/contact_provider.dart';
import 'package:bulk_sms_app/feature/screens/send_message.dart';
import 'package:flutter/material.dart';

class ContactSelect extends StatelessWidget {
  const ContactSelect({
    super.key,
    required this.screenHeight,
    required this.contactProvider,
    required this.controller,
  });

  final double screenHeight;
  final ContactProvider contactProvider;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
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
                  var select = contactProvider.select.add;

                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                        onTap: () {
                          select(contact.displayName!);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SendMessagePage()));
                        },
                        title: Text(contact.displayName ?? "Name Not Found"),
                        subtitle: contact.phones!.isNotEmpty
                            ? Text(contact.phones![0].value ??
                                "Phone Number Not Found")
                            : const Text("Phone Number Not Found")),
                  );
                },
              ),
      ),
    ]);
  }
}
