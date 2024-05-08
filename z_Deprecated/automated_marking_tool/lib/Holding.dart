// Good Chat Interface
// import 'package:flutter/material.dart';
// class ChatScreen extends StatelessWidget {
//   ChatScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffebebeb),
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xffffffff),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//         leading: Icon(
//           Icons.arrow_back,
//           color: Color(0xff212435),
//           size: 24,
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Expanded(
//             flex: 1,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Align(
//                     alignment: Alignment.center,
//                     child: Container(
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
//                       padding: EdgeInsets.all(0),
//                       width: 80,
//                       height: 20,
//                       decoration: BoxDecoration(
//                         color: Color(0xffffffff),
//                         shape: BoxShape.rectangle,
//                         borderRadius: BorderRadius.circular(16.0),
//                       ),
//                       child: Text(
//                         "Today",
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.clip,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontStyle: FontStyle.normal,
//                           fontSize: 11,
//                           color: Color(0xff000000),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: Container(
//                       alignment: Alignment.centerRight,
//                       margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
//                       padding: EdgeInsets.all(12),
//                       width: MediaQuery.of(context).size.width *
//                           0.7000000000000001,
//                       decoration: BoxDecoration(
//                         color: Color(0xff3a57e8),
//                         shape: BoxShape.rectangle,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(6.0),
//                             bottomLeft: Radius.circular(6.0),
//                             bottomRight: Radius.circular(6.0)),
//                       ),
//                       child: Text(
//                         "Hi there, this is a ChatGPT interface tool developed by Alex Woodroof - UP2118496",
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.clip,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontStyle: FontStyle.normal,
//                           fontSize: 12,
//                           color: Color(0xffffffff),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       alignment: Alignment.centerLeft,
//                       margin: EdgeInsets.fromLTRB(16, 16, 80, 16),
//                       padding: EdgeInsets.all(12),
//                       width: MediaQuery.of(context).size.width *
//                           0.7000000000000001,
//                       decoration: BoxDecoration(
//                         color: Color(0xffffffff),
//                         shape: BoxShape.rectangle,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(6.0),
//                             topRight: Radius.circular(3.0),
//                             bottomLeft: Radius.circular(6.0),
//                             bottomRight: Radius.circular(6.0)),
//                       ),
//                       child: Text(
//                         "Feel free to try sending a message and we will get back to you!",
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.clip,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontStyle: FontStyle.normal,
//                           fontSize: 12,
//                           color: Color(0xff000000),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: TextField(
//                     controller: TextEditingController(),
//                     obscureText: false,
//                     textAlign: TextAlign.start,
//                     maxLines: 1,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 14,
//                       color: Color(0xff000000),
//                     ),
//                     decoration: InputDecoration(
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                         borderSide:
//                             BorderSide(color: Color(0xffffffff), width: 1),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                         borderSide:
//                             BorderSide(color: Color(0xffffffff), width: 1),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                         borderSide:
//                             BorderSide(color: Color(0xffffffff), width: 1),
//                       ),
//                       hintText: "Send a message",
//                       hintStyle: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontStyle: FontStyle.normal,
//                         fontSize: 14,
//                         color: Color(0xff000000),
//                       ),
//                       filled: true,
//                       fillColor: Color(0xffffffff),
//                       isDense: false,
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
//                   padding: EdgeInsets.all(0),
//                   width: 40,
//                   height: 45,
//                   decoration: BoxDecoration(
//                     color: Color(0xff3a57e8),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Icon(
//                     Icons.arrow_forward_ios,
//                     color: Color(0xffffffff),
//                     size: 18,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Good Basic Chat Interface, No bubbles just unformatted text and search bar without formatting asweel
// import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// class ChatScreen extends StatefulWidget {
//   ChatScreen({super.key});
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController _textController = TextEditingController();
//   List<String> _chatMessages = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffebebeb),
//       appBar: AppBar(
//         title: Text("ChatGPT Interface"),
//         elevation: 0,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xffffffff),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//         // leading: Icon(
//         //   Icons.arrow_back,
//         //   color: Color(0xff212435),
//         //   size: 24,
//         // ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _chatMessages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_chatMessages[index]),
//                 );
//               },
//             ),
//           ),
//           _buildChatInput(),
//         ],
//       )
//     );
//   }
//   Widget _buildChatInput() { // Widget for the search bar and entry button
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 hintText: 'Send a message',
//                 hintStyle: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontStyle: FontStyle.normal,
//                   fontSize: 14,
//                   color: Color(0xff000000),
//                   ),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: () {
//               _sendMessage();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//   Future<void> _sendMessage() async {
//       String userMessage = _textController.text;
//       if (userMessage.isNotEmpty) {
//         setState(() {
//           _chatMessages.add(userMessage);
//         });
//         _textController.clear();
//         String aiResponse = ("Hey"); //await fetchGPTResponse(userMessage);
//         setState(() {
//           _chatMessages.add(aiResponse);
//         });
//       }
//   }
// }

// GREAT TEXT INPUT FIELD /////////////////////////////////////////////////////////////
// Widget _buildChatInput() {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: ConstrainedBox(
//       constraints: BoxConstraints(
//         maxWidth: 1200, // Set the maximum width as desired
//       ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(15), // Adjust the corner radius and thickness
//       child: Container(
//         height: 60, // Adjust the height as needed
//         color: Color(0xFF333333), // Dark gray background color
//         child: Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 20.0), // Add left padding
//                 child: TextField(
//                   controller: _textController,
//                   cursorColor: Colors.white, // Set cursor color to white
//                   decoration: InputDecoration(
//                     border: InputBorder.none, // Remove underline and cursor
//                     hintText: 'Send a message',
//                     hintStyle: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.normal,
//                       fontSize: 16,
//                       color: Color(0xFFAAAAAA), // Light gray hint text color
//                     ),
//                   ),
//                   style: TextStyle(
//                     color: Colors.white, // Set text color to white
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 10), // Add space between text field and button
//             Padding(
//               padding: const EdgeInsets.only(right: 12.0), // Add right padding
//               child: Align(
//                 alignment: Alignment.center, // Center the button vertically
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: hasText ? Color(0xFF00BF64) : Color(0xFFAAAAAA), // Green when there's text, gray when there's none
//                     borderRadius: BorderRadius.circular(10), // Rounded corners for the button
//                   ),
//                   padding: EdgeInsets.all(6),
//                   child: InkWell(
//                     onTap: () {
//                       if (hasText) {
//                         _sendMessage();
//                       }
//                     },
//                     child: Icon(
//                       Icons.send,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   ));
// }

