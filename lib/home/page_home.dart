import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid_flutter/common/api.dart';
import 'package:wanandroid_flutter/network/networkUtil.dart';
import 'package:wanandroid_flutter/common/commonUtil.dart';
import 'package:wanandroid_flutter/web/page_web.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List _dataArray = [];
  List _bannerData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadBannerInfo();
    _loadData(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildListVie(),
    );
  }

  Widget _buildListVie() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int position) {
        if (position == 0) {
          return Container(
            height: 170,
            child: _bannerData.length > 0 ? _buildSwiper() : Container(),
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
          return _buildItem(_dataArray[position - 2]);
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: (index == 0 || index==1) ? 0 : 10,
          color: Colors.black12,
        );
      },
      itemCount: _dataArray.length + 2,
    );
  }

  Widget _buildSwiper() {
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
      onTap: (int index){
        if (_bannerData[index]["url"] != null) {
          CommonUtil.jumpToOtherPage(context, WebPage(loadUrl: _bannerData[index]["url"], title: _bannerData[index]["title"],));
        }
      },
    );
  }

  Widget _buildItem(Map data) {
    return Container(
      height: 120,
      color: Colors.white,
      child: InkWell(
        onTap: (){
          if (data["link"] != null) {
            CommonUtil.jumpToOtherPage(context, WebPage(loadUrl: data["link"], title: data["title"],));
          }
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 8,
              left: 15,
              child: Image(
                width: 25,
                height: 25,
                image: AssetImage('assets/mine/header.png'),
              ),
            ),
            Positioned(
              top: 0,
              right: 15,
              child: IconButton(
                icon: Image(image: AssetImage('assets/mine/heart.png'),),
                onPressed: (){
                  CommonUtil.clickFavouriteBtn(context, data);
                },
              ),
            ),
            Positioned(
              top: 12,
              left: 50,
              child: Text(data["author"], style: TextStyle(fontSize: 14),),
            ),
            Positioned(
              top: 45,
              left: 15,
              right: 15,
              child: Text(data["title"], style: TextStyle(fontSize: 15),),
            ),
            Positioned(
              top: 95,
              left: 15,
              child: Text(_getCategoryString(data), style: TextStyle(fontSize: 13),),
            ),
            Positioned(
              top: 90,
              right: 15,
              child: Text(data["niceDate"], style: TextStyle(fontSize: 13),),
            ),
          ],
        ),
      )
    );
  }

  String _getCategoryString(Map data){
    String category = data["chapterName"];
    String superCategory = data["superChapterName"];
    return "分类：$superCategory/$category";
  }

  // network
  void _loadData(int page) {
    NetWorkUtil().GET("/article/list/$page/json", null, (success) {
      setState(() {
        _dataArray = success["data"]["datas"];
        print(_dataArray);
      });
    }, (error) {
      print(error);
    });
  }

  void _loadBannerInfo() {
    NetWorkUtil().GET(Api.homeBanner, null, (success) {
      setState(() {
        _bannerData = success['data'];
      });
    }, (error) {
      print(error);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
