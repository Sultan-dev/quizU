import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:quizu/exports/components.dart' show Logo;
import 'package:quizu/routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // values
  int _selectedIndex = 0;
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

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.question_presenter);
      },
      child: Text(
        "Quiz Me!",
        style: Theme.of(context).textTheme.button!.copyWith(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400],
        fixedSize: Size(120, 50),
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Logo(),
        ),
        bottomNavigationBar: _navigation(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ready to test your knowledge and challenge others?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 15),
            _buildButton(),
            SizedBox(height: 15),
            Text(
              'Answer as much questions correctly within 2 minutes',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}
