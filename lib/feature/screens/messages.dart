import 'package:bulk_sms_app/feature/screens/new_messages.dart';
import 'package:bulk_sms_app/models/getcontacts.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  @override
  void initState() {
    super.initState();
    requestContactPermission().then((_) {
      getContacts(); // İzin verildikten sonra kişileri al
    });
  }

  Future<List<Contact>> getContacts() {
    return ContactsService.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewMessagesPage()));
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
        title: Text(
          "Messages",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.1,
            child: TextFormField(),
          ),
          Expanded(
            child: FutureBuilder(
              future: getContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasData == null &&
                        snapshot.connectionState == ConnectionState.none ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].displayName ??
                          "Name Not Found"),
                      subtitle: Text(
                          snapshot.data![index].phones![0].value.toString() ??
                              "Phone Number Not Found"),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
