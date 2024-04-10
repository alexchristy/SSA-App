import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/screens/sign-up/sign_up_screen.dart';
import 'package:ssa_app/services/custom_icons/airport.dart';
import 'package:ssa_app/screens/terminal-list/terminal_list_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssa_app/providers/global_provider.dart';

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

  Widget _profileTabContent() {
    final edgePadding = Provider.of<GlobalProvider>(context).cardPadding;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: edgePadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the start
            children: [
              profileTabHeader(), // The header now includes the Profile text and the icon
              loginSignupButton(
                  edgePadding: edgePadding), // Login/Signup button
              manageAccountText(
                  edgePadding: edgePadding), // Manage account text
              buttonsGrouped(edgePadding: edgePadding), // Grouped buttons
            ],
          ),
        ));
  }

  Widget profileTabHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
      children: [
        Expanded(
          // Wrap the Profile Page text to prevent overflow and align properly
          child: Text('Profile',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ),
        Column(children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: AppColors.greenBlue,
            child: Icon(Icons.person, size: 30, color: Colors.white),
          )
        ]),
      ],
    );
  }

  Widget loginSignupButton({required double edgePadding}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: edgePadding), // Consistent with filter button spacing
      decoration: BoxDecoration(
        color: AppColors.greenBlue, // Assuming your color theme is similar
        borderRadius:
            BorderRadius.circular(10), // Matched filter button's border radius
      ),
      child: TextButton(
        onPressed: () {
          // Nagvigate to Login page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal:
                16.0, // Adjust based on your preference, similar to filter buttons
            vertical:
                8.0, // Keeping vertical padding in line with filter buttons
          ),
          foregroundColor: AppColors.white, // Text color
          textStyle: const TextStyle(
            fontSize: 18, // Matched filter button text size for consistency
            fontWeight: FontWeight.bold, // Keep your font weight if needed
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // Ensures the ripple effect respects the border radius
          ),
        ),
        child: const Text('Login or Sign up'),
      ),
    );
  }

  Widget profileExplanationText({required double edgePadding}) {
    // Pad vertically to match the filter button spacing
    return Padding(
      padding: EdgeInsets.symmetric(vertical: edgePadding),
      child: const Text(
        'Manage your SpaceA adventure more easily with an account.',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Widget manageAccountText({required double edgePadding}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: edgePadding),
      child: const Text(
        'Manage your account',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.paynesGray,
        ),
      ),
    );
  }

  Widget buttonsGrouped({required double edgePadding}) {
    return Column(
      children: [
        buttonRowTop(),
        SizedBox(height: edgePadding),
        buttonRowBottom(),
      ],
    );
  }

  Widget buttonRowTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        squareButton(),
        squareButton2(),
      ],
    );
  }

  Widget buttonRowBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        squareButton3(),
        squareButton4(),
      ],
    );
  }

  Widget squareButton() {
    return Material(
      color: Colors.transparent, // Make Material widget transparent
      child: Ink(
        width: tileButtonWidth, // Set width for a square shape
        height: tileButtonHeight, // Set height for a square shape
        decoration: BoxDecoration(
          color: AppColors.white, // Use your desired background color
          borderRadius: BorderRadius.circular(
              10), // Corner radius to match your filter buttons
        ),
        child: InkWell(
          onTap: () {
            // Your button action here
          },
          borderRadius: BorderRadius.circular(
              10), // Match the borderRadius of the Ink decoration
          child: const Center(
            child: Icon(
              Icons.add,
              color: AppColors.greenBlue,
            ), // Replace with your desired icon or text, adjust color as needed
          ),
        ),
      ),
    );
  }

  Widget squareButton2() {
    return Material(
      color: Colors.transparent, // Make Material widget transparent
      child: Ink(
        width: tileButtonWidth, // Set width for a square shape
        height: tileButtonHeight, // Set height for a square shape
        decoration: BoxDecoration(
          color: AppColors.white, // Use your desired background color
          borderRadius: BorderRadius.circular(
              10), // Corner radius to match your filter buttons
        ),
        child: InkWell(
          onTap: () {
            // Your button action here
          },
          borderRadius: BorderRadius.circular(
              10), // Match the borderRadius of the Ink decoration
          child: const Center(
            child: Icon(
              Icons.add,
              color: AppColors.greenBlue,
            ), // Replace with your desired icon or text, adjust color as needed
          ),
        ),
      ),
    );
  }

  Widget squareButton3() {
    return Material(
      color: Colors.transparent, // Make Material widget transparent
      child: Ink(
        width: tileButtonWidth, // Set width for a square shape
        height: tileButtonHeight, // Set height for a square shape
        decoration: BoxDecoration(
          color: AppColors.white, // Use your desired background color
          borderRadius: BorderRadius.circular(
              10), // Corner radius to match your filter buttons
        ),
        child: InkWell(
          onTap: () {
            // Your button action here
          },
          borderRadius: BorderRadius.circular(
              10), // Match the borderRadius of the Ink decoration
          child: const Center(
            child: Icon(
              Icons.add,
              color: AppColors.greenBlue,
            ), // Replace with your desired icon or text, adjust color as needed
          ),
        ),
      ),
    );
  }

  Widget squareButton4() {
    return Material(
      color: Colors.transparent, // Make Material widget transparent
      child: Ink(
        width: tileButtonWidth, // Set width for a square shape
        height: tileButtonHeight, // Set height for a square shape
        decoration: BoxDecoration(
          color: AppColors.white, // Use your desired background color
          borderRadius: BorderRadius.circular(
              10), // Corner radius to match your filter buttons
        ),
        child: InkWell(
          onTap: () {
            // Your button action here
          },
          borderRadius: BorderRadius.circular(
              10), // Match the borderRadius of the Ink decoration
          child: const Center(
            child: Icon(
              Icons.add,
              color: AppColors.greenBlue,
            ), // Replace with your desired icon or text, adjust color as needed
          ),
        ),
      ),
    );
  }

  // Options for each tab
  List<Widget> _widgetOptions() {
    return <Widget>[
      _homeTabContent(), // Home tab content
      const Text('Explore Page',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      _profileTabContent(), // Profile tab content
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToTerminalList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TerminalsList(),
      ),
    );
  }

  double get tileButtonHeight {
    return (1.25) * Provider.of<GlobalProvider>(context).cardHeight;
  }

  double get tileButtonWidth {
    return ((Provider.of<GlobalProvider>(context).cardWidth -
                Provider.of<GlobalProvider>(context).cardPadding) /
            2)
        .floorToDouble();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the GlobalProvider padding values
    final double screenWidth = MediaQuery.of(context).size.width;
    final double shortestSide = MediaQuery.of(context).size.shortestSide;

    // Set the dynamic sizes in the global provider
    Provider.of<GlobalProvider>(context, listen: false)
        .setDynamicSizes(screenWidth, shortestSide);

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
