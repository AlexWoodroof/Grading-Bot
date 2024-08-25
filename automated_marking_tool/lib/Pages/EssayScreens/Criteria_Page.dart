import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:automated_marking_tool/Providers/project_provider.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';


// TO DO LIST
// Ideally, edit button would exist seperately from the save button (which would only appear when isEditing = true). Edit icon would be on the same level as the title
// Upload button would be an icon

class CriteriaPage extends StatefulWidget {
  @override
  _CriteriaPageState createState() => _CriteriaPageState();
}

class _CriteriaPageState extends State<CriteriaPage> {
  late CollectionReference gradingCriteriaCollection;
  final TextEditingController criteriaController = TextEditingController();
  late String userUID;
  bool isEditing = false;
  bool showFullText = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userUID = user?.uid ?? '';
    // _checkAuthState();

    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context, listen: false);

    gradingCriteriaCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('projects')
        .doc(projectProvider.selectedProjectId)
        .collection('criteria');
    loadCriteria();
  }

  // void _checkAuthState() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (mounted) {
  //       setState(() {
  //         _user = user; // Set the current user
  //       });
  //     }
  //   });
  // }

  void loadCriteria() async {
    DocumentSnapshot criteriaDocument =
        await gradingCriteriaCollection.doc('criteria').get();
    Map<String, dynamic>? criteriaData =
        criteriaDocument.data() as Map<String, dynamic>?;

    setState(() {
      criteriaController.text = criteriaData?['criteriaText'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.buildAppBar(context, 'Essay Grading Standards', true, "Essay Grading Standards", Text(
        'Help us understand your essay criteria!\n\n'
        'Explore:\n'
        '1. Detailed grading criteria for essays.\n'
        '   - This is where you input the grading criteria you wish to hold each essay to.\n',
        )
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _buildCriteriaBox(),
    );
  }

  Widget _buildCriteriaBox() {  
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                  Row(
                    children: [
                      Text(
                        'Grading Criteria:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.0),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.upload_file, color: Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      _criteriaUpload();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      setState(() {
                        if (!isEditing) {
                          // Enable editing
                        } else {
                          // Save changes
                          // Update Firestore with changes
                          // Update Firestore using nameController.text and textController.text
                        }
                        isEditing = !isEditing;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Container(
                height: MediaQuery.of(context).size.height - 250, // Adjust height based on content
                width: MediaQuery.of(context).size.width,
                child: isEditing
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: criteriaController,
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            maxLines: null, // Set the maximum lines for editing
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary), // Set border color here
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary), // Set border color here
                              ),
                              hintText: 'GradingCriteria',
                              hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: () {
                                gradingCriteriaCollection.doc("criteria").update({
                                  'criteriaText': criteriaController.text,
                                });
                                setState(() {
                                  isEditing = false;
                                });
                              },
                              child: Text('Save', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF19c37d)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showFullText = !showFullText;
                              });
                            },
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        criteriaController.text,
                                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                        maxLines: showFullText ? 1000 : 20,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (criteriaController.text.split('').length > 1139)
                                        if (!showFullText)
                                          Text(
                                            'See more...',
                                            style: TextStyle(color: Color(0xFF19c37d)),
                                          ),
                                      if (criteriaController.text.split('').length > 1139)
                                        if (showFullText)
                                          Text(
                                            'See less...',
                                            style: TextStyle(color: Color(0xFF19c37d)),
                                          ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveGradingCriteria() {
    gradingCriteriaCollection
        .doc('criteria')
        .set({'criteriaText': criteriaController.text}).onError((e, _) =>
            print("Error updating grading criteria document: $e"));
  }

  void _criteriaUpload() async {
    FilePickerResult? filePath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (filePath != null) {
      List<PlatformFile> files = filePath.files;

      // loadCriteria();

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

        String gradingCriteria = await processPDFText("""Please extract the grading criteria from this document: $fileText and represent it in this format using bullet points next to each sub-category nam (not the criterion themselves, just seperate each criterion with a blank line):
        
          [Assignment Title or Description]
          Total Weight: [Total Percentage/Points]

          [Criterion Name] ([Weight Percentage/Points])

            [Sub-Criterion Name] (Weight %/Points): [Detailed explanation of the criterion]

          [and so forth...]

          Additional Notes or Overall Considerations:
        """);

        

        gradingCriteriaCollection.doc('criteria').update({
          'criteriaText': gradingCriteria,
        });

        loadCriteria();

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
