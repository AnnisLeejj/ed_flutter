import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home/HomePage.dart';
import 'home/MessagePage.dart';
import 'home/MinePage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState2 extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text("主页"),
    );
  }
}

class _MainPageState extends State<MainPage> {
  int _currentPageIndex = 0;
  var _pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new PageView.builder(
        onPageChanged: _pageChange,
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          return getPage(index);
        },
        itemCount: 3,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text("任务")),
          BottomNavigationBarItem(
              icon: new Icon(Icons.message), title: new Text("消息")),
          BottomNavigationBarItem(
              icon: new Icon(Icons.portrait), title: new Text("我的")),
        ],
        currentIndex: _currentPageIndex,
        onTap: onTap,
      ),
    );
  }

  // bottomnaviagtionbar 和 pageview 的联动
  void onTap(int index) {
    _pageController.jumpToPage(index);
    // 过pageview的pagecontroller的animateToPage方法可以跳转
//    _pageController.animateToPage(index,
//        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _pageChange(int index) {
    setState(() {
      if (_currentPageIndex != index) {
        _currentPageIndex = index;
      }
    });
  }

  Widget first, second, third;

  Widget getPage(int index) {
    switch (index) {
      case 0:
        if (first == null) {
          first = HomePage();
        }
        break;
      case 1:
        if (second == null) {
          second = MessagePage();
        }
        break;
      case 2:
        if (third == null) {
          third = MinePage();
        }
        break;
    }
    return index == 0 ? first : (index == 1 ? second : third);
  }
}
