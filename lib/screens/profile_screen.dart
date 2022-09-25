import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:quizu/cache/shared_preference_helper.dart';
import 'package:quizu/exports/components.dart' show CustomSnackbar, Logo, Profile;
import 'package:quizu/routes/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // values
  int _selectedIndex = 2;
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
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await SharedPreferencesHelper.instace.clearToken();
                Navigator.of(context).pushReplacementNamed(Routes.login);
              } catch (e) {
                CustomSnackbar.showSnackBar(context, e.toString());
              }
            },
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Logo(),
      ),
      bottomNavigationBar: _navigation(),
      body: Profile(),
    );
  }
}
