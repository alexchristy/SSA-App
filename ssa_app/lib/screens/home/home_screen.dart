import 'package:flutter/material.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/services/custom_icons/airport.dart';
import 'package:ssa_app/screens/terminal-list/terminal_list_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssa_app/providers/terminals_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Widget _homeTabContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/c17_frontal_square_windows.svg',
            width: 80,
            height: 80,
            color: AppColors.greenBlue,
          ),
          RichText(
              text: const TextSpan(children: [
            TextSpan(
                text: "Smart",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: AppColors.prussianBlue,
                )),
            TextSpan(
                text: "SpaceA",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greenBlue,
                ))
          ])),
          const Spacer(
              flex: 1), // This spacer will take up available space equally
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(),
              // Terminals button
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 86,
                    height: 86,
                    child: RawMaterialButton(
                      onPressed: () {
                        navigateToTerminalList();
                      },
                      elevation: 0,
                      fillColor: AppColors.greenBlue,
                      shape: const CircleBorder(),
                      child: const Icon(Airport.airport_icon,
                          size: 45, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8), // Space between icon and label
                  const Text('Terminals',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(), // This spacer will take up available space equally
              // Favorites button
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 86,
                    height: 86,
                    child: RawMaterialButton(
                      onPressed: () {
                        // Favorites button action
                      },
                      elevation: 0,
                      fillColor: AppColors.greenBlue,
                      shape: const CircleBorder(),
                      child:
                          const Icon(Icons.star, size: 45, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8), // Space between icon and label
                  const Text('Favorites',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(), // This spacer will take up available space equally
            ],
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // Options for each tab
  List<Widget> _widgetOptions() {
    return <Widget>[
      _homeTabContent(), // Home tab content
      const Text('Explore Page',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      const Text('Profile Page',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToTerminalList() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<TerminalsProvider>(
          create: (_) =>
              TerminalsProvider(), // Create a new instance of the provider
          child: TerminalsList(), // Your destination screen
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _widgetOptions().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.greenBlue,
        onTap: _onItemTapped,
        elevation: 0,
      ),
    );
  }
}
