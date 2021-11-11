import 'package:flutter/material.dart';

class TransactionDialog extends StatefulWidget {
  const TransactionDialog({Key? key, required this.onConfirm}) : super(key: key);

  final Function(String password) onConfirm;

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Text('Authenticate' ),
      content:   TextField(
        controller: _passwordController,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        obscureText: true,
        style: const TextStyle(fontSize: 54 ,letterSpacing: 30),
        textAlign: TextAlign.center,
        maxLength: 4,
        keyboardType: TextInputType.number ,
      ),
      actions: [
        TextButton(onPressed: ()=> Navigator.pop(context),
            child: const Text('CANCEL')),
        TextButton(onPressed: (){
          widget.onConfirm(_passwordController.text);
          Navigator.pop(context);
        },
            child: const Text('CONFIRM'))
      ],
    );
  }
}

