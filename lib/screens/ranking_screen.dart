import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:quizu/exports/components.dart' show Logo;
import 'package:quizu/routes/routes.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  // values
  int _selectedIndex = 1;
  List<String> routes = [Routes.home, Routes.ranking, Routes.profile];

  //methods
  Widget _navigation() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 14,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[400],
        items: getNavigationItem(),
        onTap: (index) {
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
              _changeScreen();
            });
          }
        },
      ),
    );
  }

  void _changeScreen() {
    Navigator.of(context).pushReplacementNamed(routes[_selectedIndex]);
  }

  List<BottomNavigationBarItem> getNavigationItem() {
    return [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home_filled,
          size: 34,
        ),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          FontAwesomeIcons.trophy,
          size: 34,
        ),
        label: "",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
          size: 34,
        ),
        label: "",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Logo(),
      ),
      bottomNavigationBar: _navigation(),
    );
  }
}
