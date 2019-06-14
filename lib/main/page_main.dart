import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/home/page_home.dart';
import 'package:wanandroid_flutter/category/page_category.dart';
import 'package:wanandroid_flutter/mine/page_mine.dart';
import 'package:wanandroid_flutter/project/page_project.dart';


class MainPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> with SingleTickerProviderStateMixin<MainPage> {

  TabController tabController;
  int _selectIndex = 0;
  final List<String> titles = ["首页", "体系", "项目", "我的"];
  final List<String> images = ["assets/home.png", "assets/category.png", "assets/project.png", "assets/mine.png"];
  final List<Widget> widgets = [
    HomePage(),
    CategoryPage(),
    ProjectPage(),
    MinePage(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: titles.length,
    );
    tabController.addListener((){
      setState(() {
        _selectIndex = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectIndex]),
      ),
      body: TabBarView(
        children: widgets,
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        child: Material(
          child: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            controller: tabController,
            tabs: _getTabs(),
            indicatorWeight: 0.1,
          ),
          color: Colors.white,
        ),
      ),
    );
  }

  List<Tab> _getTabs() {

    List<Tab> tabs = [];
    for (int i = 0; i < titles.length; i++){
      tabs.add(Tab(
        text: titles[i],
        icon: Image(
          width: 24,
          height: 24,
          color: _selectIndex == i ? Colors.blue : Colors.grey,
          image: AssetImage(images[i]),
        ),
      ));
    }
    return tabs;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }
}