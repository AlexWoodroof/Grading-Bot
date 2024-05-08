import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Import Syncfusion PDF library
import 'package:dart_openai/dart_openai.dart';


class AssessmentListScreen extends StatefulWidget {
  @override
  _AssessmentListScreenState createState() => _AssessmentListScreenState();
}

class _AssessmentListScreenState extends State<AssessmentListScreen> {
  late CollectionReference assessmentCollection;
  bool showAddCard = false;
  final TextEditingController newIdController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newAnswersController = TextEditingController();

  double cardWidth = 0.8;

  @override
  void initState() {
    super.initState();
    assessmentCollection = FirebaseFirestore.instance.collection('Assessments');
  }

  void _batchEssayUpload() async {
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
        String studentAnswers = await processPDFText("Please correct any errors in the student essay in its entirety from this text $fileText without the ID or Name"); // Extract the student essay from aiResponse

        // Input extracted data into Firebase
        await FirebaseFirestore.instance.collection('Answers').doc(studentID).set({
          'ID': studentID,
          'Name': studentName,
          'StudentAnswers': studentAnswers,
        });

        print("Here are the Student ID: $studentID, Student Name: $studentName, Student Essay: $studentAnswers");

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
      backgroundColor: Color(0xff343541),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Assessment List',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.help_outline, color: Colors.white,),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Assessment Repositry', style: TextStyle(color: Colors.white),),
                        content: const Text(
                          'Access and manage all Assessements for grading!\n\n'
                          'Explore:\n'
                          '1. View a comprehensive list of available Assessments.\n'
                          '2. Manage and organize essays efficiently.\n',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xFF40414f),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close', style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // SizedBox(width: 48), // Adjust as needed for spacing
            ],
          ),
        ),
        backgroundColor: Color(0xFF40414f),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: assessmentCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Widget> widgets = [];

          for (int index = 0; index < snapshot.data!.docs.length; index++) {
            final assessment = snapshot.data!.docs[index];
            final studentID = assessment.id;
            final studentName = assessment['Name'];
            final studentAnswers = assessment['StudentAnswers'];
            final TextEditingController nameController = TextEditingController(text: studentName);
            final TextEditingController textController = TextEditingController(text: studentAnswers);

            widgets.add(
              Card(
                margin: EdgeInsets.fromLTRB(200, 16, 200, 16),
                color: Color(0xFF40414f),
                elevation: 0,
                child: Container(
                  width: cardWidth,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: $studentID', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 8.0),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white)),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          controller: textController,
                          decoration: InputDecoration(labelText: 'Text', labelStyle: TextStyle(color: Colors.white)),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                assessmentCollection.doc(studentID).update({
                                  'Name': nameController.text,
                                  'Text': textController.text,
                                });
                              },
                              child: Text('Update', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(),
                            ),
                            SizedBox(width: 8.0),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Color(0xFF40414f),
                                      title: Text("Confirm Delete", style: TextStyle(color: Colors.white),),
                                      content: Text("Are you sure you want to delete this essay?", style: TextStyle(color: Colors.white),),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                          child: Text("Cancel", style: TextStyle(color: Color(0xFF19c37d))),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Delete essay from the database
                                            assessmentCollection.doc(studentID).delete().then(
                                              (value) {
                                                print("Document deleted");
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              onError: (e) {
                                                print("Error deleting document $e");
                                              },
                                            );
                                          },
                                          child: Text("Delete", style: TextStyle(color: Color(0xFF19c37d))),
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
                  ),
                ),
              ),
            );
          }

          if (showAddCard) {
            widgets.add(_buildNewEssayCard());
          }

          return ListView(
            children: widgets,
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _batchEssayUpload,
            child: Icon(Icons.upload_file, color: Colors.white),
            backgroundColor: Color(0xFF19c37d),
            heroTag: 'uploadButton', // Unique tag for the first FloatingActionButton
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
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xFF19c37d),
              heroTag: 'addButton', // Unique tag for the second FloatingActionButton
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildNewEssayCard() {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController textController = TextEditingController();

    return Card(
      margin: EdgeInsets.fromLTRB(200, 16, 200, 16),
      color: Color(0xFF40414f),
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
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
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
                decoration: InputDecoration(labelText: 'ID', labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: textController,
                decoration: InputDecoration(labelText: 'Text', labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final newEssay = <String, dynamic>{
                        'ID': idController.text,
                        'Name': nameController.text,
                        'Text': textController.text,
                      };

                      assessmentCollection.doc(idController.text).set(newEssay).onError(
                        (e, _) => print("Error writing document: $e"),
                      );

                      setState(() {
                        showAddCard = false;
                      });
                    },
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(),
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


