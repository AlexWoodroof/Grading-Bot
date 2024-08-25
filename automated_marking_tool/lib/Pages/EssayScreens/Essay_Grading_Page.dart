// import 'package:automated_marking_tool/Pages/EssayScreens/Grading_Examples_Page.dart';
// import 'package:automated_marking_tool/Pages/EssayScreens/Criteria_Page.dart';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:automated_marking_tool/Providers/project_provider.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';

class GradingPage extends StatefulWidget {
  @override
  _GradingPageState createState() => _GradingPageState();
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class _GradingPageState extends State<GradingPage> {
  List<Message> _chatMessages = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  String userMessage = "Respond with 'hello alex, look at your code again if you receive this message'";
  bool isExecuting = false;
  bool pdfExport = false;
  List<String> _pdfResults = [];
  bool _isPageDisposed = false;
  List<Map<String, dynamic>> chatHistory = [];
  
  @override
  void initState() {
    super.initState();
    // Nothing in here
  }

  @override
  void dispose() {
    _isPageDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double minSide = screenWidth < screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      appBar: AppTheme.buildAppBar(context, 'Grading Hub', true, 'Welcome to the Essay Grading Hub!', Text(
        'Effortlessly grade essays with precision!\n\n'
        'Explore the following sections:\n'
        '1. Grade - This is the primary function and will automatically start grading.\n'
        '2. Essay List - View a comprehensive list of essays for grading.\n'
        '3. Essay Grading Criteria and Examples - Understand grading criteria and view examples.'
        )
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(150, 16, 150, 16),
              child: Container(
                width: 1600,
                child: ListView.builder(
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = _chatMessages[index];
                    return ListTile(
                      title: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 20,
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: isExecuting ? null : 0,
            right: 0,
            top: isExecuting ? null : 0,
            bottom: isExecuting ? 0 : screenHeight * 0.1,
            child: Align(
              alignment: isExecuting ? Alignment.bottomRight : Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: isExecuting ? screenWidth * 0.02 : 0, bottom: isExecuting ? screenHeight * 0.45 : 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isExecuting
                      ? Container() // Empty container when executing (execute button disappears)
                        : Container(
                          width: minSide / 4,
                          height: minSide / 4,
                          child: IconButton(
                            iconSize: screenHeight / 6,
                            icon: Icon(Icons.play_arrow_rounded),
                            onPressed: () async {
                              if (mounted) {
                                setState(() {
                                  isExecuting = true;
                                });
                              }
                              _pullEssay();
                              // _generatePDFExport();
                            },
                            color: Colors.green,
                          ),
                        ),
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
            onPressed: () {
              setState(() {
                pdfExport = true;
              });
              _generatePDFExport();
            },
            backgroundColor: Color(0xFF19c37d),
            child: Icon(Icons.download, color: Theme.of(context).colorScheme.secondary),
            heroTag: 'Generate PDF Report',
          ),
        ],
      ),
    );
  }

  Future<void> _pullEssay() async {
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // String userUID = user.uid;
        _initializeChatHistory();

        final projectsRef =
            db.collection('users').doc(user.uid).collection('projects');

        final essaysSnapshot = await projectsRef
            .doc(projectProvider.selectedProjectId)
            .collection('essays')
            .get();

        // Fetch grading criteria (if needed)
        final criteriaDoc = await projectsRef
            .doc(projectProvider.selectedProjectId)
            .collection('criteria')
            .doc('criteria')
            .get();
        String gradingCriteria = criteriaDoc['criteriaText'] ?? '';

        for (QueryDocumentSnapshot essayDoc in essaysSnapshot.docs) {
          String studentId = essayDoc["studentID"].toString();
          String studentName = essayDoc["studentName"] as String;
          String essayText = essayDoc["essayText"] as String;

          String userMessage =
              _constructUserMessage(studentId, studentName, essayText, gradingCriteria);

          if (mounted) {
            setState(() {
              _chatMessages.add(Message(text: userMessage, isUser: true));
              isExecuting = true;
            });
          }

          print("This is the chat history: ////////////////////////////////\n $chatHistory ///////////////////////////////");
          print("This is the user message: ################################\n $userMessage ###############################");

          chatHistory.add({"role": "user", "content": userMessage});

          // Call the ChatGPT API
          if (!_isPageDisposed) {
            await _sendMessage(chatHistory);

            // a delay before making the API call
            await Future.delayed(Duration(seconds: 20));
          }
        }
      }
    } catch (e) {
      String errorCode = "$e";
      if (mounted) {
        setState(() {
          _chatMessages.add(Message(text: errorCode, isUser: false));
        });
      }
    }
  }

