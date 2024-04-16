import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/providers/global_provider.dart';
import 'package:ssa_app/widgets/privacy_terms_disclaimer.dart';

class EmailLoginSignUpScreen extends StatefulWidget {
  const EmailLoginSignUpScreen({super.key});

  @override
  _EmailLoginSignUpScreenState createState() => _EmailLoginSignUpScreenState();
}

class _EmailLoginSignUpScreenState extends State<EmailLoginSignUpScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Implement your login logic here
      print('Email: $_email, Password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    double edgePadding = Provider.of<GlobalProvider>(context).cardPadding;

    return Scaffold(
      appBar: buildAppBar(context, edgePadding: edgePadding),
      backgroundColor: AppColors.ghostWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(edgePadding),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildInformationTopper(),
                SizedBox(height: edgePadding),
                loginSignUpButtonToggle(edgePadding),
                SizedBox(height: edgePadding),
                buildEmailField(edgePadding),
                SizedBox(height: edgePadding),
                buildPasswordField(edgePadding),
                SizedBox(height: 3 * edgePadding),
                buildSubmitButton(edgePadding),
                SizedBox(height: 2 * edgePadding),
                buildActivityModeSwitcherText(),
                SizedBox(height: 2 * edgePadding),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buildPrivacyTermsDisclaimer(),
                ),
              ],
            ),
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
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ));
  }

  Widget buildInformationTopper() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  "SmartSpaceA",
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
                  "confidently travel Space-A",
                  maxLines: 1,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ubuntu(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget loginSignUpButtonToggle(double edgePadding) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0.0),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            backgroundColor: MaterialStateProperty.all<Color>(
              isLogin
                  ? AppColors.paynesGray
                  : Colors.grey[300]!, // Background color based on selection
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              isLogin
                  ? Colors.white
                  : Colors.black, // Text color based on selection
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 20)),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: edgePadding, vertical: 10),
            ),
            animationDuration: Duration.zero, // No animation duration
            minimumSize: MaterialStateProperty.all<Size>(const Size(30, 60)),
          ),
          onPressed: () {
            if (!isLogin) {
              setState(() {
                isLogin = true;
              });
            }
          },
          child: const Text('Login', style: TextStyle(fontSize: 20)),
        ),
        SizedBox(width: edgePadding),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0.0),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            backgroundColor: MaterialStateProperty.all<Color>(
              !isLogin
                  ? AppColors.paynesGray
                  : Colors.grey[300]!, // Background color based on selection
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              !isLogin
                  ? Colors.white
                  : Colors.black, // Text color based on selection
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 20)),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: edgePadding, vertical: 10),
            ),
            animationDuration: Duration.zero,
            minimumSize: MaterialStateProperty.all<Size>(const Size(30, 60)),
          ),
          onPressed: () {
            if (isLogin) {
              setState(() {
                isLogin = false;
              });
            }
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  Widget buildEmailField(double edgePadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email',
            style: TextStyle(
                color: Colors.black, fontSize: 18)), // Descriptor text
        SizedBox(
            height: edgePadding / 2), // Spacing between label and input field
        TextFormField(
          key: const ValueKey('email'),
          style: GoogleFonts.ubuntu(
            textStyle: const TextStyle(color: Colors.black, fontSize: 18),
          ),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email...',
            hintStyle: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.normal), // Light gray hint text
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains('@')) {
              return 'Please enter a valid email address.';
            }
            return null;
          },
          onSaved: (value) {
            _email = value!;
          },
        ),
      ],
    );
  }

  Widget buildPasswordField(double edgePadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password',
            style: GoogleFonts.ubuntu(
              textStyle: const TextStyle(color: Colors.black, fontSize: 18),
            )), // Descriptor text
        SizedBox(
            height: edgePadding / 2), // Spacing between label and input field
        TextFormField(
          style: const TextStyle(color: Colors.black, fontSize: 18),
          key: const ValueKey('password'),
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter your password...',
            hintStyle: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.normal), // Light gray hint text
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 7) {
              return 'Password must be at least 7 characters long.';
            }
            return null;
          },
          onSaved: (value) {
            _password = value!;
          },
        ),
      ],
    );
  }

  Widget buildSubmitButton(double edgePadding) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.paynesGray),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: edgePadding, vertical: 20),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          GoogleFonts.ubuntu(textStyle: const TextStyle(fontSize: 20)),
        ),
        elevation: MaterialStateProperty.all<double>(0.0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: _submit,
      child: Text(isLogin ? 'Login' : 'Sign Up',
          style: GoogleFonts.ubuntu(fontSize: 20)),
    );
  }

  buildActivityModeSwitcherText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account? " : "Already have an account? ",
          style: const TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isLogin = !isLogin;
            });
          },
          child: Text(
            isLogin ? "Sign Up." : "Login.",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
