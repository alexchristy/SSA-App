import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/providers/global_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ssa_app/utils/authentication_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ssa_app/widgets/privacy_terms_disclaimer.dart';
import 'package:ssa_app/screens/email-login-signup/email_login_signup_screen.dart';

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
              buildPrivacyTermsDisclaimer(),
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
            icon: const Icon(
              Icons.close,
              color: Colors.black,
              size: 32,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ));
  }

  Widget _informationTopper(BuildContext context, double edgePadding) {
    final headerTextGroup = AutoSizeGroup();
    final bodyTextGroup = AutoSizeGroup();

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
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  "track updates",
                  group: headerTextGroup,
                  maxLines: 1,
                  minFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  "view schedules",
                  group: headerTextGroup,
                  maxLines: 1,
                  minFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  "access anywhere",
                  group: headerTextGroup,
                  maxLines: 1,
                  minFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: edgePadding),
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  "with the app that makes Space-A",
                  group: bodyTextGroup,
                  maxLines: 1,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: edgePadding / 4),
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  "travel a breeze",
                  group: bodyTextGroup,
                  maxLines: 1,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              )
            ],
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
          onPressed: () {},
        ),
        const SizedBox(height: 10),
        CustomLoginButton(
          icon: SvgPicture.asset("assets/google.svg", width: 32, height: 32),
          text: "Continue with Google",
          color: AppColors.white,
          textColor: Colors.black,
          onPressed: () {
            signInWithGoogle();
            Provider.of<GlobalProvider>(context, listen: false)
                .setSignedIn(true);
          },
        ),
        const SizedBox(height: 10),
        CustomLoginButton(
          icon: const Icon(Icons.facebook, color: Colors.white, size: 32),
          text: "Continue with Facebook",
          color: const Color.fromARGB(255, 24, 118, 255),
          textColor: Colors.white,
          onPressed: () {},
        ),
        const SizedBox(height: 10),
        CustomLoginButton(
          icon: const Icon(Icons.email, color: Colors.white, size: 32),
          text: "Continue with Email",
          color: AppColors.greenBlue,
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EmailLoginSignUpScreen(),
              ),
            );
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
