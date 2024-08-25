import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Import Syncfusion PDF library
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:automated_marking_tool/Providers/project_provider.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';

// TO DO LIST
// WHEN USER UPLOADS BATCH FILES, SHOULD EXECUTE A UPLOAD SEQUENCE ANIMATION THING...

class EssayListPage extends StatefulWidget {
  @override
  _EssayListPageState createState() => _EssayListPageState();
}

class _EssayListPageState extends State<EssayListPage> {
  late CollectionReference essaysCollection;
  // final TextEditingController newIdController = TextEditingController();
  // final TextEditingController newNameController = TextEditingController();
  // final TextEditingController newTextController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController essayTextController = TextEditingController();
  bool showAddCard = false;
  bool isEditing = false;
  late Map<String, bool> isEditingMap; // Use a map to maintain edit state for each card
  late Map<String, bool> showFullTextMap;
  bool _isUploading = false;
  int _numOfFiles = 0;
  int _remainingTime = 0;

  double cardWidth = 0.8;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    if (user != null) {
      String userUID = user.uid;
      essaysCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('projects')
          .doc(projectProvider.selectedProjectId)
          .collection('essays');
    }
    isEditingMap = {};
    showFullTextMap = {};
  }

  void _batchEssayUpload() async {

    FilePickerResult? filePath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (filePath != null) {
      List<PlatformFile> files = filePath.files;

      setState(() {
        _numOfFiles = files.length;
        _remainingTime = files.length - 1;
        _isUploading = true;
      });

      int _counter = 0;

      for (var file in files) {
        _counter += 1;
        // Loads an existing PDF document
        PdfDocument document = PdfDocument(inputBytes: file.bytes!);
        // Extracts the text from all the pages
        String fileText = PdfTextExtractor(document).extractText();
          
        // Clean up text: remove excess spaces, newlines, etc.
        fileText = fileText.replaceAll(RegExp(r'\s+'), ' ');

        // Dispose the document
        document.dispose();

        // print('File Text: $fileText');
          
        // Do something with the fileText (e.g., store it or process it)#
        await Future.delayed(Duration(seconds: 1));

        print("1");

        // Extracting ID, name, and essay (assuming specific patterns in the response)
        String studentID = await processPDFText("Please find me the student ID from this text $fileText WITHOUT INCLUDING ANY OTHER WORDS, just the student id on its own. No spaces."); // Extract the student ID from aiResponse
        String studentName = await processPDFText("Please find me the student Name from this text $fileText WITHOUT INCLUDING ANY OTHER WORDS, just the student Name on its own. Only the first letter of each name should be capatilised."); // Extract the student name from aiResponse
        String studentEssay = await processPDFText("Please correct any errors in the student essay in its entirety from this text $fileText without the ID or Name"); // Extract the student essay from aiResponse
        
        print("2");

        // Input extracted data into Firebase
        await essaysCollection.doc(studentID).set({
          'studentID': studentID,
          'studentName': studentName,
          'essayText': studentEssay,
        });

        print("Here are the Student ID: $studentID, Student Name: $studentName, Student Essay: $studentEssay");

        setState(() {
          _isUploading = false;
          _remainingTime = files.length - (_counter + 1);
          _isUploading = true;
        });

        print("3 $_counter: ${files.length}");

        if (_counter <= files.length - 1) { //So when that the box closes after the last file has been processed...means the user doesnt wait unnecessarily.
          await Future.delayed(Duration(seconds: 60)); //60 second wait timer because i can only query 3 times per minute and i require 3 queries to sort through each pdf for id, name and essay text.
        }
      }

      setState(() {
        _isUploading = false;
      });
      
      // Navigator.of(context).pop(); // Close the uploading dialog

    } else {
      print('No files picked.');
    }
  }

  Future<String> processPDFText(String aiPrompt) async {
    try {
      final userMessageCorrection = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(aiPrompt),
        ],
        role: OpenAIChatMessageRole.user,
      );

      print("yikessss");

      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo-1106",
        messages: [userMessageCorrection],
      );

      String aiResponse = chatCompletion.choices.first.message.content != null
          ? chatCompletion.choices.first.message.content!
              .map((item) => item.text)
              .join('\n')
          : ''; // Set a default value if content is null

      return aiResponse; // Return the extracted AI response
    } catch (e) {
      print("Error processing PDF text: $e");
      return ''; // Return an empty string in case of an error
    }
  }

  @override
