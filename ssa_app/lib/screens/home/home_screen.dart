import 'package:flutter/material.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/services/custom_icons/airport.dart';
import 'package:ssa_app/services/custom_icons/c17_frontal.dart';
import 'package:ssa_app/screens/terminal-list/terminal_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(C17Frontal.c17_frontal_square_windows, size: 40),
            SizedBox(width: 10),
            Text('SmartSpaceA'),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Spacer to push the buttons to 1/3 and 2/3 positions
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => TerminalsList()),
                          );
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
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
                        child: const Icon(Icons.star,
                            size: 45, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8), // Space between icon and label
                    const Text('Favorites',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(), // This spacer will take up available space equally
              ],
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
