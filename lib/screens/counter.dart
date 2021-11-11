import 'package:bytebank_contato_2/components/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// exemplo de contador, usando bloc
class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(initialState);

  void increment() => emit(state + 1); // emit notifica os builders a ser redesenhados

  void decrement() => emit(state - 1);
}

class CounterContainer extends BlocContainer {
  const CounterContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // o block provider é quem junta o cubit com a view
      create: (context) => CounterCubit(0),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget { // ouve o container para alterar os estados
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nosso Contador'),
      ),
      body: Center(
        // segunda forma de acessar o bloc
        child: BlocBuilder<CounterCubit, int>( // builder redesenhado pelo emit
          builder: (context, state) {
           return Text('$state', style: textTheme.headline2);
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            // abordagem 1 de acessar o bloc
            onPressed: () => context.read<CounterCubit>().increment(), // aciona o emit a redesenhar o build
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}
