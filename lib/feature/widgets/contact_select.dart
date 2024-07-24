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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: screenHeight * 0.1,
          child: TextField(
            onChanged: (value) {
              contactProvider.searchContacts(value);
            },
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  gapPadding: 8, borderRadius: BorderRadius.circular(20)),
              hintText: "Search",
              alignLabelWithHint: true,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.black),
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
                    bool isSelected =
                        contactProvider.select.contains(contact.displayName);

                    return Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.redAccent : Colors.green[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        enabled: isSelected ? false : true,
                        onTap: () {
                          contactProvider.select.add(contact.displayName!);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SendMessagePage(),
                          ));
                        },
                        title: Text(contact.displayName ?? "Name Not Found"),
                        subtitle: contact.phones!.isNotEmpty
                            ? Text(contact.phones![0].value ??
                                "Phone Number Not Found")
                            : const Text("Phone Number Not Found"),
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}
