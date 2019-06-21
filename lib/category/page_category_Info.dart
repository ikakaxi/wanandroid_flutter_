import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/commonUtil.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';
import 'package:wanandroid_flutter/web/page_web.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoryInfoPage extends StatefulWidget {
  List _dataList;
  int _selected;
  String title;
  CategoryInfoPage(this._dataList, this._selected, this.title) : super();

  @override
  State<StatefulWidget> createState() {
    return CategoryInfoState();
  }
}

class CategoryInfoState extends State<CategoryInfoPage>
    with SingleTickerProviderStateMixin {
  TabController tabController; // 先声明变量
  List dataList = [];
  int _page = 0;

  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    this.tabController = TabController(
      vsync: this, // 动画效果的异步处理
      length: widget._dataList.length, // tab 个数
      initialIndex: widget._selected,
    );
    tabController.addListener(() {
      widget._selected = tabController.index;
      _loadData(widget._dataList[tabController.index]);
    });
    if (mounted != null) {
      _loadData(widget._dataList[widget._selected]);
    }
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          isScrollable: true,
          controller: this.tabController,
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.blue[200],
          labelColor: Colors.white,
          tabs: _buildTab(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: _buildTabBarViews(),
      ),
    );
  }

  _onLoading() {
    _page = _page+1;
    _loadData(widget._dataList[widget._selected], page: _page);
  }

  _onRefresh() {
    _page = 0;
    _loadData(widget._dataList[widget._selected]);
  }

  List<Tab> _buildTab() {
    List<Tab> tabs = [];
    for (int i = 0; i < widget._dataList.length; i++) {
      Map data = widget._dataList[i];
      tabs.add(Tab(
        text: data["name"],
      ));
    }
    return tabs;
  }

  List<Widget> _buildTabBarViews() {
    List<Widget> _tabBarViews = [];
    for (int i = 0; i < widget._dataList.length; i++) {
      _tabBarViews.add(
        SmartRefresher(
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.white,
                child: _buildListItem(dataList[index]),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 1,
              );
            },
            itemCount: dataList.length,
          ),
        ),
      );
    }
    return _tabBarViews;
  }

  Widget _buildListItem(Map data) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          if (data["link"] != null) {
            CommonUtil.jumpToOtherPage(
                context,
                WebPage(
                  loadUrl: data["link"],
                  title: data["title"],
                ));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/mine/header.png',
                        width: 25,
                        height: 25,
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        data["author"],
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    CommonUtil.clickFavouriteBtn(context, data);
                  },
                  child: Image.asset('assets/mine/heart.png'),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                data["title"],
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                data["niceDate"],
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // network
  void _loadData(Map data, {int page = 0}) {
    Map<String, dynamic> param = {"cid": data["id"]};
    NetWorkUtil().GET("/article/list/$page/json", param, (success) {
      List tempList = [];
      List list = success["data"]["datas"];
      if (page == 0) {
        tempList = list;
        _refreshController.refreshCompleted(resetFooterState: true);
      } else {
        tempList = dataList;
        if (list.length == 0) {
          _refreshController.loadNoData();
        } else {
          tempList.addAll(list);
          _refreshController.loadComplete();
        }
      }
      setState(() {
        dataList = tempList;
      });
    }, (error) {
      if (page == 0) {
        _refreshController.refreshFailed();
      } else {
        _refreshController.loadFailed();
      }
      print(error);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }
}
