import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildPrivacyTermsDisclaimer() {
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
            fontWeight: FontWeight.bold,
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
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Open the "Privacy Policy" link
            },
        ),
        // Period at the end of the sentence
        const TextSpan(text: "."),
      ],
    ),
  );
}
