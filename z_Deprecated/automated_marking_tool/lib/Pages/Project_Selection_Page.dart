import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:automated_marking_tool/Providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:automated_marking_tool/Pages/Landing_Screen.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProjectSelectionPage(),
    );
  }
}

class ProjectSelectionPage extends StatefulWidget {
  @override
  _ProjectSelectionPageState createState() => _ProjectSelectionPageState();
}

class _ProjectSelectionPageState extends State<ProjectSelectionPage> {
  late CollectionReference projectsCollection;
  int _currentIndex = 1;
  late PageController _pageController;
  User? _user; // To store the current user
  // double viewportFraction = 0.19;
  List<Map<String, dynamic>> projects = []; // List to store projects

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.19, // Change width of main buttons // Makes it so you can see multiple buttons somehow.
      // viewportFraction: MediaQuery.of(context).size.width * 0.1,
    )..addListener(_onScroll);
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   // Access the screen width using a Builder widget and its context
    //   final screenWidth = MediaQuery.of(context).size.width;
    //   setState(() {
    //     viewportFraction = screenWidth * 0.1; // Set the viewportFraction based on screen width
    //     _pageController = PageController(
    //       initialPage: _currentIndex,
    //       viewportFraction: viewportFraction,
    //     )..addListener(_onScroll);
    //   });
    // });
    _checkAuthState();
    _fetchProjects();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userUID = user.uid;
      projectsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('projects');
    }

    // ProjectProvider projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    // projectProvider.selectProject("project1"); // Initialize with an empty project ID
  }

  @override
  void dispose() {
    // super.dispose();
    // _pageController.removeListener(_onScroll);
    // _pageController.dispose();
    super.dispose();
  }

  void _checkAuthState() {
  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   if (mounted) {
  //     setState(() {
  //       _user = user; // Set the current user
  //     });

  //     // Defer the execution of _fetchProjects after the frame has been rendered
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _fetchProjects();
  //     });
  //   }
  // });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _user = user; // Set the current user
        });
      }
    });
  }

  void _onScroll() {
    if (_pageController.page != null) {
      int newPageIndex = (_pageController.page! + 0.5).toInt();
      if (newPageIndex != _currentIndex) {
        if (mounted) {
          setState(() {
            _currentIndex = newPageIndex;
          });
        }
      }
    }
  }

  void _scrollToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300), // Change this value in order to speed up carousel scroll time
      curve: Curves.easeInOut,
    );
  }

  void _navigateToScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
  }

  void _showProfileInfo(BuildContext context) {
    if (_user != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile Information'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileItem('Email', _user!.email ?? 'N/A'),
                // Add more profile information here if needed
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  void _fetchProjects() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      CollectionReference projectsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('projects');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await projectsCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      setState(() {
        projects = querySnapshot.docs
            .map((doc) => {
                  'projectID': doc.id,
                  'projectName': doc['projectName'] ?? 'N/A', // handle null or missing 'projectName'
                })
            .toList();
      });
      print(projects);
    }
  }

  void _addProject() {
    // Use a TextEditingController to get the project name from the user
    TextEditingController projectNameController = TextEditingController();

    // Show a dialog with a text field for the user to enter the project name
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Project',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          content: TextField(
            controller: projectNameController,
            decoration: InputDecoration(
              labelText: 'Project Name',
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            cursorColor: Theme.of(context).colorScheme.secondary,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
            TextButton(
              onPressed: () {
                String projectName = projectNameController.text.trim();
                if (projectName.isNotEmpty) {
                  // Call a function to add the project to Firestore
                  _createProjectDatabase(projectName);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Create', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
          ],
        );
      },
    );
  }

  void _createProjectDatabase(String projectName) {
  // Use the current user's UID to create a new project in Firestore
  String userUID = _user!.uid;

  // Reference to the projects collection for the current user
  CollectionReference projectsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userUID)
      .collection('projects');

  // Add the new project to Firestore with an auto-generated ID
  projectsCollection.add({
    'projectName': projectName,
    // Add other fields as needed
  }).then((DocumentReference projectRef) {
    print('Project added successfully!');

    // Create the criteria collection with a single document
    projectRef.collection('criteria').doc('criteria').set({
      'criteriaText': 'Your criteria here...',
    }).then((value) {
      print('Criteria document added successfully!');
    }).catchError((error) {
      print('Error adding criteria document: $error');
    });

    // Create the essays collection with 3 documents
    for (int i = 1; i <= 3; i++) {
      projectRef.collection('essays').doc('example$i').set({
        'essayText': 'Essay Text Here',
        'studentID': 'Student ID Here',
        'studentName': 'Student Name Here',
      }).then((value) {
        print('Essay example$i document added successfully!');
      }).catchError((error) {
        print('Error adding essay example$i document: $error');
      });
    }

    // Create the gradingExamples collection with a single document
    projectRef.collection('gradingExamples').doc('exampleGrading').set({
      'essayText': 'Essay Text Here',
      'exampleGrading': 'Example Grading here',
    }).then((value) {
      print('Grading example document added successfully!');
    }).catchError((error) {
      print('Error adding grading example document: $error');
    });

    _fetchProjects();

    // You can perform additional actions after creating collections and documents if needed
  }).catchError((error) {
    print('Error adding project: $error');
    // Handle errors if necessary
  });
}


  void _deleteProject(int index) {
    if (projects.isNotEmpty && index >= 0 && index < projects.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete Project',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            content: Text(
              'Are you sure you want to delete this project?',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              ),
              TextButton(
                onPressed: () {
                  String _projectID = projects[index]['projectID']; //Either or method for selecting deleted node.
                  projectsCollection.doc(_projectID).delete().then(
                    (value) {
                      print("Project deleted");
                      Navigator.of(context).pop(); // close the dialog

                      setState(() {
                        projects.removeAt(index); // Update carousel
                        print(_currentIndex);
                        if (projects.isNotEmpty) {
                          // If there are still projects in the list
                          if (_currentIndex >= projects.length) {
                            // If the current index is out of bounds, set it to the last index
                            _currentIndex = projects.length - 1;
                          }
                          // No need to modify _currentIndex if it's within bounds
                        } else {
                          // If there are no projects left, reset index to prevent out-of-bounds error
                          _currentIndex = 0;
                        }
                      });
                    },
                    onError: (e) {
                      print("Error deleting project: $e");
                    },
                  );
                },
                child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() {
    TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Feedback', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          content: TextField(
            controller: feedbackController,
            decoration: InputDecoration(
              labelText: 'Your Feedback',
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            cursorColor: Theme.of(context).colorScheme.secondary,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
            TextButton(
              onPressed: () {
                String feedback = feedbackController.text.trim();
                if (feedback.isNotEmpty) {
                  // Call a function to submit feedback to Firestore
                  _submitFeedbackToFirestore(feedback);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Submit', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
          ],
        );
      },
    );
  }

  void _submitFeedbackToFirestore(String feedback) {
    if (_user != null) {
      CollectionReference feedbackCollection = FirebaseFirestore.instance
          .collection('feedback'); // Replace with your actual collection name

      feedbackCollection.add({
        'userId': _user!.uid,
        'feedback': feedback,
      }).then((DocumentReference feedbackRef) {
        print('Feedback submitted successfully!');
      }).catchError((error) {
        print('Error submitting feedback: $error');
        // Handle errors if necessary
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double minSide = MediaQuery.of(context).size.shortestSide;
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    // viewportFraction = MediaQuery.of(context).size.width * 0.19; // Change the fraction here as needed

    return Scaffold(
      appBar: AppTheme.buildAppBar(context, 'Automated Marking Tool - Project Selection', true, 'Project Selection Page', const Text(
        'Welcome to the project selection page! From here, you can manage your projects with the following options:\n\n'
        '- Create Project - Start a new project to begin your work.\n'
        '- Delete Project - Remove a project that is no longer needed.\n'
        '- Access Projects - View and interact with your existing projects.\n\n'
        'Example Project - Explore an example project to understand how to use AMT.',
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF19c37d), // Green background color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
                    onPressed: _addProject,
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF19c37d), // Green background color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      _deleteProject(_currentIndex);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 2000),
            Container(
              height: minSide * 0.35,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _scrollToPage(index);
                          // Handle project selection if needed
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(300),
                              onTap: () {
                                _scrollToPage(index);
                                if (projects[index]['projectName'] != null) {
                                  ProjectProvider projectProvider = Provider.of<ProjectProvider>(context, listen: false);
                                  String _projectID = projects[index]['projectID'];
                                  print("Still in PSP: $_projectID");
                                  projectProvider.selectProject(_projectID); // selectProject is a function in project_provider.dart
                                  _navigateToScreen(index);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: CircleAvatar(
                                        radius: _currentIndex == index ? minSide * 0.1 : minSide * 0.06,
                                        backgroundColor: Colors.transparent,
                                        child: Icon(
                                          Icons.folder,
                                          size: _currentIndex == index ? minSide * 0.1 : minSide * 0.06,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    // Assuming 'projectName' is the field with project names
                                    _currentIndex == index
                                        ? Transform.translate(
                                      offset: Offset(0, -(minSide * 0.00)), // Adjust this value to move the text upward for the selected index
                                      child: Text(
                                        projects[index]['projectName'],
                                        style: TextStyle(
                                          fontSize: minSide * 0.02,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                    )
                                        : Transform.translate(
                                      offset: Offset(0, -(minSide * 0.00)),
                                      child: Text(
                                        projects[index]['projectName'],
                                        style: TextStyle(
                                          fontSize: minSide * 0.014,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: _currentIndex > 0,
                  child: InkWell(
                    onTap: () {
                      _scrollToPage(_currentIndex - 1);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _currentIndex < projects.length - 1,
                  child: InkWell(
                    onTap: () {
                      _scrollToPage(_currentIndex + 1);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                projects.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
             ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}