import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final _isAPIAltered = false;
  // bool _showEmailMessage = false;
  User? _user; // To store the current user
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _userVerified = false;
  String _originalEmail = '';
  bool _isEmailAltered = false;
  bool _showPasswordMessage = false;
  // String _originalApiKey = 'sk-proj-iq5yFX5XczBPlOzBqI7ZT3BlbkFJ5FmtsrG135dZew5evWb9'; This shouldn't be required...But if it's not working just uncomment this line.

  @override
  void initState() {
    super.initState();
    _fetchUserAndApiKey();
    _emailController.addListener(_handlePasswordInput);
    _newPasswordController.addListener(_handlePasswordInput);
  }

  @override
  void dispose() {
    _emailController.removeListener(_handlePasswordInput);
    _newPasswordController.removeListener(_handlePasswordInput);
    super.dispose();
  }

  Future<void> _checkAuthState() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _user = user; // Set the current user
          print("User Email: ${_user!.email}");
        });
      }
    });
  }

  void _toggleCurrentPasswordVisibility() {
    if (mounted) {
      setState(() {
        _showCurrentPassword = !_showCurrentPassword;
      });
    }
  }

  void _toggleNewPasswordVisibility() {
    if (mounted) {
      setState(() {
        _showNewPassword = !_showNewPassword;
      });
    }
  }

  Future<void> _fetchEmail() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Retrieve email from Firestore
      final documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (documentSnapshot.exists) {
        if (mounted) {
          setState(() {
            _emailController.text = documentSnapshot['email'] ?? '';
            _originalEmail = documentSnapshot['email'] ?? '';
          });
        }
      }
    }
  }

  Future<void> _fetchApiKey() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Retrieve API Key from Firestore
      final documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (documentSnapshot.exists) {
        if (mounted) {
          setState(() {
            _apiKeyController.text = documentSnapshot['apiKey'] ?? '';
            // _originalApiKey = documentSnapshot['apiKey'] ?? '';
          });
        }
      }
    }
  }

  Future<void> _reauthenticateUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the user's current password (you may need to implement a way to retrieve this securely)
      String currentPassword = _currentPasswordController.text;

      // Create a credential with the user's email and password
      AuthCredential credential =
          EmailAuthProvider.credential(email: user.email!, password: currentPassword);

      // Reauthenticate the user with the credential
      try {
        await user.reauthenticateWithCredential(credential);
        print("Reauthentication successful");
        _userVerified = true;
      } catch (error) {
        // Handle reauthentication failure
        print("Reauthentication failed: $error");
        // You can show an error message or take appropriate action
      }
    }
  }

  Future<void> _saveChanges() async {

    await _reauthenticateUser(); // Reauthenticate the user before making changes

    if (_userVerified) {
      print("User has been verified");
      await _saveEmail();
      await _saveApiKey();
      await _passwordReset();
      _userVerified = false;

      // Show success message for email change
      if (_isEmailAltered) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background, // Set background color
              title: Text(
                'Action Required',
                style: AppTheme.defaultBodyText(context), // Set title style
              ),
              content: Text(
                'Please verify your new email to verify this change.',
                style: AppTheme.defaultBodyText(context), // Set content style
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: AppTheme.defaultBodyText(context), // Set button style
                  ),
                ),
              ],
            );
          },
        );
      }

      if (_newPasswordController.text.isNotEmpty) {
        print("snackbar execution");
        SnackBar(
          content: Text('Password Change Successful'),
          duration: Duration(seconds: 2), // You can adjust the duration
        );
      }

      _newPasswordController.clear();
      _currentPasswordController.clear();
    }
  }

  Future<void> _saveEmail() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String newEmail = _emailController.text;//.trim();
      String currentEmail = user.email ?? '';

      try {
        // Update the user's email in Firebase Authentication
        await user.verifyBeforeUpdateEmail(newEmail);
        print("Email update requested, please verify on the provided email");

        // Listen for changes in authentication state
        print("User Account: $user");// - Verified User: ${user.emailVerified}");
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
          if (user != null) {// && user.emailVerified) { // Need to implement email verification upon registration
            // User's email has been verified, update email in Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'email': newEmail});
            print("Email in Firestore updated successfully");

            // Log the email change under the user's document
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('emailChangeLog')
                .add({
              'timestamp': FieldValue.serverTimestamp(),
              'previous_email': currentEmail,
              'new_email': newEmail,
            });
          }
        });
      } catch (error) {
        // Handle email update failure
        print("Email update failed: $error");
        // You can show an error message or take appropriate action
      }
    }
  }


  Future<void> _saveApiKey() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Save API Key to Firestore only if it has been altered
      if (_isAPIAltered) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'apiKey': _apiKeyController.text});

        // Update the originalApiKey after saving
        // setState(() {
        //   _originalApiKey = _apiKeyController.text;
        // });
      }
    }
  }

  Future<void> _passwordReset() async {
    await _reauthenticateUser(); // Reauthenticate the user before changing the password

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the new password from the new password controller
      String newPassword = _newPasswordController.text;

      // Change the user's password
      try {
        await user.updatePassword(newPassword);
      } catch (error) {
        // Handle password change failure
        print("Password change failed: $error");
        // You can show an error message or take appropriate action
      }
    }
  }

  Future<void> _fetchUserAndApiKey() async {
    await _checkAuthState();
    await _fetchEmail();
    await _fetchApiKey();
  }

  // void _handleEmailInput() {
  //   if (mounted) {
  //     setState(() {
  //       _showEmailMessage = _emailController.text.isNotEmpty;
  //     });
  //   }
  // }

  void _handlePasswordInput() {
    if (mounted) {
      setState(() {
        _showPasswordMessage = _newPasswordController.text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppTheme.buildAppBar(
        context,
        'Settings',
        true,
        "Settings",
        const Text(
          'Effortlessly grade essays with precision!\n\n'
          'Explore the following sections:\n'
          '1. Grade - This is the primary function and will automatically start grading.\n'
          '2. Essay List - View a comprehensive list of essays for grading.\n'
          '3. Essay Grading Criteria and Examples - Understand grading criteria and view examples.',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Container
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: AppTheme.defaultBodyText(context),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    // focusNode: _passwordFocusNode,
                    controller: _emailController,
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {
                          _isEmailAltered = value != _originalEmail;
                        });
                      }
                    },
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    decoration: AppTheme.inputBoxDecoration(context, '', false, _showCurrentPassword, _toggleCurrentPasswordVisibility, 'Enter your API key'),
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if (mounted) {
                          setState(() {
                            // _error = true;
                            // _errorMessages.insert(0, "Please enter your password");
                          });
                        }
                        // return 'Please enter your password';
                      }
                      return null;
                    },
                    // onEditingComplete: () {
                    //   if (_emailValidated) {
                    //     _register();
                    //   }
                    // },
                  ),
                  if (_isEmailAltered) SizedBox(height: 16),
                  if (_isEmailAltered)
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.error),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center( // Wrap the Text widget with Center
                        child: Text(
                          '\n **Caution** \n\n'
                          '  Ensure Correct Email Entry! Incorrect information may lead to loss of account access. Verify your email carefully.\n',
                          style: AppTheme.defaultBodyText(context),
                          textAlign: TextAlign.center, // Align the text to the center
                        ),
                      ),
                    ),

                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Theme.of(context).colorScheme.secondary),
                  //     borderRadius: BorderRadius.circular(8.0),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           child: TextField(
                  //             controller: _emailController,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 _isEmailAltered = value != _originalEmail;
                  //               });
                  //             },
                  //             decoration: AppTheme.inputBoxDecoration(context, '', false, _showNewPassword, _toggleNewPasswordVisibility, 'Enter your email'),
                  //             style: TextStyle(
                  //               color: Theme.of(context).colorScheme.secondary,
                  //             ),
                  //             cursorColor: Theme.of(context).colorScheme.secondary,
                  //           ),
                  //         ),
                  //         // Container(
                  //         //   decoration: BoxDecoration(
                  //         //     color: _isEmailAltered
                  //         //         ? Theme.of(context).colorScheme.tertiary
                  //         //         : Theme.of(context).colorScheme.primary,
                  //         //     borderRadius: BorderRadius.circular(5),
                  //         //   ),
                  //         //   padding: EdgeInsets.all(8),
                  //         //   child: InkWell(
                  //         //     onTap: () {
                  //         //       _saveApiKey();
                  //         //       _isEmailAltered = false;
                  //         //       // Handle save logic here
                  //         //     },
                  //         //     child: Icon(
                  //         //       Icons.save,
                  //         //       color: Theme.of(context).colorScheme.secondary,
                  //         //     ),
                  //         //   ),
                  //         // ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 16), // Space between Email and API Key containers

            // New Password Reset Container
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Password',
                    style: AppTheme.defaultBodyText(context),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    // focusNode: _passwordFocusNode,
                    controller: _newPasswordController,
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    decoration: AppTheme.inputBoxDecoration(context, '', true, _showNewPassword, _toggleNewPasswordVisibility, 'Enter your new password'),
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    obscureText: !_showNewPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if (mounted) {
                          setState(() {
                            // _error = true;
                            // _errorMessages.insert(0, "Please enter your password");
                          });
                        }
                        // return 'Please enter your password';
                      }
                      return null;
                    },
                    // onEditingComplete: () {
                    //   if (_emailValidated) {
                    //     _register();
                    //   }
                    // },
                  ),
                  if (_showPasswordMessage) SizedBox(height: 16),
                  if (_showPasswordMessage)
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.error),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center( // Wrap the Text widget with Center
                        child: Text(
                          '\n **Caution** \n\n'
                          '  Ensure Correct Password Entry! Incorrect information may lead to loss of account access. Verify your new password carefully.\n',
                          style: AppTheme.defaultBodyText(context),
                          textAlign: TextAlign.center, // Align the text to the center
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // API Key Container
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'API Key',
                    style: AppTheme.defaultBodyText(context),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _apiKeyController,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          decoration: AppTheme.inputBoxDecoration(context, '', false, _showCurrentPassword, _toggleCurrentPasswordVisibility, 'Enter your API key'),
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              if (mounted) {
                                setState(() {
                                  // _error = true;
                                  // _errorMessages.insert(0, "Please enter your password");
                                });
                              }
                              // return 'Please enter your password';
                            }
                            return null;
                          },
                          // onEditingComplete: () {
                          //   if (_emailValidated) {
                          //     _register();
                          //   }
                          // },
                        ),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: _isAPIAltered
                      //         ? Theme.of(context).colorScheme.tertiary
                      //         : Theme.of(context).colorScheme.primary,
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   padding: EdgeInsets.all(8),
                      //   child: InkWell(
                      //     onTap: () {
                      //       _saveApiKey();
                      //       _isAPIAltered = false;
                      //       // Handle save logic here
                      //     },
                      //     child: Icon(
                      //       Icons.save,
                      //       color: Theme.of(context).colorScheme.secondary,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),    
            ),        
            SizedBox(height: 16),

            // Division Line
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 1,
              color: Theme.of(context).colorScheme.secondary, // Adjust color as needed
            ),
            SizedBox(height: 8),

            // Current Password Reset Container
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Password',
                    style: AppTheme.defaultBodyText(context),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    // focusNode: _passwordFocusNode,
                    controller: _currentPasswordController,
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    decoration: AppTheme.inputBoxDecoration(context, '', true, _showCurrentPassword, _toggleCurrentPasswordVisibility, 'Enter your current password'),
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    obscureText: !_showCurrentPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if (mounted) {
                          setState(() {
                            // _error = true;
                            // _errorMessages.insert(0, "Please enter your password");
                          });
                        }
                        // return 'Please enter your password';
                      }
                      return null;
                    },
                    // onEditingComplete: () {
                    //   if (_emailValidated) {
                    //     _register();
                    //   }
                    // },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            AppTheme.buildElevatedButton(
              onPressed: () async {
                await _saveChanges();
                _isEmailAltered = false;
              },
              buttonText: 'Save changes',
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}