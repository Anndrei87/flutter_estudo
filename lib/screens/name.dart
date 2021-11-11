import 'package:bytebank_contato_2/components/container.dart';
import 'package:bytebank_contato_2/models/name.dart';
import 'package:bytebank_contato_2/screens/darshboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameContainer extends BlocContainer {
  const NameContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NameView();
  }
}

class NameView extends StatelessWidget {
  NameView({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // essa maneira n tem problema nessa abordagem, pois n é feita um rebuild quando o estado pe alterado
    _nameController.text = context.read<NameCubit>().state;

    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('Mudar o nome'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Mudar seu nome',
                ),
                style: const TextStyle(fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurple)),
                    onPressed: () {
                      final name = _nameController.text;
                      context.read<NameCubit>().change(name);
                      Navigator.of(context).pop(MaterialPageRoute(builder: (context)=> const Dashboard()));
                    },
                    child: const Text('Change'),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
