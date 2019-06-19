import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/common/commonUtil.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';
import 'package:wanandroid_flutter/web/page_web.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage> {
  List _typesList = [];
  List _dataList = [];
  Map _typeMap;
  int _page = 1;

  RefreshController _refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted != null) {
      _loadData();
      _refreshController = RefreshController(initialRefresh: true);
    }
  }

  _onLoading() {
    _page = _page+1;
    _loadDataByType();
  }

  _onRefresh() {
    _page = 1;
    _loadDataByType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildDrawerListView(),
      body: Container(
        child: Column(
          children: <Widget>[
            Builder(
              builder: (context) {
                return _buildHeader(context);
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: SmartRefresher(
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _refreshController,
                  child:_buildListView(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "选择分类",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Text(
            null == _typeMap ? "" : _typeMap["name"],
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          IconButton(
            icon: Image.asset("assets/project/menu_item.png"),
            highlightColor: Colors.white10,
            splashColor: Colors.white10,
            onPressed: () {
              setState(() {
                print("abc");
                Scaffold.of(context).openEndDrawer();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.black26,
          height: 10,
        );
      },
      itemCount: _dataList.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildItem(_dataList[position]);
      },
    );
  }

  Widget _buildItem(Map data) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: InkWell(
          onTap: (){
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/mine/header.png",
                          width: 24,
                          height: 24,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            data["author"],
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Image.asset('assets/mine/heart.png'),
                    onPressed: () {
                      CommonUtil.clickFavouriteBtn(context, data);
                    },
                  ),
                ],
              ),
              Container(
                height: 150,
                child: Image.network(
                  data["envelopePic"],
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  data["title"],
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  data["niceDate"],
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerListView() {
    return Container(
      width: 200,
      child: Drawer(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black26,
              height: 1,
            );
          },
          itemCount: _typesList.length,
          itemBuilder: (BuildContext context, int position) {
            return _buildDrawerItem(_typesList[position]);
          },
        ),
      ),
    );
  }

  Widget _buildDrawerItem(Map data) {
    return ListTile(
      leading: Text(data["name"]),
      onTap: () {
        _typeMap = data;
        _page = 1;
        _loadDataByType();
        Navigator.of(context).pop();
      },
    );
  }

  // network
  void _loadData() async {
    Future<dynamic>.delayed(Duration(seconds: 0), () {
      return NetWorkUtil().GET(Api.projectType, null, (success) {
        _typesList = success['data'];
        _refreshController.refreshCompleted(resetFooterState: true);
        setState(() {
          _typeMap = _typesList.first;
        });
      }, (error) {
        print(error);
      });
    }).then((_) {
      _loadDataByType();
    });
  }

  void _loadDataByType() async {
    print(_typeMap);
    if (null == _typeMap) return;
    String cid = _typeMap["id"].toString();
    NetWorkUtil().GET("/project/list/$_page/json?cid=$cid", null, (success) {
      List tempList = [];
      List list = success["data"]["datas"];
      if (_page == 1) {
        tempList = list;
        _refreshController.refreshCompleted();
      } else {
        tempList = _dataList;
        if (list.length == 0) {
          _refreshController.loadNoData();
        } else {
          tempList.addAll(list);
          _refreshController.loadComplete();
        }
      }
      setState(() {
        _dataList = tempList;
      });
    }, (error) {
      if (_page == 1) {
        _refreshController.refreshFailed();
      } else {
        _refreshController.loadFailed();
      }
      print(error);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    super.dispose();
  }
}
