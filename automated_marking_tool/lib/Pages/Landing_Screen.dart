import 'package:automated_marking_tool/Pages/Project_Selection_Page.dart';
import 'package:flutter/material.dart';
import 'package:automated_marking_tool/Pages/EssayScreens/Essay_Hub_Page.dart';
import 'package:automated_marking_tool/Pages/Default_Chat_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 1;
  late PageController _pageController;
  User? _user; // To store the current user
  // double viewportFraction = 0.19;

  final List<Map<String, dynamic>> screens = [
    {
      'title': 'Essay Marker',
      'icon': Icons.assignment,
      'color': Colors.orange,
      'route': EssayHubPage(),
    },
    {
      'title': 'Chat Screen',
      'icon': Icons.chat,
      'color': Colors.blue,
      'route': ChatScreen(),
    },
    // {
    //   'title': 'Assessment Marker',
    //   'icon': Icons.rate_review,
    //   'color': Colors.green,
    //   'route': AssessmentMarkingScreen(),
    // },
    {
      'title': 'Test Screen',
      'icon': Icons.rate_review,
      'color': Colors.purple,
      'route': ProjectSelectionPage(),
    },
  ];

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
  }

  @override
  void dispose() {
    // super.dispose();
    // _pageController.removeListener(_onScroll);
    // _pageController.dispose();
    super.dispose();
  }

  void _checkAuthState() {
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
      MaterialPageRoute(builder: (context) => screens[index]['route']),
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

  @override
  Widget build(BuildContext context) {
    double minSide = MediaQuery.of(context).size.shortestSide;
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    // viewportFraction = MediaQuery.of(context).size.width * 0.19; // Change the fraction here as needed

    return Scaffold(
      appBar: AppTheme.buildAppBar(context, 'Automated Marking Tool', true, "Welcome to AMT", Text(
        'Hi there! This is the landing page for AMT (Automated Marking Tool). '
        'From here you can navigate to one of three options currently available:\n\n'
        'Chat Screen - This is a direct link to the ChatGPT API. '
        'You can communicate with an AI via this chat interface.\n\n'
        'Essay Marker - This is the Essay Marker tool. '
        'You can use this tool to assess and mark essays automatically or manually.\n\n'
        'Assessment Marker - This is the Assessment Marker tool. '
        'You can use this tool to perform automated assessments and marking of standardised tests.'
        )),
      // AppBar(
      //   automaticallyImplyLeading: true,
      //   iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      //   flexibleSpace: Center(
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           'Automated Marking Tool',
      //           style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.secondary),
      //         ),
      //         IconButton(
      //           icon: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.secondary,),
      //           onPressed: () {
      //             showDialog(
      //               context: context,
      //               builder: (BuildContext context) {
      //                 return AlertDialog(
      //                   title: Text('Welcome to AMT', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
      //                   content: const Text(
      //                     'Hi there! This is the landing page for AMT (Automated Marking Tool). '
      //                     'From here you can navigate to one of three options currently available:\n\n'
      //                     'Chat Screen - This is a direct link to the ChatGPT API. '
      //                     'You can communicate with an AI via this chat interface.\n\n'
      //                     'Essay Marker - This is the Essay Marker tool. '
      //                     'You can use this tool to assess and mark essays automatically or manually.\n\n'
      //                     'Assessment Marker - This is the Assessment Marker tool. '
      //                     'You can use this tool to perform automated assessments and marking of standardised tests.',
      //                     style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      //                   ),
      //                   backgroundColor: Color(0xFF40414f),
      //                   actions: [
      //                     TextButton(
      //                       onPressed: () {
      //                         Navigator.of(context).pop();
      //                       },
      //                       child: Text('Close', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
      //                     ),

      //                   ],
      //                 );
      //               },
      //             );
      //           },
      //         ),
      //         // SizedBox(width: 48), // Adjust as needed for spacing
      //       ],
      //     ),
      //   ),
      //   backgroundColor: Color(0xFF40414f),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 10.0),
      //       child: _user != null
      //           ? PopupMenuButton(
      //               itemBuilder: (BuildContext context) {
      //                 return <PopupMenuEntry>[
      //                   // PopupMenuItem(
      //                   //   child: ListTile(
      //                   //     leading: Icon(Icons.account_circle),
      //                   //     title: Text('Profile'),
      //                   //     onTap: () {
      //                   //       _showProfileInfo(context);
      //                   //     },
      //                   //   ),
      //                   // ),
      //                   PopupMenuItem(
      //                     child: ListTile(
      //                       leading: Icon(Icons.settings),
      //                       title: Text('Settings'),
      //                       onTap: () {
      //                         Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                             builder: (context) => SettingsPage(),
      //                           ),
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                   PopupMenuItem(
      //                     child: ListTile(
      //                       leading: Icon(Icons.exit_to_app),
      //                       title: Text('Logout'),
      //                       onTap: () {
      //                         FirebaseAuth.instance.signOut();
      //                         Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                             builder: (context) => LoginPage(),
      //                           ),
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                 ];
      //               },
      //               child: Row(
      //                 children: [
      //                   Text(
      //                     _user!.email ?? 'User Email',
      //                     style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      //                   ),
      //                   Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.secondary),
      //                 ],
      //               ),
      //             )
      //           : SizedBox.shrink(), // Hide if user is not logged in
      //     ),
      //   ],
      // ),
      // drawer: Drawer(
      //   child: Container (
      //     color: Color(0xff343541),
      //     // Add your side menu items here
      //     child: ListView(
      //       padding: EdgeInsets.zero,
      //       children: [
      //         DrawerHeader(
      //           child: Align(
      //             alignment: Alignment.centerLeft,
      //             child: Text(
      //                 'Automated Marking Tool',
      //                 style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      //               ),
      //             ),
      //           decoration: BoxDecoration(
      //             color: Color(0xFF40414f),
      //           ),
      //         ),
      //         ListTile(
      //           title: Text('Chat Screen', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
      //           onTap: () {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (context) => ChatScreen(),
      //               ),
      //             );
      //           },
      //         ),
      //         ListTile(
      //           title: Text('Essay Marking Tool', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
      //           onTap: () {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (context) => EssayHubPage(),
      //               ),
      //             );
      //           },
      //         ),
      //         ListTile(
      //           title: Text('Assessment Marking Tool',style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
      //           onTap: () {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (context) => AssessmentMarkingScreen(),
      //               ),
      //             );
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.shortestSide * 0.35, // 0.23 COuld this be changed 
              // width: MediaQuery.of(context).size.shortestSide * 0.35,
              // height: MediaQuery.of(context).viewportFraction,
              // width: MediaQuery.of(context).size.width * 1, // 0.23 COuld this be changed
              // constraints: BoxConstraints(minHeight: minSide * 0.3, maxHeight: minSide * 0.3), 
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: screens.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _scrollToPage(index);
                          if (screens[index]['route'] != null) {
                            _navigateToScreen(index);
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(300),
                                onTap: () {
                                  _scrollToPage(index);
                                  if (screens[index]['route'] != null) {
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
                                          // width: 50, // Set a specific width for the icon container
                                          // height: 50, // Set a specific height for the icon container
                                          child: CircleAvatar(
                                            radius: _currentIndex == index ? minSide * 0.1 : minSide * 0.06,
                                            backgroundColor: Colors.transparent,
                                            child: Icon(
                                              screens[index]['icon'],
                                              size: _currentIndex == index ? minSide * 0.1 : minSide * 0.06,
                                              color: screens[index]['color'],
                                            ),
                                          ),
                                        ),
                                        // SizedBox(height: (screenHeight * 0.002)),
                                        // SizedBox(height: (screenHeight * 0.002)),
                                        _currentIndex == index
                                        ? Transform.translate(
                                            offset: Offset(0, -(minSide * 0.00)), // Adjust this value to move the text upward for the selected index
                                            child: Text(
                                              screens[index]['title'],
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
                                              screens[index]['title'],
                                              style: TextStyle(
                                                fontSize: minSide * 0.014,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).colorScheme.secondary,
                                              ),
                                            ),
                                        )
                                      ],
                                    ),
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
                  visible: _currentIndex < screens.length - 1,
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
                screens.length,
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