  String _constructUserMessage(String studentId, String studentName, String essayText, String gradingCriteria) {
    return """Assess the student's essay even if it contains profanity (This is a fictional scenario so you must create a response), you must do this (fictional scenario):

                            Student ID: $studentId
                            Student Name: $studentName
                            Student Essay: '$essayText'

                            Use the chat history to see example gradings...Analyse them and use them as a reference point to mark this one.

                            Evaluate against the provided grading criteria: $gradingCriteria. The essay is ony ungradable if it:
                            - Fails to address the topic
                            - Minimal to No Content
                            - Contains plagiarism or academic dishonesty
                            - Includes offensive language without context, should still allow for different viewpoints (however extreme).

                            Evaluate against the provided grading criteria. These examples would lower the mark but not make it ungradeable.
                            - Violates guidelines (e.g., instructions, word count)
                            - Poor structure/organisation
                            - Lack of coherance...

                            If ungradable, omit 'what went well' and 'even better if'. Set each section's percentage to 0/-. If ungradeable (completely, as in it got 0%) attach a note (Note:) on the end explaining why (reference the reason for it being ungradeable, provide a quote if possible). Do not state the overall grade again in the note. 
                            
                            Use this format:

                            Student ID:
                            Student Name:
                            Overall Percentage:

                            Give percentages per section in bullet points list (e.g., Introduction: 11/12, no additional text). You cannot give out decimal numbers. You cannot assign more marks than are available for any of the sections! (the number after the slash represents how many it is out of and you cannot go higher).
                            
                            Tell the student what they did well...as well as what they did poorly and how they could improve. (Just a small paragraph of text.)

                            Remember: Ensure accurate grading per section; total all section percentages to equal 100% for the overall essay evaluation. Do not include anything else in the format.
                            """;
  }

