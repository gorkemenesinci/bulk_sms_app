import 'package:bulk_sms_app/feature/widgets/request_contact.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> _results = [];
  final List<String> _select = [];

  List<Contact> get contacts => _contacts;
  List<Contact> get results => _results;
  List<String> get select => _select;

  Future<void> loadContacts() async {
    requestContactPermission().then((_) async {
      _contacts = await ContactsService.getContacts();
      _results = _contacts;
      notifyListeners();
    });
  }

  void clearSelection() {
    _select.clear();
    notifyListeners();
  }

  void searchContacts(String search) {
    if (search.isEmpty) {
      _results = _contacts;
    } else {
      _results = _contacts.where((contact) {
        return contact.displayName != null &&
            contact.displayName!.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
  }

  @override
  notifyListeners();
}
