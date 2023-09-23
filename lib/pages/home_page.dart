import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:recommendationsapp/pages/list_page.dart';
import 'package:recommendationsapp/utils/tab_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activePageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade900,
        title: Text(
          pageDetails[_activePageIndex]['title'],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(
            () {
              _activePageIndex = index;
            },
          );
        },
        children: [
          pageDetails[0]['pageName'],
          pageDetails[1]['pageName'],
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.cyan.shade900,
        items: [
          Icon(
            Icons.list,
            color: Colors.white,
          ),
          Icon(
            Icons.add,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: Duration(microseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }
}