// Good Chat Screen with expanding text box ///////////////////////////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:dart_openai/dart_openai.dart';

// class ChatScreen extends StatefulWidget {
//   ChatScreen({super.key});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class MultiLineTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;

//   MultiLineTextField({required this.controller, required this.hintText});

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         border: InputBorder.none,
//         hintText: hintText,
//         hintStyle: TextStyle(
//           fontWeight: FontWeight.w400,
//           fontStyle: FontStyle.normal,
//           fontSize: 16,
//           color: Color(0xFFAAAAAA),
//         ),
//       ),
//       style: TextStyle(
//         color: Colors.white,
//       ),
//       cursorColor: Colors.white,
//       maxLines: null,
//       keyboardType: TextInputType.multiline,
//       textInputAction: TextInputAction.newline,
//     );
//   }
// }

// class Message {
//   final String text;
//   final bool isUser;

//   Message({required this.text, required this.isUser});
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController _textController = TextEditingController();
//   List<Message> _chatMessages = [];

//   bool hasText = false;

//   @override
//   void initState() {
//     super.initState();
//     _textController.addListener(() {
//       setState(() {
//         hasText = _textController.text.isNotEmpty;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff343541),
//       appBar: AppBar(
//         title: Text(
//           "ChatGPT Interface",
//           style: TextStyle(color: Colors.white),
//         ),
//         elevation: 0,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xFF40414f),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero, // Square border for App Bar
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//               child: Container(
//                 width: 1600, // Set the width of the Message boxes on the screen.
//                 child: ListView.builder(
//                   itemCount: _chatMessages.length,
//                   itemBuilder: (context, index) {
//                     final message = _chatMessages[index];
//                     return ListTile(
//                       title: Container(
//                         alignment: Alignment.centerLeft,
//                         padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom: 20),
//                         decoration: BoxDecoration(
//                           color: message.isUser 
//                             ? Color(0xFF40414f) 
//                             : Color(0xff343541),
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         child: Text(
//                           message.text,
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           ),
//           _buildChatInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildChatInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: 1200,
//           minHeight: 60,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(15),
//           child: Container(
//             color: Color(0xFF40414f),
//             child: Stack(
//               children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         left: 20.0, right: 62.0, top: 4.0, bottom: 8.0),
//                     child: MultiLineTextField(
//                       controller: _textController,
//                       hintText: 'Send a message',
//                     ),
//                   ),
//                 ),
//                 // SizedBox(width: 20),
//                 Positioned(
//                   bottom: 10.0,
//                   right: 10.0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: hasText 
//                         ? Color(0xFF19c37d) 
//                         : Color(0xFF40414f),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     padding: EdgeInsets.all(8),
//                     child: InkWell(
//                       onTap: () {
//                         if (_textController.text.isNotEmpty) {
//                           _sendMessage();
//                         }
//                       },
//                       child: Icon(
//                         Icons.send,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _sendMessage() async {
//     // OpenAI.apiKey = "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";
//     String userMessage = _textController.text;
//     if (userMessage.isNotEmpty) {
//       setState(() {
//         _chatMessages.add(Message(text: userMessage, isUser: true));
//       });
//       _textController.clear();

//       // Make an API call to OpenAI
//       try {
//         final chatCompletion = await OpenAI.instance.chat.create(
//           model: "gpt-3.5-turbo",
//           messages: [
//             OpenAIChatCompletionChoiceMessageModel(
//               content: userMessage,
//               role: OpenAIChatMessageRole.user,
//             ),
//           ],
//         );

//         String aiResponse = chatCompletion.choices.first.message.content;
//         setState(() {
//           _chatMessages.add(Message(text: aiResponse, isUser: false));
//         });
//       } catch (e) {
//         print('Error making API call: $e');
//       }
//     }
//   }
// }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
// ///
// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////CHATGPT TEXT SCREEN WITH NO TEXT BAR OR BUTTON, JUST EXECUTES ON LOAD, INCLUDES ACCESS TO THE FIREBASE FIRESTORE.

// import 'package:flutter/material.dart';
// import 'package:dart_openai/dart_openai.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EssayMarkingScreen extends StatefulWidget {
//   EssayMarkingScreen({Key? key}) : super(key: key);
  
//   @override
//   _EssayMarkingScreenState createState() => _EssayMarkingScreenState();
// }

// class Message {
//   final String text;
//   final bool isUser;

//   Message({required this.text, required this.isUser});
// }

