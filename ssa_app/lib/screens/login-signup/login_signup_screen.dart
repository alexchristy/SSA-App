import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/providers/global_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginSignUpScreen extends StatelessWidget {
  const LoginSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double edgePadding = Provider.of<GlobalProvider>(context).cardPadding;

    return Scaffold(
      appBar: buildAppBar(context, edgePadding: edgePadding),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildLoginButtons(context),
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context,
      {double edgePadding = 16.0, double halfPadding = 8.0}) {
    double baseAppBarHeight = // 10% of screen height
        (MediaQuery.of(context).size.height * 0.05).floorToDouble() +
            edgePadding;

    // Transparent AppBar with only the back button
    return PreferredSize(
        preferredSize: Size.fromHeight(baseAppBarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            iconSize: 32,
            onPressed: () {
              // Go back to the previous screen
              Navigator.of(context).pop();
            },
          ),
        ));
  }

  Widget _buildLoginButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomLoginButton(
          icon: const Icon(Icons.apple, color: Colors.white, size: 32),
          text: "Continue with Apple",
          color: Colors.black,
          textColor: Colors.white,
          onPressed: () {
            // Handle Apple login logic
          },
        ),
        const SizedBox(height: 10),
        CustomLoginButton(
          icon: SvgPicture.asset("assets/google.svg", width: 32, height: 32),
          text: "Continue with Google",
          color: AppColors.white,
          textColor: Colors.black,
          onPressed: () {
            // Handle Google login logic
          },
        ),
        const SizedBox(height: 10),
        CustomLoginButton(
          icon: const Icon(Icons.link, color: Colors.white, size: 32),
          text: "Continue with Link",
          color: AppColors.paynesGray,
          textColor: Colors.white,
          onPressed: () {
            // Handle Link login logic
          },
        ),
        const SizedBox(height: 10),
        CustomLoginButton(
          icon: const Icon(Icons.email, color: Colors.white, size: 32),
          text: "Continue with Email",
          color: AppColors.paynesGray,
          textColor: Colors.white,
          onPressed: () {
            // Handle Email login logic
          },
        ),
      ],
    );
  }
}

class CustomLoginButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomLoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize:
            const Size(double.infinity, 50), // full width and 50 is the height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0), // Rounded corners
        ),
        backgroundColor: color, // Background color
        foregroundColor: textColor, // Text color
        padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8), // Adjust padding around the label and icon
      ),
      icon: Padding(
        padding: const EdgeInsets.only(
            right: 10), // Right padding to the icon for better alignment
        child: icon,
      ),
      label: Text(
        text,
        style: GoogleFonts.ubuntu(
          textStyle: TextStyle(
            color: textColor,
            fontSize: 16, // Set the font size to 16
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
