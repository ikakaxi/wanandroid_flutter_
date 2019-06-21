import 'package:flutter/material.dart';
import 'bloc_base.dart';

class ProviderBloc<T extends BlocBase> extends StatefulWidget {

  final T bloc;
  final Widget child;

  ProviderBloc({Key key, this.bloc, this.child}):super(key:key);

  @override
  State<StatefulWidget> createState() => ProviderBlocState();

  static K of<K extends BlocBase>(BuildContext context){
    Type type = _typeof<ProviderBloc<K>>();
    ProviderBloc<K> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeof<E>() {
    return E;
  }
}

class ProviderBlocState extends State<ProviderBloc> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.child;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.bloc.dispose();
    super.dispose();
  }
}