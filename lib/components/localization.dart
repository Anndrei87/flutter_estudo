import 'package:bytebank_contato_2/components/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'container.dart';

class LocalizationContainer extends BlocContainer {
  Widget child;


  LocalizationContainer({required Widget this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentLocaleCubit>(
      create: (context) => CurrentLocaleCubit(),
      child: this.child,);
  }
}

class CurrentLocaleCubit extends Cubit<String> {
  CurrentLocaleCubit() : super('en');
}

class ViewI18N {
  String? _language;

  ViewI18N(BuildContext context) {
    this._language = BlocProvider
        .of<CurrentLocaleCubit>(context)
        .state;
  }

  localize(Map<String, String> values) {
    assert(values != null); // cláusula de guarda
    assert(values.containsKey(_language)); // para o error de null ficar claro

    return values[_language];
  }
}

@immutable
abstract class I18NMessagesState {
  const I18NMessagesState();
}

@immutable
class LoadingI18NMessagesState extends I18NMessagesState {
  const LoadingI18NMessagesState();
}

@immutable
class InitI18NMessagesState extends I18NMessagesState{
  const InitI18NMessagesState();
}

@immutable
class LoadedI18NMessagesState extends I18NMessagesState {
  final I18Nmessages _messages;
  const LoadedI18NMessagesState(this._messages);
}

class I18Nmessages {
  final Map<String, String> _messages;
  I18Nmessages(this._messages);

  get(String key){
    assert(key != null);
    assert(_messages.containsKey(key));
    return _messages[key];
  }
}

class FatalErrorI18NMessagesState extends I18NMessagesState {
  const FatalErrorI18NMessagesState();
}


class I18NMessagesCubit extends Cubit<I18NMessagesState>{
  I18NMessagesCubit() : super(const InitI18NMessagesState());

   reload() {
    emit(const LoadingI18NMessagesState());
  }

}

typedef I18NWidgetCreator = Function(I18Nmessages messages);

class I18NLoadingContainer extends BlocContainer{
  final I18NWidgetCreator _creator;
  I18NLoadingContainer(this._creator);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(create: (context){
      final cubit = I18NMessagesCubit();
      cubit.reload();
      return cubit;
    },
    child: I18NLoadingView(this._creator),
    );
  }

}

class I18NLoadingView extends StatelessWidget {
  final I18NWidgetCreator _creator;

  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>(
        builder: (context, state) {
          if (state is InitI18NMessagesState || state is LoadingI18NMessagesState) {
            return const Progress();
          }
          if(state is LoadedI18NMessagesState){
            final messages = state._messages;
            return _creator.call(messages);
          }
          return const Text('Erro ao buscar mensagens');
        });
  }
}



