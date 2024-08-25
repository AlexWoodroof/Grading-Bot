import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:automated_marking_tool/Pages/Project_Selection_Page.dart';
import 'package:automated_marking_tool/Pages/AuthenticationScreens/Login_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';

class RegistrationPage extends StatefulWidget {
  final String? emailFromLogin;

  RegistrationPage({this.emailFromLogin});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _emailValidated = false;
  bool _error = false;
  bool _loading = false;
  bool _showPasswordRequirements = false;
  List<String> _errorMessages = [];
  final int minCharacters = 12;
  // FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.emailFromLogin != null) {
      _emailController.text = widget.emailFromLogin!;
    }
    _passwordController.addListener(_handlePasswordInput);
  } // THIS CODE IMPORTS THE EMAIL FROM THE LOGIN SCREEN TO THE REGISTRATION SCREEN

  @override
  void dispose() {
    _passwordController.removeListener(_handlePasswordInput);
    super.dispose();
  }

  void _handlePasswordInput() {
    if (mounted) {
      setState(() {
        _showPasswordRequirements = _passwordController.text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.buildAppBar(context, 'Registration', false,
          "This is the Registration Page", Text("")),
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
                      // constraints: BoxConstraints(
                      //   minWidth: constraints.maxWidth * 0.3 + 0.0, // Width + padding on both sides
                      //   maxWidth: constraints.maxWidth * 0.3 + 120.0, // Width + padding on both sides
                      //   // minHeight: constraints.maxHeight * 0,
                      //   // maxHeight: constraints.maxHeight * 1,
                      // ),
                      // width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // constraints: BoxConstraints(
                      //   minHeight: constraints.maxHeight * 0.2,
                      //   minWidth: constraints.maxWidth * 0.32,
                      // ),
                      child: _buildRegistrationForm());
                },
              ),
            ),
          ),
          AbsorbPointer(
            absorbing:
                _loading, // Prevent user interaction when loading is true, just puts a blanket over the entire screen. If you wanted the opacity to work you could place over the top of the code...
            child: Opacity(
              opacity: _loading ? 0.6 : 1.0, // Adjust opacity when loading
              child: Container(
                  // Existing code...
                  ),
            ),
          ),
          if (_loading) // Show circular progress indicator when loading is true
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context)
                    .colorScheme
                    .secondary), // Set color to white
              ),
            ),
          if (_error) _buildErrorMessage(_errorMessages),
        ],
      ),
    );
  }

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "Create your account",
                style: AppTheme.defaultTitleText(context),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              cursorColor: Theme.of(context).colorScheme.secondary,
              decoration: AppTheme.inputBoxDecoration(context, 'Email', false,
                  _showPassword, _toggleVisibility, ''),
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  if (mounted) {
                    setState(() {
                      _error = true;
                      _errorMessages.insert(
                          0, "Please ensure all fields are filled out");
                    });
                  }
                } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  if (mounted) {
                    setState(() {
                      _error = true;
                      _errorMessages.insert(0, "Please enter a valid Email");
                    });
                  }
                } else {
                  // setState(() {
                  //   _error = false;
                  //   _errorMessage = ""; // Reset the error message if valid
                  // });
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
              ElevatedButton(
                onPressed: () {
                  _validateEmail(_emailController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF19c37d), // Change the color as needed
                ),
                child: Text('Continue',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
            if (_emailValidated)
              TextFormField(
                // focusNode: _passwordFocusNode,
                controller: _passwordController,
                cursorColor: Theme.of(context).colorScheme.secondary,
                decoration: AppTheme.inputBoxDecoration(context, 'Password',
                    true, _showPassword, _toggleVisibility, ''),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                obscureText: !_showPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    if (mounted) {
                      setState(() {
                        _error = true;
                        _errorMessages.insert(0, "Please enter your password");
                      });
                    }
                    // return 'Please enter your password';
                  }
                  return null;
                },
                onEditingComplete: () {
                  if (_emailValidated) {
                    _register();
                  }
                },
              ),
            if (_emailValidated) SizedBox(height: 20.0),
            if (_showPasswordRequirements)
              // Container(
              //   padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //         color: Theme.of(context)
              //             .colorScheme
              //             .secondary), // Adding white border
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Text(
              //       '\nYour password must contain: \n\n'
              //       '  -   Your password must contain at least 12 characters.\n',
              //       style: AppTheme.defaultBodyText(context)),
              // ),
              _passwordRequirements(_passwordController.text),
            if (_showPasswordRequirements) SizedBox(height: 20.0),
            if (_emailValidated)
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF19c37d), // Change the color as needed
                ),
                child: Text('Register',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the registration page
                    // Replace 'RegistrationPage()' with your actual registration page route
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      color: Color(0xFF19c37d),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(List<String> errorMessages) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (_error) {
      return Positioned(
        top:
            -30, // top: screenHeight * 0.1 - Current issue is that it hides behind the transparent app bar
        left: screenWidth * 0.15,
        right: screenWidth * 0.15,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent, // Set background color to transparent
          ),
          child: ListView.separated(
            physics:
                NeverScrollableScrollPhysics(), // Disable scrolling of the ListView
            shrinkWrap: true,
            itemCount: errorMessages.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                  height: 8); // Add a gap of 8 between error messages
            },
            itemBuilder: (context, index) {
              if (index >= errorMessages.length) {
                return Container(); // Return an empty container if index is out of range
              }

              Timer(Duration(seconds: 5), () {
                if (mounted) {
                  setState(() {
                    if (errorMessages.length > index) {
                      errorMessages.removeAt(index);
                      _error = errorMessages.isNotEmpty;
                    }
                  });
                }
              });

              return Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          errorMessages[index],
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
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

  Widget _buildPasswordRequirement(
      String text, bool satisfied, BuildContext context) {
    return Row(
      children: [
        // Display an icon based on whether 'satisfied' is true or false
        satisfied
            ? Icon(
                Icons.done,
                color: Colors.green,
              )
            : Icon(Icons.close, color: Colors.red),
        const SizedBox(width: 8.0),
        // Display the text with the specified TextStyle
        Text(text, style: TextStyle(
              color: satisfied
                  ? Colors.grey
                  : Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.black, // Ternary operation for color
              fontSize: 18, // Fixed font size
              decoration: satisfied
                  ? TextDecoration.lineThrough
                  : TextDecoration.none // Ternary operation for decoration
              ),
        ),
      ],
    );
  }

  Widget _passwordRequirements(String currentPassword) {
    bool satisfysMinCharacters = currentPassword.length >= minCharacters;
    // bool hasOneNumber = currentPassword.contains(RegExp(r'[0-9]'));

    return Container(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).textTheme.bodyMedium!.color!),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPasswordRequirement("Minimum of 12 characters", satisfysMinCharacters, context),
            // _buildPasswordRequirement("Contains a number", hasOneNumber),
          ],
        ));
  }

  void _validateEmail(String value) {
    if (_formKey.currentState!.validate()) {
      if (value.isEmpty) {
        if (mounted) {
          setState(() {
            _error = true;
          });
        }
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        if (mounted) {
          setState(() {
            _error = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _emailValidated = true;
            _error = false; // Reset error state
          });
        }
      }
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_passwordController.text.length < 12) {
          if (mounted) {
            setState(() {
              _error = true;
              _errorMessages.insert(
                  0, "Password should be at least 12 characters.");
            });
          }
          return;
        }

        // You can add more password strength validation here...

        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (_emailValidated && !_error) {
          // Only proceed if email is validated and no error messages
          if (mounted) {
            setState(() {
              _loading = true;
            });
          }
        }

        if (userCredential.user != null) {
          await _createDatabase();

          // if (mounted) {
          //   setState(() {
          //     _loading = false;
          //   });
          // }

          // Navigate to the landing page or any other page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProjectSelectionPage()),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _error = true;
            print("This is the error: $e");
            _errorMessages.insert(0, "Registration failed. Please try again.");
            print("$e");
            _loading = false;
          });
        }
      }
    }
  }

  Future<void> _createDatabase() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final userUID = user.uid;

        final firestore = FirebaseFirestore.instance;
        final userRef = firestore.collection('users').doc(userUID);

        // Set user-specific fields
        await userRef.set({
          'UID': userUID,
          'email': user.email,
          'apiKey': "",
          'darkMode': true, // default is true so auto dark mode...
          // Add other user-specific fields here
        });

        // Create a 'projects' collection for the user
        final projectsRef = userRef.collection('projects');

        // Create 'project1' document with subcollections and fields
        final ExampleProjectRef = projectsRef.doc('Example Project');
        await ExampleProjectRef.set({
          'projectName': 'Example Project',
        });

        // Create subcollections under 'project1'
        await _createSubcollections(ExampleProjectRef);

        // Fetch and add essays data
        await _populateDatabase(firestore, userUID, ExampleProjectRef);

        // // Fetch and add criteria data
        // await _populateDatabase(firestore, userUID, ExampleProjectRef);

        // // Fetch and add grading examples data
        // await _populateDatabase(firestore, userUID, ExampleProjectRef);

        // Successful creation of the database
        print('Database creation successful');
      }
    } catch (e) {
      // Handle any errors occurred during database creation
      print('Error creating database: $e');
    }
  }

  Future<void> _createSubcollections(
      DocumentReference ExampleProjectRef) async {
    final firestore = FirebaseFirestore.instance;
    final usersExampleRef = firestore.collection('usersExample').doc('userUID');

    // Fetch data from examples in usersExample // REMAINS AS project1 here because the usersExample database uses project1 and not ExampleProject
    final essaysExampleDoc = await usersExampleRef
        .collection('projects')
        .doc('project1')
        .collection('essays')
        .doc('example1')
        .get();
    final criteriaExampleDoc = await usersExampleRef
        .collection('projects')
        .doc('project1')
        .collection('criteria')
        .doc('criteria')
        .get();
    final gradingExampleDoc = await usersExampleRef
        .collection('projects')
        .doc('project1')
        .collection('gradingExamples')
        .doc('example1')
        .get();

    // Create subcollections under 'project1' and set the fetched data as the first document
    await ExampleProjectRef.collection('essays')
        .doc('example1')
        .set(essaysExampleDoc.data() ?? {});
    await ExampleProjectRef.collection('criteria')
        .doc('criteria')
        .set(criteriaExampleDoc.data() ?? {});
    await ExampleProjectRef.collection('gradingExamples')
        .doc('example1')
        .set(gradingExampleDoc.data() ?? {});
  }

  Future<void> _populateDatabase(FirebaseFirestore firestore, String userUID,
      DocumentReference ExampleProjectRef) async {
    final usersExampleRef = firestore.collection('usersExample').doc('userUID');

    // Fetch essays data
    final essaysSnapshot = await usersExampleRef
        .collection('projects')
        .doc('project1')
        .collection('essays')
        .get();
    for (var essayDoc in essaysSnapshot.docs) {
      final essayData = essayDoc.data() as Map<String, dynamic>;
      final essayText = essayData['essayText'] ?? '';
      final studentID = essayData['studentID'] ?? '';
      final studentName = essayData['studentName'] ?? '';

      final essayID = essayDoc.id;
      await ExampleProjectRef.collection('essays').doc(essayID).set({
        'essayText': essayText,
        'studentID': studentID,
        'studentName': studentName,
      });
    }

    // Fetch criteria data
    final criteriaSnapshot = await usersExampleRef
        .collection('projects')
        .doc('project1')
        .collection('criteria')
        .get();
    final criteriaData =
        criteriaSnapshot.docs.first.data() as Map<String, dynamic>;
    final criteriaText = criteriaData['criteriaText'] ?? '';

    // Create 'criteria' using the same document ID as in usersExample
    await ExampleProjectRef.collection('criteria').doc('criteria').set({
      'criteriaText': criteriaText,
    });

    // Fetch gradingExamples data
    final gradingExamplesSnapshot = await usersExampleRef
        .collection('projects')
        .doc('project1')
        .collection('gradingExamples')
        .get();
    for (var gradingExampleDoc in gradingExamplesSnapshot.docs) {
      final gradingExampleData =
          gradingExampleDoc.data() as Map<String, dynamic>;
      final essayText = gradingExampleData['essayText'] ?? '';
      final exampleGrading = gradingExampleData['exampleGrading'] ?? '';

      // Use the same document ID as in usersExample
      final exampleID = gradingExampleDoc.id;
      await ExampleProjectRef.collection('gradingExamples').doc(exampleID).set({
        'essayText': essayText,
        'exampleGrading': exampleGrading,
      });
    }
  }
}
