import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ssa_app/constants/app_colors.dart';
import 'package:ssa_app/providers/global_provider.dart';
import 'package:ssa_app/widgets/privacy_terms_disclaimer.dart';
import 'package:email_validator/email_validator.dart';

class EmailLoginSignUpScreen extends StatefulWidget {
  const EmailLoginSignUpScreen({super.key});

  @override
  _EmailLoginSignUpScreenState createState() => _EmailLoginSignUpScreenState();
}

class _EmailLoginSignUpScreenState extends State<EmailLoginSignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (kDebugMode) {
      print("Attempting to submit form");
    }
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      if (kDebugMode) {
        print("Validated: Email: $email, Password: $password");
      }

      if (EmailValidator.validate(email)) {
        if (kDebugMode) {
          print("Email is valid, proceeding with authentication");
        }
        _authenticateUser(email, password);
      } else {
        if (kDebugMode) {
          print("Invalid email address entered");
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please enter a valid email address.')));
      }
    } else {
      if (kDebugMode) {
        print("Form is not ready or validation failed");
      }
    }
  }

  void _authenticateUser(String email, String password) async {
    try {
      if (isLogin) {
        // Perform login
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (kDebugMode) {
          print('Logged in successfully: ${userCredential.user}');
        }
      } else {
        // Check if currently signed in user is anonymous
        if (_auth.currentUser != null && _auth.currentUser!.isAnonymous) {
          // Create a credential for the new email and password
          AuthCredential credential =
              EmailAuthProvider.credential(email: email, password: password);

          // Link the anonymous account to the email account
          UserCredential userCredential =
              await _auth.currentUser!.linkWithCredential(credential);
          if (kDebugMode) {
            print('Anonymous account linked: ${userCredential.user}');
          }
        } else {
          // No anonymous user to link; proceed with regular registration
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (kDebugMode) {
            print('Registered successfully: ${userCredential.user}');
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    }
  }

  void _handleFirebaseAuthError(FirebaseAuthException e) {
    String errorMessage = 'An unknown error occurred. Please try again.';
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      errorMessage = 'Incorrect email or password.';
    } else if (e.code == 'weak-password') {
      errorMessage = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'An account already exists for that email.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'The email address is not valid.';
    } else if (e.code == 'operation-not-allowed') {
      errorMessage = 'Email and Password accounts are not enabled.';
    } else if (e.code == 'too-many-requests') {
      errorMessage =
          'Too many requests to log into this account have been made. Please try again later.';
    }

    // Display the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage, style: GoogleFonts.ubuntu(fontSize: 16)),
        backgroundColor:
            Colors.red.shade700, // Optional: to enhance error visibility
        duration:
            const Duration(seconds: 3), // Optional: control display duration
      ),
    );

    if (kDebugMode) {
      print('Firebase Auth Error: ${e.code}, Message: $errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    double edgePadding = Provider.of<GlobalProvider>(context).cardPadding;

    return Scaffold(
      appBar: buildAppBar(context, edgePadding: edgePadding),
      backgroundColor: AppColors.ghostWhite,
      body: LayoutBuilder(
        // Using LayoutBuilder to provide constraints based on actual runtime limits
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.all(edgePadding),
                child: Form(
                  key: _formKey,
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
                      SizedBox(height: 3 * edgePadding),
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
        },
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
          controller: _emailController,
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
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade700, width: 1.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            errorStyle: GoogleFonts.ubuntu(
              textStyle: TextStyle(color: Colors.red.shade700, fontSize: 16),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email cannot be empty';
            } else if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email address.';
            }
            return null;
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
          controller: _passwordController,
          style: const TextStyle(color: Colors.black, fontSize: 18),
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
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade700, width: 1.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            errorStyle: GoogleFonts.ubuntu(
              textStyle: TextStyle(color: Colors.red.shade700, fontSize: 16),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password cannot be empty';
            } else if (value.length < 7) {
              return 'Must be at least 7 characters';
            }
            return null;
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