Widget build(BuildContext context) {
  cardWidth = MediaQuery.of(context).size.width * 0.8;
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.background,
    appBar: AppTheme.buildAppBar(context, 'Essay Repository', true, "Essay Repository", Text(
      'Access and manage all essays for grading!\n\n'
      'Explore:\n'
      '1. View a comprehensive list of available essays.\n'
      '2. Manage and organize essays efficiently.\n',
      )
    ),
    body: Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: essaysCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<DocumentSnapshot> essays = snapshot.data!.docs;
            return ListView.builder(
              itemCount: showAddCard ? essays.length + 1 : essays.length, // Add 1 for the "Add New Essay" card
              itemBuilder: (context, index) {
                if (index == essays.length) {
                  return _buildNewEssayCard();
                } else {
                  return _buildEssayCard(essays[index]);
                }
              },
            );
          },
        ),
        Positioned(
          bottom: 32.0,
          right: 32.0,
          child: Visibility(
            visible: _isUploading,
            child: Container(
              // color: Color(0xFF19c37d),
              padding: EdgeInsets.fromLTRB(32.0, 32.0, 32, 16),
              decoration: BoxDecoration(
                color: Color(0xFF19c37d),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Uploading $_numOfFiles files. This may take a moment...\nRemaining Time: ${_remainingTime + 1} minutes',
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  // Add any other widgets or messages you want to display
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: _batchEssayUpload,
          backgroundColor: Color(0xFF19c37d),
          child: Icon(Icons.upload_file, color: Theme.of(context).colorScheme.secondary),
          heroTag: 'uploadButtonHero',
        ),
        SizedBox(height: 16),
        AnimatedOpacity(
          opacity: showAddCard ? 0.0 : 1.0,
          duration: Duration(milliseconds: 500),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                showAddCard = !showAddCard;
              });
            },
            backgroundColor: Color(0xFF19c37d),
            child: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
            heroTag: 'addButtonHero',
          ),
        ),
      ],
    ),
  );
}



  Widget _buildEssayCard(DocumentSnapshot essay) {
    TextEditingController nameController = TextEditingController(text: essay['studentName']);
    TextEditingController essayTextController = TextEditingController(text: essay['essayText']);
    final String cardIndex = essay.id;

    return Card(
      margin: EdgeInsets.fromLTRB(100, 16, 100, 16),
      color: Theme.of(context).colorScheme.primary,
      elevation: 0,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID:', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      SizedBox(height: 4.0),
                      Text('${essay['studentID']}', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      SizedBox(height: 8.0),
                      Text('Name:', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      SizedBox(height: 4.0),
                      isEditingMap[cardIndex] == true // Check edit state using document ID
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6, // Limit the width for editing
                            child: TextField(
                              controller: nameController,
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter Name',
                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                          )
                        : Text(essay['studentName'], style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
                        onPressed: () {
                          setState(() {
                            isEditingMap[cardIndex] = !(isEditingMap[cardIndex] ?? false); // Update edit state for this card
                          });
                        },
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary),
                        onPressed: () {
                          // Show confirmation dialog before deletion
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Delete', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                content: Text('Are you sure you want to delete this essay?', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel', style: TextStyle(color: Color(0xFF19c37d))),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      essaysCollection.doc(essay.id).delete().then(
                                        (value) {
                                          print("Document deleted");
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        onError: (e) {
                                          print("Error deleting document $e");
                                        },
                                      );
                                    },
                                    child: Text('Delete', style: TextStyle(color: Color(0xFF19c37d))),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text('Essay:', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              SizedBox(height: 4.0),
              isEditingMap[cardIndex] == true
                ? SizedBox(
                    width: cardWidth * 2,
                    child: TextField(
                      controller: essayTextController,
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Essay',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showFullTextMap[cardIndex] = !(showFullTextMap[cardIndex] ?? false);
                          });
                        },
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final bool showFullText = showFullTextMap[cardIndex] ?? false;

                            final textSpan = TextSpan(
                              text: essay['essayText'],
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            );

                            final textPainter = TextPainter(
                              text: textSpan,
                              maxLines: showFullText ? null : 5,
                              textDirection: TextDirection.ltr,
                            );

                            textPainter.layout(maxWidth: constraints.maxWidth);

                            if (textPainter.didExceedMaxLines && !showFullText) {
                              final visibleText = essay['essayText']
                                  .substring(0, textPainter.getPositionForOffset(Offset(constraints.maxWidth, constraints.maxHeight)).offset);

                              return RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: visibleText,
                                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    ),
                                    TextSpan(
                                      text: ' See more...',
                                      style: TextStyle(color: Color(0xFF19c37d)),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    essay['essayText'],
                                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    maxLines: showFullText ? 100 : 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (showFullText)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showFullTextMap[cardIndex] = false;
                                        });
                                      },
                                      child: Text(
                                        'See less...',
                                        style: TextStyle(color: Color(0xFF19c37d)),
                                      ),
                                    ),
                                ],
                              );
                            }
                      },
                    ),
                  ),
                    ],
                ),
              SizedBox(height: 8.0),
              if (isEditingMap[cardIndex] == true) // Check edit state using document ID
                ElevatedButton(
                  onPressed: () {
                    essaysCollection.doc(essay.id).update({
                      'studentName': nameController.text,
                      'essayText': essayTextController.text,
                    });
                    setState(() {
                      isEditingMap[cardIndex] = !(isEditingMap[cardIndex] ?? false); // Update edit state for this card
                    });
                  },
                  child: Text('Update', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF19c37d)),
                ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildNewEssayCard() {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController textController = TextEditingController();

    return Card(
      margin: EdgeInsets.fromLTRB(200, 16, 200, 16),
      color: Theme.of(context).colorScheme.primary,
      elevation: 0,
      child: Container(
        width: cardWidth,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Essay',
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      setState(() {
                        showAddCard = false;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: 'ID', labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: textController,
                decoration: InputDecoration(labelText: 'Text', labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final newEssay = <String, dynamic>{
                        'studentID': idController.text,
                        'studentName': nameController.text,
                        'essayText': textController.text,
                      };

                      essaysCollection.doc(idController.text).set(newEssay).onError(
                        (e, _) => print("Error writing document: $e"),
                      );

                      setState(() {
                        showAddCard = false;
                      });
                    },
                    child: Text('Add', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF19c37d)),
                  ),
                  SizedBox(width: 8.0),
                  Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

