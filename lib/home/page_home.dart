import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid_flutter/bloc/bloc_provider.dart';
import 'package:wanandroid_flutter/bloc/home_bloc.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';
import 'package:wanandroid_flutter/common/commonUtil.dart';
import 'package:wanandroid_flutter/web/page_web.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List _dataArray = [];
  List _bannerData = [];
  int _page = 0;

  RefreshController _refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted != null) {
//      _loadBannerInfo();
      _loadData();
      _refreshController = RefreshController(initialRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        onRefresh: _onRefresh,
        onLoading: _onLoading,
//        header: _header,
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        child: _buildListView(),
      ),
    );
  }

  _onLoading() {
    _page = _page + 1;
    _loadData(page: _page);
  }

  _onRefresh() {
    _page = 0;
    _loadData();
  }

  Widget _buildListView() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int position) {
        if (position == 0) {
          return Container(
            height: 170,
            child: _bannerData.length > 0
                ? ProviderBloc(
                    bloc: HomeBloc(),
                    child: _buildSwiper(),
                  )
                : Container(),
          );
        } else if (position == 1) {
          return Container(
            color: Colors.black12,
            height: 44,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Text(
              "最新博文",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          );
        } else {
          return Container(
            color: Colors.white,
            child: _buildItem(_dataArray[position - 2]),
          );
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: (index == 0 || index == 1) ? 0 : 10,
          color: Colors.black12,
        );
      },
      itemCount: _dataArray.length + 2,
    );
  }

  Widget _buildSwiper() {
    HomeBloc homeBloc = ProviderBloc.of(context);
    return StreamBuilder(
      stream: homeBloc.homeBlocStream,
      builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
        print(snapshot);
        _bannerData = snapshot as List;
        return Swiper(
          itemBuilder: (BuildContext context, int index) {
            return new Image.network(
              _bannerData[index]["imagePath"],
              fit: BoxFit.fill,
            );
          },
          autoplay: true,
          itemCount: _bannerData.length,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
          onTap: (int index) {
            if (_bannerData[index]["url"] != null) {
              CommonUtil.jumpToOtherPage(
                  context,
                  WebPage(
                    loadUrl: _bannerData[index]["url"],
                    title: _bannerData[index]["title"],
                  ));
            }
          },
        );
      },
    );
  }

  Widget _buildItem(Map data) {
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
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          _getCategoryString(data),
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    data["niceDate"],
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryString(Map data) {
    String category = data["chapterName"];
    String superCategory = data["superChapterName"];
    return "分类：$superCategory/$category";
  }

  // network
  void _loadData({int page = 0}) {
    NetWorkUtil().GET("/article/list/$page/json", null, (success) {
      List tempList = [];
      List list = success["data"]["datas"];
      if (page == 0) {
        tempList = list;
        _refreshController.refreshCompleted(resetFooterState: true);
      } else {
        tempList = _dataArray;
        if (list.length == 0) {
          _refreshController.loadNoData();
        } else {
          tempList.addAll(list);
          _refreshController.loadComplete();
        }
      }
      setState(() {
        _dataArray = tempList;
        print(_dataArray);
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

//  void _loadBannerInfo() {
//    NetWorkUtil().GET(Api.homeBanner, null, (success) {
//      setState(() {
//        _bannerData = success['data'];
//      });
//    }, (error) {
//      print(error);
//    });
//  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    super.dispose();
  }
}
