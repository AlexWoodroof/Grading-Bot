// // import 'package:automated_marking_tool/Pages/Test_Screen.dart';
// // import 'package:automated_marking_tool/Pages/Test_Screen.dart';
// import 'package:flutter/material.dart';
// import 'package:automated_marking_tool/Pages/EssayScreens/Essay_Hub_Page.dart';
// import 'package:automated_marking_tool/Pages/AssessmentScreens/Assessment_Marking_Screen.dart';
// import 'package:automated_marking_tool/Pages/Default_Chat_Screen.dart';
// import 'package:automated_marking_tool/Pages/AuthenticationScreens/Login_Screen.dart';
// import 'package:automated_marking_tool/Pages/Settings_Page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:automated_marking_tool/Providers/project_provider.dart';
// import 'package:provider/provider.dart';



// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ProjectSelectionPage(),
//     );
//   }
// }

// class ProjectSelectionPage extends StatefulWidget {
//   @override
//   _ProjectSelectionPageState createState() => _ProjectSelectionPageState();
// }

// class _ProjectSelectionPageState extends State<ProjectSelectionPage> {
//   late CollectionReference projectsCollection;
//   int _currentIndex = 1;
//   late PageController _pageController;
//   User? _user; // To store the current user
//   // double viewportFraction = 0.19;
//   List<Map<String, dynamic>> projects = []; // List to store projects

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(
//       initialPage: _currentIndex,
//       viewportFraction: 0.19, // Change width of main buttons // Makes it so you can see multiple buttons somehow.
//       // viewportFraction: MediaQuery.of(context).size.width * 0.1,
//     )..addListener(_onScroll);
//     // WidgetsBinding.instance!.addPostFrameCallback((_) {
//     //   // Access the screen width using a Builder widget and its context
//     //   final screenWidth = MediaQuery.of(context).size.width;
//     //   setState(() {
//     //     viewportFraction = screenWidth * 0.1; // Set the viewportFraction based on screen width
//     //     _pageController = PageController(
//     //       initialPage: _currentIndex,
//     //       viewportFraction: viewportFraction,
//     //     )..addListener(_onScroll);
//     //   });
//     // });
//     _checkAuthState();
//     _fetchProjects();
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       String userUID = user.uid;
//       projectsCollection = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userUID)
//           .collection('projects');
//     }

//     ProjectProvider projectProvider = Provider.of<ProjectProvider>(context, listen: false);
//     projectProvider.selectProject(""); // Initialize with an empty project ID
//   }

//   @override
//   void dispose() {
//     // super.dispose();
//     // _pageController.removeListener(_onScroll);
//     // _pageController.dispose();
//     super.dispose();
//   }

//   void _checkAuthState() {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (mounted) {
//         setState(() {
//           _user = user; // Set the current user
//         });
//       }
//     });
//   }

//   void _onScroll() {
//     if (_pageController.page != null) {
//       int newPageIndex = (_pageController.page! + 0.5).toInt();
//       if (newPageIndex != _currentIndex) {
//         if (mounted) {
//           setState(() {
//             _currentIndex = newPageIndex;
//           });
//         }
//       }
//     }
//   }

//   void _scrollToPage(int index) {
//     _pageController.animateToPage(
//       index,
//       duration: Duration(milliseconds: 300), // Change this value in order to speed up carousel scroll time
//       curve: Curves.easeInOut,
//     );
//   }

//   void _navigateToScreen(int index) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => projects[index]['route']),
//     );
//   }

//   void _showProfileInfo(BuildContext context) {
//     if (_user != null) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Profile Information'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildProfileItem('Email', _user!.email ?? 'N/A'),
//                 // Add more profile information here if needed
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Close'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void _fetchProjects() async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       CollectionReference projectsCollection = FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .collection('projects');

//       QuerySnapshot<Map<String, dynamic>> querySnapshot =
//           await projectsCollection.get() as QuerySnapshot<Map<String, dynamic>>;

//       setState(() {
//         projects = querySnapshot.docs
//             .map((doc) => {
//                   'projectID': doc.id,
//                   'projectName': doc['projectName'] ?? 'N/A', // handle null or missing 'projectName'
//                 })
//             .toList();
//       });
//       print(projects);
//     }
//   }

//   void _addProject() {
//     // Use a TextEditingController to get the project name from the user
//     TextEditingController projectNameController = TextEditingController();

//     // Show a dialog with a text field for the user to enter the project name
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Project'),
//           content: TextField(
//             controller: projectNameController,
//             decoration: InputDecoration(labelText: 'Project Name'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 String projectName = projectNameController.text.trim();
//                 if (projectName.isNotEmpty) {
//                   // Call a function to add the project to Firestore
//                   _createProjectDatabase(projectName);
//                   Navigator.of(context).pop(); // Close the dialog
//                 }
//               },
//               child: Text('Create'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _createProjectDatabase(String projectName) {
//   // Use the current user's UID to create a new project in Firestore
//   String userUID = _user!.uid;

//   // Reference to the projects collection for the current user
//   CollectionReference projectsCollection = FirebaseFirestore.instance
//       .collection('users')
//       .doc(userUID)
//       .collection('projects');

//   // Add the new project to Firestore with an auto-generated ID
//   projectsCollection.add({
//     'projectName': projectName,
//     // Add other fields as needed
//   }).then((DocumentReference projectRef) {
//     print('Project added successfully!');

//     // Create the criteria collection with a single document
//     projectRef.collection('criteria').doc('criteria').set({
//       'criteriaText': 'Your criteria here...',
//     }).then((value) {
//       print('Criteria document added successfully!');
//     }).catchError((error) {
//       print('Error adding criteria document: $error');
//     });

//     // Create the essays collection with 3 documents
//     for (int i = 1; i <= 3; i++) {
//       projectRef.collection('essays').doc('example$i').set({
//         'essayText': 'Essay Text Here',
//         'studentID': 'Student ID Here',
//         'studentName': 'Student Name Here',
//       }).then((value) {
//         print('Essay example$i document added successfully!');
//       }).catchError((error) {
//         print('Error adding essay example$i document: $error');
//       });
//     }

//     // Create the gradingExamples collection with a single document
//     projectRef.collection('gradingExamples').doc('exampleGrading').set({
//       'essayText': 'Essay Text Here',
//       'exampleGrading': 'Example Grading here',
//     }).then((value) {
//       print('Grading example document added successfully!');
//     }).catchError((error) {
//       print('Error adding grading example document: $error');
//     });

//     _fetchProjects();

//     // You can perform additional actions after creating collections and documents if needed
//   }).catchError((error) {
//     print('Error adding project: $error');
//     // Handle errors if necessary
//   });
// }


//   void _deleteProject(int index) {
//     if (projects.isNotEmpty && index >= 0 && index < projects.length) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Delete Project'),
//             content: Text('Are you sure you want to delete this project?'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   String _projectID = projects[index]['projectID']; //Either or method for selecting deleted node.
//                   projectsCollection.doc(_projectID).delete().then(
//                     (value) {
//                       print("Project deleted");
//                       Navigator.of(context).pop(); // close the dialog

//                       setState(() {
//                         projects.removeAt(index); //update carousel
//                         // _currentIndex = 0; // Reset index to prevent out-of-bounds error, not required i dont think
//                       });
//                     },
//                     onError: (e) {
//                       print("Error deleting project: $e");
//                     },
//                   );
//                 },
//                 child: Text('Delete'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

  
//   //FIGURING OUT DELETION OF A PROJECT...DOESNT WORK, NEED TO FIGURE OUT HOW TO DELETE AND THEN FIGURE OUT HOW TO POINT EACH PROJECT TO THE GRADING HUB WITH THE CORRECT PROJECT DATA.

//   Widget _buildProfileItem(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.0),
//       child: RichText(
//         text: TextSpan(
//           style: TextStyle(color: Colors.black),
//           children: [
//             TextSpan(
//               text: '$label: ',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             TextSpan(text: value),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double minSide = MediaQuery.of(context).size.shortestSide;
//     // double screenHeight = MediaQuery.of(context).size.height;
//     // double screenWidth = MediaQuery.of(context).size.width;
//     // viewportFraction = MediaQuery.of(context).size.width * 0.19; // Change the fraction here as needed

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         flexibleSpace: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Automated Marking Tool',
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//               IconButton(
//                 icon: Icon(Icons.help_outline, color: Colors.white,),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Welcome to AMT', style: TextStyle(color: Colors.white),),
//                         content: const Text(
//                           'Hi there! This is the landing page for AMT (Automated Marking Tool). '
//                           'From here you can navigate to one of three options currently available:\n\n'
//                           'Chat Screen - This is a direct link to the ChatGPT API. '
//                           'You can communicate with an AI via this chat interface.\n\n'
//                           'Essay Marker - This is the Essay Marker tool. '
//                           'You can use this tool to assess and mark essays automatically or manually.\n\n'
//                           'Assessment Marker - This is the Assessment Marker tool. '
//                           'You can use this tool to perform automated assessments and marking of standardised tests.',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         backgroundColor: Color(0xFF40414f),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('Close', style: TextStyle(color: Colors.white),),
//                           ),

//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//               // SizedBox(width: 48), // Adjust as needed for spacing
//             ],
//           ),
//         ),
//         backgroundColor: Color(0xFF40414f),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10.0),
//             child: _user != null
//                 ? PopupMenuButton(
//                     itemBuilder: (BuildContext context) {
//                       return <PopupMenuEntry>[
//                         // PopupMenuItem(
//                         //   child: ListTile(
//                         //     leading: Icon(Icons.account_circle),
//                         //     title: Text('Profile'),
//                         //     onTap: () {
//                         //       _showProfileInfo(context);
//                         //     },
//                         //   ),
//                         // ),
//                         PopupMenuItem(
//                           child: ListTile(
//                             leading: Icon(Icons.settings),
//                             title: Text('Settings'),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => SettingsPage(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         PopupMenuItem(
//                           child: ListTile(
//                             leading: Icon(Icons.exit_to_app),
//                             title: Text('Logout'),
//                             onTap: () {
//                               FirebaseAuth.instance.signOut();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => LoginPage(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ];
//                     },
//                     child: Row(
//                       children: [
//                         Text(
//                           _user!.email ?? 'User Email',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         Icon(Icons.arrow_drop_down, color: Colors.white),
//                       ],
//                     ),
//                   )
//                 : SizedBox.shrink(), // Hide if user is not logged in
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: Container (
//           color: Color(0xff343541),
//           // Add your side menu items here
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               DrawerHeader(
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                       'Automated Marking Tool',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF40414f),
//                 ),
//               ),
//               ListTile(
//                 title: Text('Chat Screen', style: TextStyle(color: Colors.white),),
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => ChatScreen(),
//                     ),
//                   );
//                 },
//               ),
//               ListTile(
//                 title: Text('Essay Marking Tool', style: TextStyle(color: Colors.white),),
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => EssayHubPage(),
//                     ),
//                   );
//                 },
//               ),
//               ListTile(
//                 title: Text('Assessment Marking Tool',style: TextStyle(color: Colors.white),),
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => AssessmentMarkingScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   margin: EdgeInsets.symmetric(vertical: 16),
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF19c37d), // Green background color
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.add, color: Colors.white),
//                     onPressed: _addProject,
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Container(
//                   margin: EdgeInsets.symmetric(vertical: 16),
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF19c37d), // Green background color
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.delete, color: Colors.white),
//                     onPressed: () {
//                       _deleteProject(_currentIndex);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(width: 2000),
//             Container(
//               height: minSide * 0.35,
//               child: Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   PageView.builder(
//                     controller: _pageController,
//                     itemCount: projects.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           _scrollToPage(index);
//                           // Handle project selection if needed
//                         },
//                         child: AnimatedContainer(
//                           duration: Duration(milliseconds: 300),
//                           margin: EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(300),
//                               onTap: () {
//                                 _scrollToPage(index);
//                                 if (projects[index]['projectName'] != null) {
//                                   _navigateToScreen(index);
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       child: CircleAvatar(
//                                         radius: _currentIndex == index ? minSide * 0.1 : minSide * 0.06,
//                                         backgroundColor: Colors.transparent,
//                                         child: Icon(
//                                           Icons.folder,
//                                           size: _currentIndex == index ? minSide * 0.1 : minSide * 0.06,
//                                           color: Colors.blue,
//                                         ),
//                                       ),
//                                     ),
//                                     // Assuming 'projectName' is the field with project names
//                                     _currentIndex == index
//                                         ? Transform.translate(
//                                       offset: Offset(0, -(minSide * 0.00)), // Adjust this value to move the text upward for the selected index
//                                       child: Text(
//                                         projects[index]['projectName'],
//                                         style: TextStyle(
//                                           fontSize: minSide * 0.02,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     )
//                                         : Transform.translate(
//                                       offset: Offset(0, -(minSide * 0.00)),
//                                       child: Text(
//                                         projects[index]['projectName'],
//                                         style: TextStyle(
//                                           fontSize: minSide * 0.014,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Visibility(
//                   visible: _currentIndex > 0,
//                   child: InkWell(
//                     onTap: () {
//                       _scrollToPage(_currentIndex - 1);
//                     },
//                     borderRadius: BorderRadius.circular(20),
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       child: Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: _currentIndex < projects.length - 1,
//                   child: InkWell(
//                     onTap: () {
//                       _scrollToPage(_currentIndex + 1);
//                     },
//                     borderRadius: BorderRadius.circular(20),
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       child: Icon(
//                         Icons.arrow_forward,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 projects.length,
//                 (index) => Container(
//                   margin: EdgeInsets.symmetric(horizontal: 4.0),
//                   width: 8.0,
//                   height: 8.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: _currentIndex == index ? Colors.blue : Colors.grey,
//                   ),
//                 ),
//               ),
//              ),
//           ],
//         ),
//       ),
//       backgroundColor: Color(0xff343541),
//     );
//   }
// }