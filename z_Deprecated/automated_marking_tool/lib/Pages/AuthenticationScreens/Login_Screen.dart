import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:automated_marking_tool/Pages/Project_Selection_Page.dart';
import 'package:automated_marking_tool/Pages/AuthenticationScreens/Registration_Page.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:automated_marking_tool/Theme/ThemeNotifier.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _emailValidated = false;
  bool _error = false;
  List<String> _errorMessages = [];
  // FocusNode _passwordFocusNode = FocusNode();
  Timer? _timer;


  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if it's not null
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Disable the back button navigation
  //   // _disableBackButton();
  // }

  // void _disableBackButton() {
  //   // Add a listener to prevent popping the route
  //   Navigator.of(context).popUntil((route) => false);
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //When false, blocks the current route from being popped
      // onPopInvoked : (didPop) {
      // }, // IF YOU NEED TO HANDLE THE BACK BUTTON BEING PRESSED. NOT NECESSARILY REQUIRED
      child: Scaffold(
      // return Scaffold(
        appBar: AppTheme.buildAppBar(context, 'LOGIN', false, "hello", Text(
                          'Hi there! This is the landing page for AMT (Automated Marking Tool). '
                          'From here you can navigate to one of three options currently available:\n\n'
                          'Chat Screen - This is a direct link to the ChatGPT API. '
                          'You can communicate with an AI via this chat interface.\n\n'
                          'Essay Marker - This is the Essay Marker tool. '
                          'You can use this tool to assess and mark essays automatically or manually.\n\n'
                          'Assessment Marker - This is the Assessment Marker tool. '
                          'You can use this tool to perform automated assessments and marking of standardised tests.'
                          ,)),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Center(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      width: constraints.maxWidth < 500 ? null : 500,
                      // THIS WORKS PERFECTLY ^^^ Keeps the width restricted up to a certain width and then keeps the same width on resizing.
                      // height: constraints.maxHeight < 250 ? null : 250, // This doesn't work, i believe its an issue with browser contraints not flutter.
                      // constraints: BoxConstraints(
                      //   minWidth: constraints.maxWidth * 0.3 + 0.0,
                      //   maxWidth: constraints.maxWidth * 0.3 + 120.0,
                      // ),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: _buildLoginForm(),
                    );
                  },
                ),
              ),
            ),
            if (_error) _buildErrorMessage(_errorMessages),
          ],
        ),
      )
      // }
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "Welcome back",
                style: AppTheme.defaultTitleText(context),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              cursorColor: Theme.of(context).colorScheme.secondary,
              decoration: AppTheme.inputBoxDecoration(context, 'Email', false, _showPassword, _toggleVisibility, ''),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  if (mounted) {
                    setState(() {
                      _error = true;
                      _errorMessages.insert(0, "Please ensure all fields are filled out");
                    });
                  }
                } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  if (mounted) {
                    setState(() {
                      _error = true;
                      _errorMessages.insert(0, "Please enter a valid Email");
                    });
                  }
                }
                return null;
              },
              onEditingComplete: () {
                if (!_emailValidated) {
                  _validateEmail(_emailController.text);
                }
              },
            ),
            SizedBox(height: 20.0),
            if (!_emailValidated)
              AppTheme.buildElevatedButton(
                onPressed: () => _validateEmail(_emailController.text),
                buttonText: 'Continue',
                context: context,
              ),
            if (_emailValidated)
              TextFormField(
                controller: _passwordController,
                cursorColor: Theme.of(context).colorScheme.secondary,
                decoration: AppTheme.inputBoxDecoration(context, 'Password', true, _showPassword, _toggleVisibility, ''),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                obscureText: !_showPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      _error = true;
                      _errorMessages.insert(0, "Please enter your password");
                    });
                  }
                  return null;
                },
                onEditingComplete: () {
                  if (_emailValidated) {
                    _login();
                  }
                },
              ),
            if (_emailValidated) SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_emailValidated)
                  GestureDetector(
                    onTap: () async {
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        try {
                          var user = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
                          if (user.isNotEmpty) {
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                            if (mounted) {
                              setState(() {
                                _error = true;
                                _errorMessages.insert(0, "Password reset email sent to $email real");
                              });
                            }
                          } else {
                            if (mounted) {
                              setState(() {
                                _error = true;
                                _errorMessages.insert(0, "Password reset email sent to $email not real");
                              });
                            }
                          }
                        } catch (e) {
                          print('Error: $e');
                        }
                      } else {
                        if (mounted) {
                          setState(() {
                            _error = true;
                            _errorMessages.insert(0, "Please enter an email");
                          });
                        }
                      }
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF19c37d),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10.0),
            if (_emailValidated)
              AppTheme.buildElevatedButton(
                onPressed: _login,
                buttonText: 'Login',
                context: context,
              ),
            if (_emailValidated) SizedBox(height: 10.0),
            AppTheme.buildElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectSelectionPage(),
                    ),
                  );
                },
                buttonText: 'Bypass',
                context: context,
              ),
            SizedBox(height: 10),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(
                              emailFromLogin: _emailController.text,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color(0xFF19c37d),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(List<String> errorMessages) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (_error) {
      return Positioned(
        top: screenHeight * 0.01,
        left: screenWidth * 0.15,
        right: screenWidth * 0.15,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent, // Set background color to transparent
          ),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(), // Disable scrolling of the ListView
            shrinkWrap: true,
            itemCount: errorMessages.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 8); // Add a gap of 8 between error messages
            },
            itemBuilder: (context, index) {
              if (index >= errorMessages.length) {
                return Container(); // Return an empty container if index is out of range
              }

              _timer = Timer(Duration(seconds: 10), () {
                if (mounted) {
                  setState(() {
                    if (errorMessages.length > index) {
                      errorMessages.removeAt(index);
                      _error = errorMessages.isNotEmpty;
                    }
                  });
                }
              });

              Color messageColor = Colors.red; // Default color for error messages

              // Check for different types of error messages and assign colors accordingly
              if (errorMessages[index].contains('Password reset email sent to')) {
                messageColor = Color(0xFF19c37d); // Change color for successful message
              }

              return Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: messageColor, // Assign color based on message type
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          errorMessages[index],
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            errorMessages.removeAt(index);
                            _error = errorMessages.isNotEmpty;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Container(); // Empty container when error message is hidden
    }
  }

  void _toggleVisibility() {
    if (mounted) {
      setState(() {
        _showPassword = !_showPassword;
      });
    }
  }


  void _validateEmail(String value) {
    if (_formKey.currentState!.validate()) {
      if (value.isEmpty) {
        setState(() {
          _error = true;
        });
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        setState(() {
          _error = true;
        });
      } else {
        setState(() {
          _emailValidated = true;
        });
      }
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          // Fetch theme preference and set the theme
          bool isDarkMode = await _fetchThemePreference(userCredential.user!.uid);
          print("Dark Mode: $isDarkMode");
          _setTheme(isDarkMode, context);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProjectSelectionPage()),
          );
        }
      } catch (e) {
        setState(() {
          _error = true;
          _errorMessages.insert(0, "Please ensure all of your login details are correct.");
        });
      }
    }
  }

  Future<bool> _fetchThemePreference(String userId) async {
    try {
      // Retrieve theme preference from Firestore
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        return documentSnapshot['darkMode'] ?? false;
      }

      // Default to light mode if not specified
      return false;
    } catch (e) {
      print('Error fetching theme preference: $e');
      // Default to light mode in case of error
      return false;
    }
  }

  void _setTheme(bool isDarkMode, BuildContext context) {
    context.read<ThemeNotifier>().setTheme(isDarkMode);
  }

}