import 'dart:ui';

import 'package:bytebank_contato_2/database/dao/contact_dao.dart';
import 'package:bytebank_contato_2/models/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("New contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                  top: 16.0, bottom: 24.0, left: 8.0, right: 8.0),
              child: Text(
                "Insira um novo contact bank",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: "Account number",
                ),
                style: const TextStyle(
                  fontSize: 24,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepPurple)
                    ),
                    onPressed: () {
                      final String name = _nameController.text;
                      final int? account = int.tryParse(_numberController.text);
                      final Contact newAccount = Contact(name, account!, 0);
                      _dao
                          .save(newAccount)
                          .then((id) => Navigator.pop(context));
                    },
                    child: const Text('Create')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
