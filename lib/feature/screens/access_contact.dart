import 'package:bulk_sms_app/services/provider/contact_provider.dart';
import 'package:bulk_sms_app/feature/widgets/contact_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccessContact extends StatefulWidget {
  const AccessContact({super.key});

  @override
  State<AccessContact> createState() => _AccessContactState();
}

class _AccessContactState extends State<AccessContact> {
  final controller = TextEditingController();

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
        body: ContactSelect(
            screenHeight: screenHeight,
            contactProvider: contactProvider,
            controller: controller));
  }
}
