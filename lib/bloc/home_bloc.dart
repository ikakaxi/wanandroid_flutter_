import 'dart:async';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';

import 'bloc_base.dart';

class HomeBloc implements BlocBase {

  List<Map> list;

  StreamController<List<Map>> streamController = StreamController<List<Map>>();
  Stream<List<Map>> get homeBlocStream => streamController.stream;

  HomeBloc() {
    NetWorkUtil().GET(Api.homeBanner, null, (success) {
      streamController.sink.add(success['data']);
    }, (error) {
      print(error);
    });
  }

  @override
  void dispose() {
    streamController.close();
  }
}