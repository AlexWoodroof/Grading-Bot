import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; //PDF manipulation package
import 'package:dart_openai/dart_openai.dart';

class AssessmentAnswersScreen extends StatefulWidget {
  @override
  _AssessmentAnswersScreenState createState() => _AssessmentAnswersScreenState();
}

class _AssessmentAnswersScreenState extends State<AssessmentAnswersScreen> {
  late CollectionReference assessmentAnswersCollection;
  final TextEditingController assessmentAnswersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    assessmentAnswersCollection = FirebaseFirestore.instance.collection('assessmentAnswers');
    loadAssessmentAnswers(); // Load criteria on screen initialization
  }

  // Function to load criteria from Firestore
  void loadAssessmentAnswers() async {
    DocumentSnapshot document = await assessmentAnswersCollection.doc('assessmentAnswersDocument').get();
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    setState(() {
      assessmentAnswersController.text = data?['correctAnswers'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff343541),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Assessment Answers',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.help_outline, color: Colors.white,),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Assessment Grading Standards', style: TextStyle(color: Colors.white),),
                        content: const Text(
                          'Explore:\n'
                          '1. Detailed answers for the Assessment.\n'
                          '   - This is where you input the grading criteria you wish to hold each essay to.\n'
                          '2. Examples illustrating various grading levels.\n'
                          "   - To increase the accuracy of the model, it's a good idea to include 3-5 example essays, along with the grading.",
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
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Card(
            margin: EdgeInsets.all(16.0),
            color: Color(0xFF40414f),
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assessment Answers',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: assessmentAnswersController,
                      maxLines: 18,
                      decoration: InputDecoration(labelText: 'Answers', labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          onPressed: _assessmentAnswersUpload,
                          child: Icon(Icons.upload_file, color: Colors.white),
                          backgroundColor: Color(0xFF19c37d),
                        ),
                        // SizedBox(width: 820.0),
                        Spacer(), // Pushes the save button all the way to the right hand side of the screen.
                        Container(
                          // width: MediaQuery.of(context).size.width * 100, // Adjust the width as needed
                          child: ElevatedButton(
                            onPressed: () {
                              assessmentAnswersCollection.doc('assessmentAnsersCriteria').set({'correctAnswers': assessmentAnswersController.text}).onError(
                                    (e, _) => print("Error updating the answers. Error Code: $e"),
                              );
                            },
                            style: ElevatedButton.styleFrom(),
                            child: Text('Save', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 8.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _assessmentAnswersUpload() async {
    FilePickerResult? filePath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (filePath != null) {
      List<PlatformFile> files = filePath.files;

      loadAssessmentAnswers();

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

        //Old Grading Criteria format can be found in the documents of the firestore.

        String assessmentAnswers = await processPDFText("""Please extract the grading criteria from this document: $fileText and represent it in this format using bullet points next to each sub-category nam (not the criterion themselves, just seperate each criterion with a blank line):
        
          [Assignment Title or Description]
          Total Weight: [Total Percentage/Points]

          [Criterion Name] ([Weight Percentage/Points])

            [Sub-Criterion Name] (Weight %/Points): [Detailed explanation of the criterion]

          [and so forth...]

          Additional Notes or Overall Considerations:
        """);

        

        assessmentAnswersCollection.doc('assessmentAnswersDocument').update({
          'correctAnswers': assessmentAnswers,
        });

        loadAssessmentAnswers();

        // print("Here is the grading criteria: $gradingCriteria");

        await Future.delayed(Duration(seconds: 10));
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
}