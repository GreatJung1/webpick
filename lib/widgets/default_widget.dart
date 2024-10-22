import 'package:flutter/material.dart';
import '../search/search.dart';
import '../collection/collection.dart';
import '../home/home.dart';
import '../pickabook/pickABook_page.dart';
import '../my_page/my_page.dart';

class DefaultWidget extends StatefulWidget {
  const DefaultWidget({Key? key}) : super(key: key);

  @override
  _DefaultWidgetState createState() => _DefaultWidgetState();
}

class _DefaultWidgetState extends State<DefaultWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      SearchBarPage(),
      Collection(),
      HomePage(),
      PickABookPage(),
      MyPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 40.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.today,
              size: 40.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 40.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_rounded,
              size: 40.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 40.0,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
