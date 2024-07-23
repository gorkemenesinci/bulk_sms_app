import 'package:bulk_sms_app/services/provider/contact_provider.dart';
import 'package:bulk_sms_app/services/provider/message_provider.dart';
import 'package:bulk_sms_app/feature/screens/send_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ContactProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SendMessagePage(),
    );
  }
}
