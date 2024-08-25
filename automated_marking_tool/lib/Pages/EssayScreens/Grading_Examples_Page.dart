import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Import Syncfusion PDF library
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:automated_marking_tool/Providers/project_provider.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';

class GradingExamplesPage extends StatefulWidget {
  @override
  _GradingExamplesPageState createState() => _GradingExamplesPageState();
}

class _GradingExamplesPageState extends State<GradingExamplesPage> {
  late CollectionReference gradingExamplesCollection;
  final TextEditingController newIdController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newTextController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController essayTextController = TextEditingController();
  bool showAddCard = false;
  bool isEditing = false;
  late Map<String, bool> isEditingMap; // Use a map to maintain edit state for each card

  double cardWidth = 0.8;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userUID = user.uid;ProjectProvider projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      gradingExamplesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('projects')
          .doc(projectProvider.selectedProjectId)
          .collection('gradingExamples');
    }
    isEditingMap = {};
  }

  void _batchExampleGradingUpload() async {
    FilePickerResult? filePath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (filePath != null) {
      List<PlatformFile> files = filePath.files;

      for (var file in files) {
        // Loads an existing PDF document
        PdfDocument document = PdfDocument(inputBytes: file.bytes!);

        // Extracts the text from all the pages
        String fileText = PdfTextExtractor(document).extractText();
        
        // Clean up text: remove excess spaces, newlines, etc.
        fileText = fileText.replaceAll(RegExp(r'\s+'), ' ');

        // Dispose the document
        document.dispose();

        print('File Text: $fileText');
        
        // Do something with the fileText (e.g., store it or process it)#
        await Future.delayed(Duration(seconds: 1));

        // Extracting ID, name, and essay (assuming specific patterns in the response)
        String studentID = await processPDFText("Please find me the student ID from this text $fileText WITHOUT INCLUDING ANY OTHER WORDS, just the student id on its own. No spaces."); // Extract the student ID from aiResponse
        String studentName = await processPDFText("Please find me the student Name from this text $fileText WITHOUT INCLUDING ANY OTHER WORDS, just the student Name on its own. Only the first letter of each name should be capatilised."); // Extract the student name from aiResponse
        String studentEssay = await processPDFText("Please correct any errors in the student essay in its entirety from this text $fileText without the ID or Name"); // Extract the student essay from aiResponse

        // Input extracted data into Firebase
        await gradingExamplesCollection.doc(studentID).set({
          'studentID': studentID,
          'studentName': studentName,
          'essayText': studentEssay,
        });

        print("Here are the Student ID: $studentID, Student Name: $studentName, Student Essay: $studentEssay");

        await Future.delayed(Duration(seconds: 60));
      }
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
      appBar: AppTheme.buildAppBar(context, 'Grading Examples', true, "Grading Essay Repositry", Text(
        'Access and manage all essays for grading!\n\n'
        'Explore:\n'
        '1. View a comprehensive list of available example essays.\n'
        '2. Manage and organize example essays efficiently.\n',
        )),
      body: StreamBuilder<QuerySnapshot>(
        stream: gradingExamplesCollection.snapshots(),
        builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              List<DocumentSnapshot> gradingExamples = snapshot.data!.docs;
              return ListView.builder(
                itemCount: showAddCard ? gradingExamples.length + 1 : gradingExamples.length,
                itemBuilder: (context, index) {
                  if (index == gradingExamples.length && showAddCard) {
                    return _buildNewExampleGradingCard();
                  } else {
                    return _buildGradingExamplesCard(gradingExamples[index]);
                  }
                },
              );
            },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _batchExampleGradingUpload,
            backgroundColor: Color(0xFF19c37d),
            child: Icon(Icons.upload_file, color: Theme.of(context).colorScheme.secondary),
            heroTag: 'uploadButtonHero', // Unique tag for the upload button Hero
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
              heroTag: 'addButtonHero', // Unique tag for the add button Hero
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradingExamplesCard(DocumentSnapshot gradingExamples) {
    TextEditingController essayTextController = TextEditingController(text: gradingExamples['essayText']);
    TextEditingController gradingTextController = TextEditingController(text: gradingExamples['exampleGrading']);
    final String cardIndex = gradingExamples.id;

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
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Text('Essay:', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                        SizedBox(height: 4.0),
                        isEditingMap[cardIndex] == true // Check edit state using document ID
                          ? TextField(
                                controller: essayTextController,
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Example Essay',
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                ),
                              )
                            : Container(
                                child: SingleChildScrollView(
                                  child: Text(
                                    gradingExamples['essayText'],
                                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                      ],
                    ),
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
                                      gradingExamplesCollection.doc(gradingExamples.id).delete().then(
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
              Text('Example Grading:', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              SizedBox(height: 4.0),
              isEditingMap[cardIndex] == true // Check edit state using document ID
                ? TextField(
                    controller: gradingTextController,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Example Grading',
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    ),
                  )
                : Container(
                    child: SingleChildScrollView(
                      child: Text(
                        gradingExamples['exampleGrading'],
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              SizedBox(height: 8.0),
              if (isEditingMap[cardIndex] == true) // Check edit state using document ID
                ElevatedButton(
                  onPressed: () {
                    gradingExamplesCollection.doc(gradingExamples.id).update({
                      'essayText': essayTextController.text,
                      'exampleGrading': gradingTextController.text,
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


  Widget _buildNewExampleGradingCard() {
    final TextEditingController newEssayTextController = TextEditingController();
    final TextEditingController newGradingTextController = TextEditingController();

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
                    'Add New Grading Example',
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
                controller: newEssayTextController,
                decoration: InputDecoration(labelText: 'Example Essay', labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: newGradingTextController,
                decoration: InputDecoration(labelText: 'Example Grading', labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final newEssay = <String, dynamic>{
                        'essayText': newEssayTextController.text,
                        'exampleGrading': newGradingTextController.text,
                      };

                      gradingExamplesCollection.doc(newEssayTextController.text).set(newEssay).onError(
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

