# GradingBot

[GradingBot](https://automated-marking-tool.web.app/) is a powerful and intuitive essay marking tool designed to help lecturers and teachers streamline the grading process for student essays. By utilizing the power of AI, specifically ChatGPT, GradingBot automates the grading process, providing consistent, detailed, and insightful feedback on student submissions.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Creating & Managing Projects](#creating-&-managing-projects)
  - [Uploading Essays](#uploading-essays)
  - [Setting the Marking Scheme](#setting-the-marking-scheme)
  - [Increasing Model Accuracy](#increasing-model-accuracy)
  - [Grading Essays](#grading-essays)
  - [Downloading Marked Essays](#downloading-marked-essays)
- [Configuration](#configuration)
- [Limitations](#limitations)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Batch Uploading**: Upload multiple student essays in PDF format at once.
- **Custom Marking Schemes**: Define custom marking criteria tailored to your course requirements.
- **AI-Powered Grading**: Automatically grade essays using OpenAI's ChatGPT, ensuring consistency and depth in feedback.
- **Example-Based Training**: Provide examples of marked essays to help train the AI for better accuracy.
- **Real-Time Feedback**: View grading results as they are generated.
- **Batch Download**: Download all marked essays along with comments in a single PDF document.

## Getting Started

### Installation

To install GradingBot, clone this repository and install the necessary dependencies.
#You will require flutter for this step: [How to install](https://www.geeksforgeeks.org/how-to-install-flutter-on-visual-studio-code/)

```bash
git clone https://github.com/AlexWoodroof/GradingBot.git
cd GradingBot
flutter pub get
```

### Prerequisites

Before you begin (or access the [web version](https://automated-marking-tool.web.app/)), ensure you have the following:

- Dart
- Flutter
- An OpenAI API key (for accessing ChatGPT)

## Usage

### Creating & Managing Projects
GradingBot allows you to manage multiple projects, such as different courses or assignments, within the same interface.

After launching the application and logging in, create a new project by selecting "Create New Project" from the main menu.
Assign a name to your project, such as "English 101 - Essay 1".
Switch between projects by selecting navigating back to the main menu and using the arrows, where you can view, access, or delete existing projects.

### Uploading Essays

1. Navigate to the GradingBot directory.
2. Launch the application:
   
    ```bash
    flutter run
    # This command will run the project
    ```
. Use the interface to upload student essays in PDF format. You can upload multiple files at once.

### Setting the Marking Scheme

After uploading the essays, you'll be prompted to define your marking scheme. This could include criteria such as:

- **Content Accuracy**: Does the essay accurately represent the topic?
- **Argument Structure**: Is the argument logically structured and coherent?
- **Grammar and Spelling**: Are there any grammatical or spelling errors?
- **Referencing**: Are sources properly cited?

You can adjust the weight of each criterion according to its importance.

### Increasing Model Accuracy

To improve the accuracy of the AI grading, you can upload previously marked essays as examples. These examples will help the AI understand your specific marking preferences and criteria.

1. Select "Upload Examples" from the menu.
2. Upload the marked essays and their corresponding grades/comments.
3. The AI will use these examples to refine its grading process.

### Grading Essays

Once the essays and marking scheme are uploaded, GradingBot will begin the grading process:

1. The AI will assess each essay according to the provided marking scheme.
2. You can monitor the grading process in real-time.
3. The AI will generate detailed feedback and a grade/grading weights for each essay.

### Downloading Marked Essays

After grading is complete, you can download all marked essays in a single PDF file:

1. Select "Download All Marked Essays" from the menu.
2. The application will generate a PDF containing each essay, the grade, and the associated feedback/comments.

## Configuration

GradingBot is highly configurable. You can modify the following configurations in their associated areas:

- **API Key**: Your OpenAI API key. The settings page or can be hardcoded
- **Marking Scheme Defaults**: Set default marking criteria and their weights. Within a project - on the criteria tab.
- **AI Marking Model**: You can change the hardcoded model that the interface uses or the prompt (however i have refined this prompt to give **me** the best results) - This can be done on the  

## Limitations

- **AI Limitations**: While ChatGPT is a powerful tool, it may not perfectly replicate human judgment in all cases.
- **Training Requirements**: The quality of AI grading can be significantly improved with well-curated training examples. Insufficient or poor-quality examples may lead to less accurate grading.
- **API Costs**: Using the OpenAI API may incur costs depending on the number of essays and the complexity of the marking scheme.

## Contributing

We welcome contributions to GradingBot! If you'd like to contribute, please fork the repository and create a pull request with your changes. Make sure to follow the coding standards outlined in the contribution guidelines.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

GradingBot is designed to help educators save time and provide consistent, high-quality feedback to students. With its intuitive interface and AI-powered grading, it's a valuable tool for any classroom. Happy grading!

#### GradingBot is a tool designed to assist in the grading process by utilizing AI to provide feedback on student essays. While every effort has been made to ensure the accuracy and reliability of the tool, users are advised to use GradingBot at their own discretion. The creators of GradingBot do not guarantee that the feedback or grades generated by the AI will be free from errors or fully align with human judgment. Users are responsible for reviewing and verifying all outputs before applying them in any academic or professional context. The creators assume no liability for any consequences arising from the use of this tool. This was created by Alex Woodroof, as a second year university project at the University of Portsmouth, and as such is most likely not ready for practical use. By all means feel free to use it, just verify that you are content with output and consistency.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
