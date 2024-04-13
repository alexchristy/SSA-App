import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/providers/global_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssa_app/utils/authentication_utils.dart';

class LoginSignUpScreen extends StatelessWidget {
  const LoginSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double edgePadding = Provider.of<GlobalProvider>(context).cardPadding;

    return Scaffold(
      appBar: buildAppBar(context, edgePadding: edgePadding),
      backgroundColor: AppColors.ghostWhite,
      body: SingleChildScrollView(
        // Wrap the padding in a SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(edgePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _informationTopper(context, edgePadding),
              SizedBox(height: 3 * edgePadding),
              _buildLoginButtons(context),
              SizedBox(height: 2 * edgePadding),
              buildDisclaimer(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize buildAppBar(BuildContext context, {double edgePadding = 16.0}) {
    double baseAppBarHeight =
        (MediaQuery.of(context).size.height * 0.05).floorToDouble() +
            edgePadding;

    return PreferredSize(
        preferredSize: Size.fromHeight(baseAppBarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ));
  }

  Widget _informationTopper(BuildContext context, double edgePadding) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Base font size that scales with the screen width
    double baseFontSize =
        screenWidth * 0.05; // Adjust the multiplier to scale the size

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(
            'assets/c17_frontal_square_windows.svg',
            width: 45,
            height: 45,
            color: AppColors.paynesGray,
          ),
          SizedBox(height: 2 * edgePadding),
          Text(
            "track updates",
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize:
                      baseFontSize * 1.75, // Large text is 1.75x the base size
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          Text(
            "view schedules",
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: baseFontSize * 1.75, // Consistent large text size
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          Text(
            "conveniently mobile",
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: baseFontSize * 1.75, // Consistent large text size
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          SizedBox(height: edgePadding),
          Text(
            "with the app that makes Space-A",
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: baseFontSize, // Small text is the base size
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: edgePadding / 4),
          Text(
            "travel a breeze",
            style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: baseFontSize, // Consistent small text size
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomLoginButton(
          icon: const Icon(Icons.apple, color: Colors.white, size: 32),
          text: "Continue with Apple",
          color: Colors.black,
          textColor: Colors.white,
          onPressed: () {
            signInWithGoogle();
          },
        ),
        const SizedBox(height: 10),
        CustomLoginButton(
          icon: SvgPicture.asset("assets/google.svg", width: 32, height: 32),
          text: "Continue with Google",
          color: AppColors.white,
          textColor: Colors.black,
          onPressed: () {},
        ),
        const SizedBox(height: 10),
        CustomLoginButton(
          icon: const Icon(Icons.link, color: Colors.white, size: 32),
          text: "Continue with Link",
          color: AppColors.paynesGray,
          textColor: Colors.white,
          onPressed: () {},
        ),
        const SizedBox(height: 10),
        CustomLoginButton(
          icon: const Icon(Icons.email, color: Colors.white, size: 32),
          text: "Continue with Email",
          color: AppColors.paynesGray,
          textColor: Colors.white,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildDisclaimer(BuildContext context) {
    // "Terms of Service" and "Privacy Policy" are links iubenda.com
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        children: <TextSpan>[
          const TextSpan(text: "By continuing, you agree to our "),
          TextSpan(
            text: "Terms of Service",
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Open the "Terms of Service" link
              },
          ),
          const TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy",
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Open the "Privacy Policy" link
              },
          ),
        ],
      ),
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
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: icon,
      ),
      label: Text(
        text,
        style: GoogleFonts.ubuntu(
          textStyle: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
