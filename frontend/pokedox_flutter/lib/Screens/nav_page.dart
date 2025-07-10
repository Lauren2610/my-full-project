import 'package:flutter/material.dart';
import 'package:pokedox_flutter/Provider/home_provider.dart';
import 'package:provider/provider.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder:
          (context, homeProvider, child) => Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: homeProvider.selectedIndex,
              onTap: homeProvider.onPageChange,
              // selectedItemColor: Theme.of(context).colorScheme.primary,
              // unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home)),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline_sharp),
                ),
                BottomNavigationBarItem(icon: Icon(Icons.settings)),
              ],
            ),
            body: PageView(),
          ),
    );
  }
}
