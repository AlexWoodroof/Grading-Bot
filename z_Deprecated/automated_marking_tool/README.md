# automated_marking_tool

A new Flutter project.

Configuration Requirements:

1. After opening the VSCode environment, navigate to a new terminal. Enter "cd [Your project directory]" to set the correct project directory. To find the project directory, right-click on the file [automated-marking-tool] in the explorer pane on the left and select "Copy Path." Paste this path as [Your project directory].

2. Ensure Firebase is installed by following the official installation instructions here: https://firebase.google.com/docs/cli/. 
(I recommend using the npm approach for a more reliable installation process.)

3. In the terminal, type "flutter run"

4. Select a browser by inputting one of the alloted numbers and pressing enter. (It will take about 20-60 seconds to connect to the debug service and then another few seconds for the page to load once the browser has opened.) 

5. Click and run, behold, the app's begun.

6. Also now i think of it, the last working version relied on the following packages:

environment:
  sdk: '>=3.2.3 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  dart_openai: ^5.0.0
  firebase_core: ^2.22.0
  file_picker: ^6.1.1
  syncfusion_flutter_pdf: ^24.1.41
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1


OR

You can just visit this url to view the project in its entirety without the need to install firebase: https://automated-marking-tool.web.app/

Noteable Features:
- Fully worked authentication system in conjunction with firebase.
- Batch upload of documents including a progress timer...(timer is required because i can only query 3 times per minute using 3.5-turbo-1106)
- PDF Export of all gradings for ease of access.

<!-- // TO DO
//// Fix the loading symbol on registration screen, if the email entered is already in use, the loading symbol appears and makes the screen unusable indefinitely. I THINK I FIXED THIS
//// CHECK FOR OVERFLOW ERRORS ON EVERY SINGLE PAGE - DONE SO FAR: Login_Screen.dart... NOT REQUIRED ON WEB BROWSER
// FIX OVERFLOW ERRORS ON LANDING PAGE WHEN IT IS SHRUNK VERTICALLY. MAYBE JUST REWRITE THE ENTIRE CODE because even when its there the highlighting of buttons is incorrect (should be proportional)... COULD PROBABLY STILL DO WITH BEING DONE LEAD ON TO THE NEXT ONE, FIGURE OUT SCREEN SIZING//FIX THE HIGHLIGHTING ON THE CAROSEL SO ITS ALWAYS CIRCULAR AND DOESNT DEPEND ON SCREEN SIZE. May require rewriting the code.
//// Review login and registration screen widthing and heighting (look into minimum screen sizes). on default page size, boxes are too long, but if you make them smaller / lower the 120 value it makes it too compact when you resize horizontally. Would it be possible to implement a height cap. ###THE WIDTHING IS FIXED COMPLETELY, WORKS PERFECTLY BUT HEIGHT IS NOT CAPPED BUT NOT PRESSING.
// OPTIMISE Code structure aswell as formating. Look into how to optimise the project - Look at the ChatGPT chat Rearrange and format code (Has some useful optimisation tips.)
// WHEN USER UPLOADS BATCH FILES, SHOULD EXECUTE A UPLOAD SEQUENCE ANIMATION THING...
// Criteria Page - Ideally, edit button would exist seperately from the save button (which would only appear when isEditing = true). Edit icon would be on the same level as the title - Upload button would be an icon
// Lock the user logging out. So when the user presses logs out they cannot then press the back button to login without an account (Existing within the system without an account) // FIXED using PopScore functionality
// Add a processing circle when the user uploads or batch uploads and grey out the screen so they cant press anything. // Technically fixed, implemented a notification with upload time remaining.
// Make the criteria page see more only show when there is enough text to expand further. // Semi-Fixed, done it on minimum characters, cannot see the number of lines in the text block using \n because it doesnt count as a line break. Using minimum characters on the smallest screen is a cheap workaround.
// Fix error message that appears when pressing the back browsers back button after pressing logged out - figure out the PopScope function...PopScope is fully figured out (See login page for method.) // Fixed
// Ensure that the snack bar activates when password is changed successfully.

// UPGRADE FEATURES
// Allow teachers to have multiple projects. // DID DONE IMPLEMENTED
// Implement Light Mode, Dark Mode. // IMPLEMENTED FULLY
// Use a specialist storage on firestore to store API key, that way it wont be leaked when code is uploaded. // DONE
// Allow for student upload, create a seperate database for students, teachers can be assigned students. Allows the student to upload their work to the database, the teacher can then view it on their account.
// Sub from the one above: Add the individual API Keys functionality. If a user has a teacher account, in the settings or upon account creation they should have to add an API Key for ChatGPT to their account. (Would have to query the model to test the API key effectiveness of the key upon login (to ensure no leak and key works)). Also add a how to get an API Key // Partially done, each person has their own api key. Isn't tested by me and dont have a how to (how to get API key).
// Handwriting recognition - possibly using GPT-4 image recognition.
// Feedback button on landing page. !!!
// Data analytics dashboard. Store student data more comprehensively. Display it in a number of formats.
// Plagarism detection. Possibly use a second query to ensure no plagarism, if chatGPT or plagarism api returns false, proceed with evaluation.
// Secure user validation, validation email. Decide on model to validate user.
// Im not a robot 
// Implement email changing - should use verification, requires them to sign in before changing. Can be done with both email and password. Maybe store past emails in a log.
// Implement Email verification upon registration possibly.
// 
-->