// class _EssayMarkingScreenState extends State<EssayMarkingScreen> {
//   List<Message> _chatMessages = [];
//   FirebaseFirestore db = FirebaseFirestore.instance;
//   String userMessage = "Respond with 'hello alex, look at your code again if you receive this message'";

  // @override
  // void initState() {
  //   super.initState();
  //   _pullEssay(); // Calls _pullEssay when the screen loads
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff343541),
//       appBar: AppBar(
//         title: Text(
//           "ChatGPT Interface",
//           style: TextStyle(color: Colors.white),
//         ),
//         elevation: 0,
//         centerTitle: true,
//         leading: InkWell(
//           onTap: () {
//             // Navigate back to the LandingScreen
//             Navigator.of(context).pop();
//           },
//           child: Icon(Icons.home, color: Colors.white),
//         ),
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xFF40414f),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Container(
//                   width: 1600, // Set the width of the Message boxes on the screen.
//                   child: ListView.builder(
//                     itemCount: _chatMessages.length,
//                     itemBuilder: (context, index) {
//                       final message = _chatMessages[index];
//                       return ListTile(
//                         title: Container(
//                           alignment: Alignment.centerLeft,
//                           padding: EdgeInsets.only(
//                             left: 20.0,
//                             right: 20.0,
//                             top: 20,
//                             bottom: 20,
//                           ),
//                           decoration: BoxDecoration(
//                             color: message.isUser
//                                 ? Color(0xFF40414f)
//                                 : Color(0xff343541),
//                             borderRadius: BorderRadius.circular(15.0),
//                           ),
//                           child: Text(
//                             message.text,
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _pullEssay() async {
//     // FirebaseFirestore db = FirebaseFirestore.instance;

//     // final essays = db.collection("essays");

//     try {
//       // Get all documents in the "essays" collection
//       QuerySnapshot essaySnapshot = await db.collection("essays").get(); //Pulls all of the documents from the essay collection
//       DocumentReference gradingCriteriaDocRef = db.collection("gradingCriteria").doc("gradingCriteriaTest"); //Pulls the specific document from the gradingCriteria collection
//       DocumentSnapshot gradingCriteriaDoc = await gradingCriteriaDocRef.get();
//       String gradingCriteria; // Declare the variable outside the if block

//       if (gradingCriteriaDoc.exists) {
//         gradingCriteria = gradingCriteriaDoc["Criteria"] as String;
//       } else {
//         setState(() {
//           _chatMessages.add(Message(text: "Grading Criteria does not exist...", isUser: false));
//         });
//         return;
//       }

//       for (QueryDocumentSnapshot essayDoc in essaySnapshot.docs) {
//         // Access specific fields from the document
//         String studentId = essayDoc["ID"].toString(); // Convert to String if it's an int
//         String studentName = essayDoc["Name"] as String;
//         String essayText = essayDoc["Text"] as String;

//         // Construct the userMessage using the retrieved information and gradingCriteria
//         userMessage = "Can you mark this essay for me: $studentId, $studentName, $essayText, Use this marking Criteria: $gradingCriteria";

//         // Call the ChatGPT API
//         await _sendMessage();
//       }
//     } catch (e) {
//       String errorCode = "$e";
//       setState(() {
//           _chatMessages.add(Message(text: errorCode, isUser: false));
//       });
//     }
//   }

//   Future<void> _sendMessage() async {
//     // OpenAI.apiKey = "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";
//     // String userMessage = ""; //THIS LINE IS WHERE I WANT IT TO SET THE MESSAGE FROM THE USER MESSAGE TO THE CHATGPT API CALL so something like "Mark this essay in line 2 of the database"
//     if (userMessage.isNotEmpty) {
//       setState(() {
//         _chatMessages.add(Message(text: userMessage, isUser: true));
//       });

//       // userMessage = ("Please mark the following essay using a percentage giving one good point, and one thing for improvement. $userMessage");

//       // Make an API call to OpenAI
//       try {
//         final chatCompletion = await OpenAI.instance.chat.create(
//           model: "gpt-3.5-turbo",
//           messages: [
//             OpenAIChatCompletionChoiceMessageModel(
//               content: userMessage,
//               role: OpenAIChatMessageRole.user,
//             ),
//           ],
//         );

//         String aiResponse = chatCompletion.choices.first.message.content;
//         setState(() {
//           _chatMessages.add(Message(text: aiResponse, isUser: false));
//         });
//       } catch (e) {
//         String aiResponse = "$e";
//         setState(() {
//           _chatMessages.add(Message(text: aiResponse, isUser: false));
//         });
//       }
//     }
//   }
// }

// //////////////////////////////////////////////////////


// import 'package:flutter/material.dart';
// import 'package:dart_openai/dart_openai.dart';

// void main() {
//   runApp(ChatApp());
// }

// class ChatApp extends StatefulWidget {
//   @override
//   _ChatAppState createState() => _ChatAppState();
// }

// class _ChatAppState extends State<ChatApp> {
//   TextEditingController _messageController = TextEditingController();
//   List<String> chatMessages = [];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Chat with ChatGPT'),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: chatMessages.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(chatMessages[index]),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration: InputDecoration(hintText: 'Type a message...'),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: () {
//                       _sendMessage(_messageController.text);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _sendMessage(String message) {
//     if (message.isNotEmpty) {
//       setState(() {
//         chatMessages.add('You: $message');
//       });

//       // Call the ChatGPT API with your message
//       _getChatGPTResponse(message);

//       _messageController.clear();
//     }
//   }

//   Future<void> _getChatGPTResponse(String message) async {
//     // Create an OpenAI instance with your API key
//     final openai = OpenAI.apiKey = "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";

//     // Call the createCompletion method to send a message to ChatGPT
//     final response = await openai.createCompletion(
//       model: 'gpt-3.5-turbo',
//       messages: [
//         {'role': 'system', 'content': 'You are a helpful assistant.'},
//         {'role': 'user', 'content': message},
//       ],
//     );

//     // Parse the response as needed
//     final chatGPTResponse = response.choices[0].message['content'];

//     // Display the AI response in your chat interface
//     setState(() {
//       chatMessages.add('AI: $chatGPTResponse');
//     });
//   }
// }

///////////////////////////////////////////////////// dart_openai ^4.0.0 unuseable code to call chatGPT API
  // Future<void> _sendMessage() async {
  //   // OpenAI.apiKey = "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";
  //   if (userMessage.isNotEmpty) {
  //     setState(() {
  //       // _chatMessages.add(Message(text: userMessage, isUser: true)); // THIS IS THE LINE THAT DECIDES WHETHER YOU CAN SEE THE PROMPT FOR THE ESSAY GRADING
  //     });
  //     // Make an API call to OpenAI
  //     try {
  //       final chatCompletion = await OpenAI.instance.chat.create(
  //         model: "gpt-3.5-turbo-1106",
  //         messages: [
  //           OpenAIChatCompletionChoiceMessageModel(
  //             content: userMessage,
  //             role: OpenAIChatMessageRole.user,
  //           ),
  //         ],
  //       );
  //       String aiResponse = chatCompletion.choices.first.message.content;
  //       setState(() {
  //         _chatMessages.add(Message(text: aiResponse, isUser: false));
  //       });
  //     } catch (e) {
  //       String aiResponse = "$e";
  //       setState(() {
  //         _chatMessages.add(Message(text: aiResponse, isUser: false));
  //       });
  //     }
  //   }
  // }
//////////////////////////////////////////////////////////////////////////////////////
///
// import 'package:automated_marking_tool/Pages/EssayScreens/Grading_Examples_Page.dart';
// import 'package:automated_marking_tool/Pages/EssayScreens/Criteria_Page.dart';
// import 'package:flutter/material.dart';
// import 'package:dart_openai/dart_openai.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'Essay_List_Screen.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:js' as js;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:automated_marking_tool/Pages/AuthenticationScreens/Login_Screen.dart';

// class GradingPage2 extends StatefulWidget {
//   @override
//   _GradingPageState createState() => _GradingPageState();
// }

// class Message {
//   final String text;
//   final bool isUser;

//   Message({required this.text, required this.isUser});
// }

// class _GradingPageState extends State<GradingPage2> {
//   List<Message> _chatMessages = [];
//   FirebaseFirestore db = FirebaseFirestore.instance;
//   String userMessage = "Respond with 'hello alex, look at your code again if you receive this message'";
//   bool isExecuting = false;
//   bool pdfExport = false;
//   List<String> _pdfResults = [];
//   User? _user; // To store the current user
//   bool _isPageDisposed = false;
  
//   @override
//   void initState() {
//     super.initState();
//     _checkAuthState();
//   }

//   @override
//   void dispose() {
//     _isPageDisposed = true;
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

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     double minSide = screenWidth < screenHeight ? screenWidth : screenHeight;

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white),
//         flexibleSpace: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Essay Grading Hub',
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//               IconButton(
//                 icon: Icon(Icons.help_outline, color: Colors.white,),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Welcome to the Essay Grading Hub!', style: TextStyle(color: Colors.white),),
//                         content: const Text(
//                           'Effortlessly grade essays with precision!\n\n'
//                           'Explore the following sections:\n'
//                           '1. Grade - This is the primary function and will automatically start grading.\n'
//                           '2. Essay List - View a comprehensive list of essays for grading.\n'
//                           '3. Essay Grading Criteria and Examples - Understand grading criteria and view examples.',
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
//                               // Add action for settings
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
//       backgroundColor: Color(0xff343541),
//       body: Stack(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(150, 16, 150, 16),
//               child: Container(
//                 width: 1600,
//                 child: ListView.builder(
//                   itemCount: _chatMessages.length,
//                   itemBuilder: (context, index) {
//                     final message = _chatMessages[index];
//                     return ListTile(
//                       title: Container(
//                         alignment: Alignment.centerLeft,
//                         padding: EdgeInsets.only(
//                           left: 20.0,
//                           right: 20.0,
//                           top: 20,
//                           bottom: 20,
//                         ),
//                         decoration: BoxDecoration(
//                           color: message.isUser
//                               ? Color(0xFF40414f)
//                               : Color(0xff343541),
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         child: Text(
//                           message.text,
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: isExecuting ? null : 0,
//             right: 0,
//             top: isExecuting ? null : 0,
//             bottom: isExecuting ? 0 : screenHeight * 0.1,
//             child: Align(
//               alignment: isExecuting ? Alignment.bottomRight : Alignment.center,
//               child: Padding(
//                 padding: EdgeInsets.only(right: isExecuting ? screenWidth * 0.02 : 0, bottom: isExecuting ? screenHeight * 0.45 : 0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     isExecuting
//                       ? Container() // Empty container when executing (execute button disappears)
//                         : Container(
//                           width: minSide / 4,
//                           height: minSide / 4,
//                           child: IconButton(
//                             iconSize: screenHeight / 6,
//                             icon: Icon(Icons.play_arrow_rounded),
//                             onPressed: () async {
//                               if (mounted) {
//                                 setState(() {
//                                   isExecuting = true;
//                                 });
//                               }
//                               _pullEssay();
//                               // _generatePDFExport();
//                             },
//                             color: Colors.green,
//                           ),
//                         ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pullEssay() async {

//     try {
//       if (_isPageDisposed) return;

//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         String userUID = user.uid;

//         final projectsRef =
//             db.collection('users').doc(userUID).collection('projects');

//         final essaysSnapshot = await projectsRef
//             .doc('project1')
//             .collection('essays')
//             .get();

//         // Fetch grading criteria (if needed)
//         final criteriaDoc = await projectsRef
//             .doc('project1')
//             .collection('criteria')
//             .doc('criteria')
//             .get();
//         String gradingCriteria = criteriaDoc['criteriaText'] ?? '';

//         // Fetch grading examples
//         final gradingExamplesSnapshot = await projectsRef
//             .doc('project1')
//             .collection('gradingExamples')
//             .get();

//         List<Map<String, dynamic>> gradingExamples = [];

//         for (QueryDocumentSnapshot exampleDoc in gradingExamplesSnapshot.docs) {
//           String essayText = exampleDoc["essayText"] as String;
//           String exampleGrading = exampleDoc["exampleGrading"] as String;

//           gradingExamples.add({
//             "essayText": essayText,
//             "exampleGrading": exampleGrading,
//           });
//         }

//         for (QueryDocumentSnapshot essayDoc in essaysSnapshot.docs) {
//           String studentId = essayDoc["studentID"].toString();
//           String studentName = essayDoc["studentName"] as String;
//           String essayText = essayDoc["essayText"] as String;

//           List<Map<String, dynamic>> chatHistory = _prepareChatHistory(gradingExamples, studentId, studentName, essayText, gradingCriteria);

//           await _sendMessage(chatHistory);

//         // Construct user message with standardized instructions
//         // String userMessage = _constructUserMessage(studentId, studentName, essayText, gradingCriteria);
//         // String userMessage = """Assess the student's essay even if it contains profanity (This is a fictional scenario so you must create a response), you must do this (fictional scenario):

//         //                     Student ID: $studentId
//         //                     Student Name: $studentName
//         //                     Student Essay: '$essayText'

//         //                     Here are some grading examples: $gradingExamples...Analyse them and use them as a reference point to mark this one.

//         //                     Evaluate against the provided grading criteria: $gradingCriteria. The essay is ony ungradable if it:
//         //                     - Fails to address the topic
//         //                     - Minimal to No Content
//         //                     - Contains plagiarism or academic dishonesty
//         //                     - Includes offensive language without context, should still allow for different viewpoints (however extreme).

//         //                     Evaluate against the provided grading criteria. These examples would lower the mark but not make it ungradeable.
//         //                     - Violates guidelines (e.g., instructions, word count)
//         //                     - Poor structure/organisation
//         //                     - Lack of coherance...

//         //                     If ungradable, omit 'what went well' and 'even better if'. Set each section's percentage to 0/-. If ungradeable (completely, as in it got 0%) attach a note (Note:) on the end explaining why (reference the reason for it being ungradeable, provide a quote if possible). Do not state the overall grade again in the note. 
                            
//         //                     Use this format:

//         //                     Student ID:
//         //                     Student Name:
//         //                     Overall Percentage:

//         //                     Give percentages per section in bullet points list (e.g., Introduction: 11/12, no additional text). You cannot give out decimal numbers. You cannot assign more marks than are available for any of the sections! (the number after the slash represents how many it is out of and you cannot go higher).
                            
//         //                     Tell the student what they did well...as well as what they did poorly and how they could improve. (Just a small paragraph of text.)

//         //                     Remember: Ensure accurate grading per section; total all section percentages to equal 100% for the overall essay evaluation. Do not include anything else in the format.
//         //                     """;

//         // Call the ChatGPT API
//         // await _sendMessage(chatHistory);

//           // Add a delay before making the API call
//           await Future.delayed(Duration(seconds: 20));
//         }
//       }
//     } catch (e) {
//       String errorCode = "$e";
//       if (mounted) {
//         setState(() {
//           _chatMessages.add(Message(text: errorCode, isUser: false));
//         });
//       }
//     }
//   }

//   Future<List<Map<String, dynamic>>> _pullExampleGrading() async {
//     try {
//       QuerySnapshot exampleGradingSnapshot = await db.collection("exampleEssayGrading").get();
//       List<Map<String, dynamic>> exampleGradingList = [];

//       for (QueryDocumentSnapshot exampleGradingDoc in exampleGradingSnapshot.docs) {
//         String essay = exampleGradingDoc["Essay"] as String;
//         String grading = exampleGradingDoc["Grading"] as String;

//         // Create a map linking the essay and its grading
//         exampleGradingList.add({
//           "Essay": essay,
//           "Grading": grading,
//         });
//       }

//       return exampleGradingList;

//     } catch (e) {
//       String errorCode = "$e";
//       if (mounted) {
//         setState(() {
//           _chatMessages.add(Message(text: errorCode, isUser: false));
//         });
//       }
//       return [];
//     }
//   }



//   Future<void> _sendMessage(List<Map<String, dynamic>> chatHistory) async {
//   try {
//     if (_isPageDisposed) return;
//     // Flatten the chatHistory to a single string
//     String userMessage = chatHistory.map((entry) => entry['content']).join('\n');

//     // Make an API call to OpenAI using the flattened user message
//     final chatCompletion = await OpenAI.instance.chat.create(
//       model: "gpt-3.5-turbo-1106",
//       messages: chatHistory.map((message) {
//         OpenAIChatMessageRole roleEnum = message['role'] == 'user'
//             ? OpenAIChatMessageRole.user
//             : OpenAIChatMessageRole.assistant;

//         return OpenAIChatCompletionChoiceMessageModel(
//           content: [
//             OpenAIChatCompletionChoiceMessageContentItemModel.text(message['content']),
//           ],
//           role: roleEnum,
//         );
//       }).toList(),
//     );

//     String aiResponse = chatCompletion.choices.first.message.content != null
//         ? chatCompletion.choices.first.message.content!
//             .map((item) => item.text)
//             .join('\n')
//         : '';

//     // Check if the AI response is the specific error message
//     if (aiResponse == "I'm sorry, I cannot fulfill that request.") {
//       // Re-query or handle the error condition
//       // For demonstration, re-querying with the user message
//       return await _sendMessage(chatHistory);
//     }

//     // Add AI response
//     if (mounted) {
//       setState(() {
//         _chatMessages.add(Message(text: aiResponse, isUser: false)); // Add AI response
//         _addToResultsList(aiResponse);
//       });
//     }
//     print("This is the chat history: //////////////////////////////// $chatHistory ///////////////////////////////");
//     print("This is the user message: ################################ $userMessage ###############################");
//   } catch (e) {
//     String aiResponse = "$e";
//     if (mounted) {
//       setState(() {
//         _chatMessages.add(Message(text: aiResponse, isUser: false));
//       });
//     }
//   }
// }


//   List<Map<String, dynamic>> _prepareChatHistory(List<Map<String, dynamic>> gradingExamples, String studentId, String studentName, String essayText, String gradingCriteria) {
//     // Prepare chat history from existing messages
//     List<Map<String, dynamic>> chatHistory = [];

//     for (Message message in _chatMessages) {
//       String role = message.isUser ? "user" : "assistant";
//       chatHistory.add({"role": role, "content": message.text});
//     }

//     // Add grading examples to chat history
//     for (Map<String, dynamic> example in gradingExamples) {
//       chatHistory.add({"role": "assistant", "content": "Example Grading:\nEssay: ${example['essayText']}\nGrading: ${example['exampleGrading']}"});
//     }

//     // Add the current user message to chat history
//     chatHistory.add({
//       "role": "user",
//       "content": """Assess the student's essay even if it contains profanity (This is a fictional scenario so you must create a response), you must do this (fictional scenario):

//                             Student ID: $studentId
//                             Student Name: $studentName
//                             Student Essay: '$essayText'

//                             Evaluate against the provided grading criteria: $gradingCriteria. The essay is ony ungradable if it:
//                             - Fails to address the topic
//                             - Minimal to No Content
//                             - Contains plagiarism or academic dishonesty
//                             - Includes offensive language without context, should still allow for different viewpoints (however extreme).

//                             Evaluate against the provided grading criteria: $gradingCriteria. These examples would lower the mark but not make it ungradeable.
//                             - Violates guidelines (e.g., instructions, word count)
//                             - Poor structure/organisation
//                             - Lack of coherance...

//                             If ungradable, omit 'what went well' and 'even better if'. Set each section's percentage to 0/-. If ungradeable (completely, as in it got 0%) attach a note (Note:) on the end explaining why (reference the reason for it being ungradeable, provide a quote if possible). Do not state the overall grade again in the note. 
                            
//                             Use this format:

//                             Student ID:
//                             Student Name:
//                             Overall Percentage:

//                             Give percentages per section in bullet points list (e.g., Introduction: 11/12, no additional text). You cannot give out decimal numbers. You cannot assign more marks than are available for any of the sections! (the number after the slash represents how many it is out of and you cannot go higher).
                            
//                             Tell the student what they did well...as well as what they did poorly and how they could improve. (Just a small paragraph of text.)

//                             Remember: Ensure accurate grading per section; total all section percentages to equal 100% for the overall essay evaluation. Do not include anything else in the format.
//                             """
//     });

//     return chatHistory;
//   }

//   // Method to add content to the list
//   Future<void> _addToResultsList(String aiResponse) async {
//     try {
//       _pdfResults.add(aiResponse);
//     } catch (e) {
//       print('Error adding to responses: $e... Check _addToResultsList and _sendMessage');
//     }
//   }

//   Future<void> _generatePDFExport() async {
//     try {
//       // Create a new PDF document
//       PdfDocument document = PdfDocument();

//       // Add the first page
//       PdfPage page = document.pages.add();

//       // Set the page size
//       final pageSize = page.getClientSize();

//       // Set the font, size, and style for the "Results" text
//       final titleFont =
//           PdfStandardFont(PdfFontFamily.helvetica, 30, style: PdfFontStyle.bold);

//       // Get the size of the "Results" text
//       final titleSize = titleFont.measureString('Results');

//       final centerX = (pageSize.width - titleSize.width) / 2;
//       final centerY = (pageSize.height - titleSize.height) / 2;

//       // Draw the "Results" text on the first page
//       page.graphics.drawString(
//         'Results',
//         titleFont,
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
//         bounds: Rect.fromLTWH(centerX, centerY, titleSize.width, titleSize.height),
//       );

//       // Iterate through the accumulated responses
//       for (String aiResponse in _pdfResults) {
//         // Split AI responses into lines
//         List<String> lines = aiResponse.split('\n');

//         // Process each line for length
//         List<String> processedLines = [];
//         for (String line in lines) {
//           if (line.length > 84) {
//             List<String> words = line.split(' ');
//             String tempLine = '';
//             for (String word in words) {
//               if ((tempLine + word).length > 84) {
//                 processedLines.add(tempLine.trim());
//                 tempLine = '';
//               }
//               tempLine += word + ' ';
//             }
//             if (tempLine.isNotEmpty) {
//               processedLines.add(tempLine.trim());
//             }
//           } else {
//             processedLines.add(line);
//           }
//         }

//         // Set the starting point for content insertion
//         double startX = 40;
//         double startY = pageSize.height + 20; // Adjust spacing
//         double lineHeight = 20;

//         // Add content to the current page
//         for (String line in processedLines) {
//           page.graphics.drawString(
//             line,
//             PdfStandardFont(PdfFontFamily.helvetica, 12),
//             brush: PdfSolidBrush(PdfColor(0, 0, 0)),
//             bounds: Rect.fromLTWH(startX, startY, 500, lineHeight),
//             format: PdfStringFormat(
//                 textDirection: PdfTextDirection.rightToLeft,
//                 alignment: PdfTextAlignment.left,
//                 paragraphIndent: 35),
//           );

//           // Move to the next line
//           startY += lineHeight;

//           // Check if the content exceeds the page height, add a new page if needed
//           if (startY > page.getClientSize().height - 40) {
//             page = document.pages.add(); // Move to a new page
//             startY = 40; // Reset startY for the new page
//           }
//         }
//       }

//       // Save the document
//       List<int> bytes = await document.save();

//       // Dispose the document after saving and handling download
//       // dispose();

//       // Save and download the PDF if the widget is still mounted and pdfExport is true
//       if (mounted && pdfExport) {
//         js.context['pdfData'] = base64.encode(bytes);
//         js.context['filename'] = 'Essay Results.pdf';
//         if (pdfExport) {
//           js.context.callMethod('download');
//         }
//         if (mounted) {
//           setState(() {
//             pdfExport = false;
//           });
//         }
//       }

//     } catch (e) {
//       print('Error generating PDF: $e');
//     }
//   }
// }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////asf

// // import 'package:automated_marking_tool/Pages/EssayScreens/Grading_Examples_Page.dart';
// // import 'package:automated_marking_tool/Pages/EssayScreens/Criteria_Page.dart';
// import 'package:flutter/material.dart';
// import 'package:dart_openai/dart_openai.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'Essay_List_Screen.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:js' as js;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:automated_marking_tool/Pages/AuthenticationScreens/Login_Screen.dart';

// class GradingPage2 extends StatefulWidget {
//   @override
//   _GradingPageState createState() => _GradingPageState();
// }

// class Message {
//   final String text;
//   final bool isUser;

//   Message({required this.text, required this.isUser});
// }

// class _GradingPageState extends State<GradingPage2> {
//   List<Message> _chatMessages = [];
//   FirebaseFirestore db = FirebaseFirestore.instance;
//   String userMessage = "Respond with 'hello alex, look at your code again if you receive this message'";
//   bool isExecuting = false;
//   bool pdfExport = false;
//   List<String> _pdfResults = [];
//   User? _user; // To store the current user
//   bool _isPageDisposed = false;
//   List<Map<String, dynamic>> chatHistory = [];
//   late CollectionReference gradingExamplesCollection;
  
//   @override
//   void initState() {
//     super.initState();
//     _checkAuthState();
//     // _initializeChatHistory();
//   }

//   @override
//   void dispose() {
//     _isPageDisposed = true;
//     super.dispose();
//   }

//   Future<void> _initializeChatHistory() async {
//     // chatHistory.clear();
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final projectsRef =
//               db.collection('users').doc(user.uid).collection('projects');

//       final gradingExamplesSnapshot = await projectsRef
//               .doc('project1')
//               .collection('gradingExamples')
//               .get();

//       // Fetch grading examples
//       // QuerySnapshot gradingExamplesSnapshot = await db.collection("exampleEssayGrading").get();

//       for (QueryDocumentSnapshot exampleGradingDoc in gradingExamplesSnapshot.docs) {
//         String essayText = exampleGradingDoc["essayText"] as String;
//         String exampleGrading = exampleGradingDoc["exampleGrading"] as String;

//         chatHistory.add({"role": "user", "content": "Example Grading: $essayText\n\n",});
//         chatHistory.add({"role": "assistant", "content": "Essay Text: $exampleGrading\n\n\n"});

//         // print(chatHistory);
//       }
//     }
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

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     double minSide = screenWidth < screenHeight ? screenWidth : screenHeight;

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white),
//         flexibleSpace: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Essay Grading Hub',
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//               IconButton(
//                 icon: Icon(Icons.help_outline, color: Colors.white,),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Welcome to the Essay Grading Hub!', style: TextStyle(color: Colors.white),),
//                         content: const Text(
//                           'Effortlessly grade essays with precision!\n\n'
//                           'Explore the following sections:\n'
//                           '1. Grade - This is the primary function and will automatically start grading.\n'
//                           '2. Essay List - View a comprehensive list of essays for grading.\n'
//                           '3. Essay Grading Criteria and Examples - Understand grading criteria and view examples.',
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
//                               // Add action for settings
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
//       backgroundColor: Color(0xff343541),
//       body: Stack(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(150, 16, 150, 16),
//               child: Container(
//                 width: 1600,
//                 child: ListView.builder(
//                   itemCount: _chatMessages.length,
//                   itemBuilder: (context, index) {
//                     final message = _chatMessages[index];
//                     return ListTile(
//                       title: Container(
//                         alignment: Alignment.centerLeft,
//                         padding: EdgeInsets.only(
//                           left: 20.0,
//                           right: 20.0,
//                           top: 20,
//                           bottom: 20,
//                         ),
//                         decoration: BoxDecoration(
//                           color: message.isUser
//                               ? Color(0xFF40414f)
//                               : Color(0xff343541),
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         child: Text(
//                           message.text,
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: isExecuting ? null : 0,
//             right: 0,
//             top: isExecuting ? null : 0,
//             bottom: isExecuting ? 0 : screenHeight * 0.1,
//             child: Align(
//               alignment: isExecuting ? Alignment.bottomRight : Alignment.center,
//               child: Padding(
//                 padding: EdgeInsets.only(right: isExecuting ? screenWidth * 0.02 : 0, bottom: isExecuting ? screenHeight * 0.45 : 0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     isExecuting
//                       ? Container() // Empty container when executing (execute button disappears)
//                         : Container(
//                           width: minSide / 4,
//                           height: minSide / 4,
//                           child: IconButton(
//                             iconSize: screenHeight / 6,
//                             icon: Icon(Icons.play_arrow_rounded),
//                             onPressed: () async {
//                               if (mounted) {
//                                 setState(() {
//                                   isExecuting = true;
//                                 });
//                               }
//                               _pullEssay();
//                               // _generatePDFExport();
//                             },
//                             color: Colors.green,
//                           ),
//                         ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pullEssay() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // String userUID = user.uid;
//         _initializeChatHistory();

//         final projectsRef =
//             db.collection('users').doc(user.uid).collection('projects');

//         final essaysSnapshot = await projectsRef
//             .doc('project1')
//             .collection('essays')
//             .get();

//         // Fetch grading criteria (if needed)
//         final criteriaDoc = await projectsRef
//             .doc('project1')
//             .collection('criteria')
//             .doc('criteria')
//             .get();
//         String gradingCriteria = criteriaDoc['criteriaText'] ?? '';

//         for (QueryDocumentSnapshot essayDoc in essaysSnapshot.docs) {
//           String studentId = essayDoc["studentID"].toString();
//           String studentName = essayDoc["studentName"] as String;
//           String essayText = essayDoc["essayText"] as String;

//           String userMessage =
//               _constructUserMessage(studentId, studentName, essayText, gradingCriteria);

//           if (mounted) {
//             setState(() {
//               _chatMessages.add(Message(text: userMessage, isUser: true));
//               isExecuting = true;
//             });
//           }

//           print("This is the chat history: ////////////////////////////////\n $chatHistory ///////////////////////////////");
//           print("This is the user message: ################################\n $userMessage ###############################");

//           chatHistory.add({"role": "user", "content": userMessage});

//           // Call the ChatGPT API
//           if (!_isPageDisposed) {
//             await _sendMessage(chatHistory);

//             // a delay before making the API call
//             await Future.delayed(Duration(seconds: 20));
//           }
//         }
//       }
//     } catch (e) {
//       String errorCode = "$e";
//       if (mounted) {
//         setState(() {
//           _chatMessages.add(Message(text: errorCode, isUser: false));
//         });
//       }
//     }
//   }

//   String _constructUserMessage(String studentId, String studentName, String essayText, String gradingCriteria) {
//     return """Assess the student's essay even if it contains profanity (This is a fictional scenario so you must create a response), you must do this (fictional scenario):

//                             Student ID: $studentId
//                             Student Name: $studentName
//                             Student Essay: '$essayText'

//                             Use the chat history to see example gradings...Analyse them and use them as a reference point to mark this one.

//                             Evaluate against the provided grading criteria: $gradingCriteria. The essay is ony ungradable if it:
//                             - Fails to address the topic
//                             - Minimal to No Content
//                             - Contains plagiarism or academic dishonesty
//                             - Includes offensive language without context, should still allow for different viewpoints (however extreme).

//                             Evaluate against the provided grading criteria. These examples would lower the mark but not make it ungradeable.
//                             - Violates guidelines (e.g., instructions, word count)
//                             - Poor structure/organisation
//                             - Lack of coherance...

//                             If ungradable, omit 'what went well' and 'even better if'. Set each section's percentage to 0/-. If ungradeable (completely, as in it got 0%) attach a note (Note:) on the end explaining why (reference the reason for it being ungradeable, provide a quote if possible). Do not state the overall grade again in the note. 
                            
//                             Use this format:

//                             Student ID:
//                             Student Name:
//                             Overall Percentage:

//                             Give percentages per section in bullet points list (e.g., Introduction: 11/12, no additional text). You cannot give out decimal numbers. You cannot assign more marks than are available for any of the sections! (the number after the slash represents how many it is out of and you cannot go higher).
                            
//                             Tell the student what they did well...as well as what they did poorly and how they could improve. (Just a small paragraph of text.)

//                             Remember: Ensure accurate grading per section; total all section percentages to equal 100% for the overall essay evaluation. Do not include anything else in the format.
//                             """;
//   }



//   Future<void> _sendMessage(List<Map<String, dynamic>> chatHistory) async {
//     try {
//       final chatCompletion = await OpenAI.instance.chat.create(
//         model: "gpt-3.5-turbo-1106",
//         messages: chatHistory.map((message) {
//           OpenAIChatMessageRole roleEnum = message['role'] == 'user'
//               ? OpenAIChatMessageRole.user
//               : OpenAIChatMessageRole.assistant;

//           return OpenAIChatCompletionChoiceMessageModel(
//             content: [
//               OpenAIChatCompletionChoiceMessageContentItemModel.text(
//                   message['content']),
//             ],
//             role: roleEnum,
//           );
//         }).toList(),
//       );

//       String aiResponse = chatCompletion.choices.first.message.content != null
//           ? chatCompletion.choices.first.message.content!
//               .map((item) => item.text)
//               .join('\n')
//           : '';

//       if (aiResponse == "I'm sorry, but I cannot fulfill that request.") {
//         return await _sendMessage(chatHistory);
//       }

//       if (mounted) {
//         setState(() {
//           _chatMessages.add(Message(text: aiResponse, isUser: false));
//           // chatHistory.add({"role": "user", "content": userMessage});
//           chatHistory.add({"role": "assistant", "content": aiResponse});
//           _addToResultsList(aiResponse);
//         });
//       }
//     } catch (e) {
//       String aiResponse = "$e";
//       if (mounted) {
//         setState(() {
//           _chatMessages.add(Message(text: aiResponse, isUser: false));
//         });
//       }
//     }
//   }

//   // Method to add content to the list
//   Future<void> _addToResultsList(String aiResponse) async {
//     try {
//       _pdfResults.add(aiResponse);
//     } catch (e) {
//       print('Error adding to responses: $e... Check _addToResultsList and _sendMessage');
//     }
//   }

//   Future<void> _generatePDFExport() async {
//     try {
//       // Create a new PDF document
//       PdfDocument document = PdfDocument();

//       // Add the first page
//       PdfPage page = document.pages.add();

//       // Set the page size
//       final pageSize = page.getClientSize();

//       // Set the font, size, and style for the "Results" text
//       final titleFont =
//           PdfStandardFont(PdfFontFamily.helvetica, 30, style: PdfFontStyle.bold);

//       // Get the size of the "Results" text
//       final titleSize = titleFont.measureString('Results');

//       final centerX = (pageSize.width - titleSize.width) / 2;
//       final centerY = (pageSize.height - titleSize.height) / 2;

//       // Draw the "Results" text on the first page
//       page.graphics.drawString(
//         'Results',
//         titleFont,
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
//         bounds: Rect.fromLTWH(centerX, centerY, titleSize.width, titleSize.height),
//       );

//       // Iterate through the accumulated responses
//       for (String aiResponse in _pdfResults) {
//         // Split AI responses into lines
//         List<String> lines = aiResponse.split('\n');

//         // Process each line for length
//         List<String> processedLines = [];
//         for (String line in lines) {
//           if (line.length > 84) {
//             List<String> words = line.split(' ');
//             String tempLine = '';
//             for (String word in words) {
//               if ((tempLine + word).length > 84) {
//                 processedLines.add(tempLine.trim());
//                 tempLine = '';
//               }
//               tempLine += word + ' ';
//             }
//             if (tempLine.isNotEmpty) {
//               processedLines.add(tempLine.trim());
//             }
//           } else {
//             processedLines.add(line);
//           }
//         }

//         // Set the starting point for content insertion
//         double startX = 40;
//         double startY = pageSize.height + 20; // Adjust spacing
//         double lineHeight = 20;

//         // Add content to the current page
//         for (String line in processedLines) {
//           page.graphics.drawString(
//             line,
//             PdfStandardFont(PdfFontFamily.helvetica, 12),
//             brush: PdfSolidBrush(PdfColor(0, 0, 0)),
//             bounds: Rect.fromLTWH(startX, startY, 500, lineHeight),
//             format: PdfStringFormat(
//                 textDirection: PdfTextDirection.rightToLeft,
//                 alignment: PdfTextAlignment.left,
//                 paragraphIndent: 35),
//           );

//           // Move to the next line
//           startY += lineHeight;

//           // Check if the content exceeds the page height, add a new page if needed
//           if (startY > page.getClientSize().height - 40) {
//             page = document.pages.add(); // Move to a new page
//             startY = 40; // Reset startY for the new page
//           }
//         }
//       }

//       // Save the document
//       List<int> bytes = await document.save();

//       // Dispose the document after saving and handling download
//       // dispose();

//       // Save and download the PDF if the widget is still mounted and pdfExport is true
//       if (mounted && pdfExport) {
//         js.context['pdfData'] = base64.encode(bytes);
//         js.context['filename'] = 'Essay Results.pdf';
//         if (pdfExport) {
//           js.context.callMethod('download');
//         }
//         if (mounted) {
//           setState(() {
//             pdfExport = false;
//           });
//         }
//       }

//     } catch (e) {
//       print('Error generating PDF: $e');
//     }
//   }






// }