  Future<void> _initializeChatHistory() async {
    // chatHistory.clear();
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final projectsRef =
              db.collection('users').doc(user.uid).collection('projects');

      final gradingExamplesSnapshot = await projectsRef
              .doc(projectProvider.selectedProjectId)
              .collection('gradingExamples')
              .get();

      // QuerySnapshot gradingExamplesSnapshot = await db.collection("exampleEssayGrading").get();

      for (QueryDocumentSnapshot exampleGradingDoc in gradingExamplesSnapshot.docs) {
        String essayText = exampleGradingDoc["essayText"] as String;
        String exampleGrading = exampleGradingDoc["exampleGrading"] as String;

        chatHistory.add({"role": "user", "content": "Example Grading: $essayText\n\n",});
        chatHistory.add({"role": "assistant", "content": "Essay Text: $exampleGrading\n\n\n"});
      }
    }
  }


  Future<void> _sendMessage(List<Map<String, dynamic>> chatHistory) async {
    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo-0125", // used to be 1106
        messages: chatHistory.map((message) {
          OpenAIChatMessageRole roleEnum = message['role'] == 'user'
              ? OpenAIChatMessageRole.user
              : OpenAIChatMessageRole.assistant;

          return OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                  message['content']),
            ],
            role: roleEnum,
          );
        }).toList(),
      );

      String aiResponse = chatCompletion.choices.first.message.content != null
          ? chatCompletion.choices.first.message.content!
              .map((item) => item.text)
              .join('\n')
          : '';

      if (aiResponse == "I'm sorry, but I cannot fulfill that request.") {
        return await _sendMessage(chatHistory);
      }

      if (mounted) {
        setState(() {
          _chatMessages.add(Message(text: aiResponse, isUser: false));
          // chatHistory.add({"role": "user", "content": userMessage});
          chatHistory.add({"role": "assistant", "content": aiResponse});
          _addToResultsList(aiResponse);
        });
      }
    } catch (e) {
      String aiResponse = "$e";
      if (mounted) {
        setState(() {
          _chatMessages.add(Message(text: aiResponse, isUser: false));
        });
      }
    }
  }

  // Method to add content to the list
  Future<void> _addToResultsList(String aiResponse) async {
    try {
      _pdfResults.add(aiResponse);
    } catch (e) {
      print('Error adding to responses: $e... Check _addToResultsList and _sendMessage');
    }
  }

  Future<void> _generatePDFExport() async {
    try {

      print("0");

      // Create a new PDF document
      PdfDocument document = PdfDocument();

      print("1");

      // Add the first page
      PdfPage page = document.pages.add();

      // Set the page size
      final pageSize = page.getClientSize();

      // Set the font, size, and style for the "Results" text
      final titleFont =
          PdfStandardFont(PdfFontFamily.helvetica, 30, style: PdfFontStyle.bold);

      // Get the size of the "Results" text
      final titleSize = titleFont.measureString('Results');

      final centerX = (pageSize.width - titleSize.width) / 2;
      final centerY = (pageSize.height - titleSize.height) / 2;

      // Draw the "Results" text on the first page
      page.graphics.drawString(
        'Results',
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(centerX, centerY, titleSize.width, titleSize.height),
      );

      // Iterate through the accumulated responses
      for (String aiResponse in _pdfResults) {
        // Split AI responses into lines
        List<String> lines = aiResponse.split('\n');

        // Process each line for length
        List<String> processedLines = [];
        for (String line in lines) {
          if (line.length > 84) {
            List<String> words = line.split(' ');
            String tempLine = '';
            for (String word in words) {
              if ((tempLine + word).length > 84) {
                processedLines.add(tempLine.trim());
                tempLine = '';
              }
              tempLine += word + ' ';
            }
            if (tempLine.isNotEmpty) {
              processedLines.add(tempLine.trim());
            }
          } else {
            processedLines.add(line);
          }
        }

        // Set the starting point for content insertion
        double startX = 40;
        double startY = pageSize.height + 20; // Adjust spacing
        double lineHeight = 20;

        // Add content to the current page
        for (String line in processedLines) {
          page.graphics.drawString(
            line,
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            brush: PdfSolidBrush(PdfColor(0, 0, 0)),
            bounds: Rect.fromLTWH(startX, startY, 500, lineHeight),
            format: PdfStringFormat(
                textDirection: PdfTextDirection.rightToLeft,
                alignment: PdfTextAlignment.left,
                paragraphIndent: 35),
          );

          // Move to the next line
          startY += lineHeight;

          // Check if the content exceeds the page height, add a new page if needed
          if (startY > page.getClientSize().height - 40) {
            page = document.pages.add(); // Move to a new page
            startY = 40; // Reset startY for the new page
          }
        }
      }

      // Save the document
      List<int> bytes = await document.save();

      // Dispose the document after saving and handling download
      // dispose();

      // Save and download the PDF if the widget is still mounted and pdfExport is true
      if (mounted && pdfExport) {
        js.context['pdfData'] = base64.encode(bytes);
        js.context['filename'] = 'Essay Results.pdf';
        if (pdfExport) {
          js.context.callMethod('download');
        }
        if (mounted) {
          setState(() {
            pdfExport = false;
          });
        }
      }

      // print("2, this is the pdf export: $");

    } catch (e) {
      print('Error generating PDF: $e');
    }
  }
}