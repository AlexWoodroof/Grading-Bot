import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Assessment_List_Screen.dart';
import 'Assessment_Answer_Screen.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;

class AssessmentMarkingScreen extends StatefulWidget {
  AssessmentMarkingScreen({Key? key}) : super(key: key);
  
  @override
  _AssessmentMarkingScreenState createState() => _AssessmentMarkingScreenState();
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class _AssessmentMarkingScreenState extends State<AssessmentMarkingScreen> {
  List<Message> _chatMessages = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  String userMessage = "Respond with 'hello alex, look at your code again if you receive this message'";
  bool isExecuting = false;
  bool pdfExport = false;
  List<String> pdfResults = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _pullEssay(); // Calls _pullEssay when the screen loads
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff343541),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Standardised Test Grading',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.help_outline, color: Colors.white,),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Welcome to the Assessment Grading Hub!', style: TextStyle(color: Colors.white),),
                        content: const Text(
                          'Automate your assessment process!\n\n'
                          'Explore:\n'
                          '1. Assessment List - Review and manage all assessments.\n'
                          '2. Assessment Answers - Dive into detailed answers for assessments.\n',
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
                              ? Color(0xFF40414f)
                              : Color(0xff343541),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: Colors.white,
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
                        : ElevatedButton.icon(
                          onPressed: () async {
                            if (mounted) {
                              setState(() {
                                isExecuting = true;
                              });
                            }
                            _pullAssessment();
                            // _generatePDFExport();
                          },
                          icon: Icon(Icons.play_arrow),
                          label: Text('Grade'),
                          style: ElevatedButton.styleFrom(),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AssessmentListScreen()),
                            );
                          },
                          icon: Icon(Icons.edit),
                          label: Text('Assessments'),
                          style: ElevatedButton.styleFrom(),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the assessmentAnswers screen without closing the previous window, thus continues grading...
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AssessmentAnswersScreen()),
                            );
                          },
                          icon: Icon(Icons.assignment),
                          label: Text('Answers'),
                          style: ElevatedButton.styleFrom(),
                        ),
                        SizedBox(height: 16.0),
                        if (isExecuting)
                          ElevatedButton.icon(
                            onPressed: () {
                              // Call a function to download results in PDF format
                              if (mounted) {
                                setState(() {
                                  pdfExport = true;
                                });
                              }
                              _generatePDFExport();
                            },
                            icon: Icon(Icons.download),
                            label: Text('Download'),
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF19c37d)),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pullAssessment() async {
    try {
      QuerySnapshot assessmentSnapshot = await db.collection("Assessments").get();
      DocumentReference assessmentAnswersDocRef = db.collection("assessmentAnswers").doc("assessmentAnswersDocument");
      DocumentSnapshot assessmentAnswersDoc = await assessmentAnswersDocRef.get();
      String assessmentAnswers;

      if (assessmentAnswersDoc.exists) {
        assessmentAnswers = assessmentAnswersDoc["correctAnswers"] as String;
      } else {
        if (mounted) {
          setState(() {
            _chatMessages.add(Message(text: "Assessment Answers does not exist...", isUser: false));
          });
        }
        return;
      }

      for (QueryDocumentSnapshot assessmentDoc in assessmentSnapshot.docs) {
        String studentID = assessmentDoc["ID"].toString();
        String studentName = assessmentDoc["Name"] as String;
        String studentAnswers = assessmentDoc["StudentAnswers"] as String;

        userMessage = """Evaluate the student's performance in the standardized test against these answers: $assessmentAnswers. Here are the student's answers: $studentAnswers. Output in this format:

        Student ID: $studentID
        Student Name: $studentName

        Provide the percentage you would allocate for each question (Should be full marks if the student's answer matches the assessment answer, allow for slight variation in writing but NOT NUMBERS) in bullet point list (Question 1: [Given score]/[Number the question is out of] | Answer Given: [Give the student's answer] | Correct Answer: [Give the correct answer] AND NO MORE).
        Award full marks (the same number of marks as the question is out of) if the student's answer matches the assessment correct answer. If not, judge if it's a variation in spelling or if the answer is just wrong. Explain your reasoning behind the score of each question.

        Overall Percentage: [Sum the number of marks gained for all questions / the total marks available (DO NOT SHOW YOUR WORKINGS) = __%]

        Ensure the format is maintained as indicated above, and fill in the marks gained out of the total marks for each question separately. Full marks should be given if the student's answer perfectly matches the actual answer for each question. DO NOT STORE OVERALL PERCENTAGE AT THE BOTTOM, PLEASE.
        """;

        // Call the ChatGPT API
        await _sendMessage();

        // Add a delay before making the API call
        await Future.delayed(Duration(seconds: 20)); // 60 seconds / 3 prompts per minute
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

  Future<void> _sendMessage() async {
    if (userMessage.isNotEmpty) {
      if (mounted) {
        setState(() {
          // _chatMessages.add(Message(text: userMessage, isUser: true)); // Hides the prompt from the frontend. If you want to see all of that text ^ just uncomment.
        });
      }

      // Make an API call to OpenAI in the required format // Would prefer to use the original way but has been deprecated under dart_openai ^5.0.0
      try {
        
        final userMessageCorrection = OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(userMessage),
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

        if (mounted) {
          setState(() {
            _chatMessages.add(Message(text: aiResponse, isUser: false));
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
  }

  // Method to add content to the list
  Future<void> _addToResultsList(String aiResponse) async {
    try {
      pdfResults.add(aiResponse);
    } catch (e) {
      print('Error adding to responses: $e... Check _addToResultsList and _sendMessage');
    }
  }

  

  Future<void> _generatePDFExport() async {
    try {
      // Create a new PDF document
      PdfDocument document = PdfDocument();

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
      for (String aiResponse in pdfResults) {
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
      // document.dispose();

      // Save and download the PDF if the widget is still mounted and pdfExport is true
      if (mounted && pdfExport) {
        js.context['pdfData'] = base64.encode(bytes);
        js.context['filename'] = 'Assessment Results.pdf';
        if (pdfExport) {
          js.context.callMethod('download');
        }
        if (mounted) {
          setState(() {
            pdfExport = false;
          });
        }
      }

      // document.dispose();
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }
}