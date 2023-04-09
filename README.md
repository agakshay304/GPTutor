# GPTutor

# AITutor using ChatGPT API

This is an AI-based tutor application built using Flutter and the ChatGPT API. The application helps users learn about various topics and assess their knowledge through a quiz. The app first provides an overview of the topic and then asks questions related to it. If the user answers 2/3 questions correctly, they move on to the next topic. Otherwise, they have to reattempt the quiz.

The whole app is designed to provide a narrative experience where the user can learn and interact with voice. The AI-powered tutor guides the user through each topic with voiceovers, providing explanations and examples along the way. The user can also interact with the tutor by asking questions and getting immediate responses.

At the end of the quiz, the app displays a results page that shows the user's progress. Each topic's correct answer count is displayed with a pie chart.

## Requirements

To run this application, you will need the following:

- Flutter SDK
- ChatGPT API credentials (you can get them from OpenAI website)

## Installation

1. Clone this repository to your local machine.
2. Open the project in your preferred code editor.
3. Add your ChatGPT API credentials to the `lib/config.dart` file.
```dart
const openAIKey = 'YOUR_OPENAI_API_KEY';
```
4. Install the required dependencies by running `flutter pub get`.
5. Run the application using `flutter run`.

## Usage

1. Open the application on your device.
2. Choose a topic from the home screen.
3. Listen to the tutor's voiceover that provides an overview of the topic.
4. Take the quiz by answering the questions related to the topic.
5. If you answer 2/3 questions correctly, you will move on to the next topic. Otherwise, you will have to reattempt the quiz.
6. At any time, you can interact with the tutor by asking questions and getting immediate responses.
7. At the end of the quiz, the results page will show your progress and each topic's correct answer count with a pie chart.

## Limitations

- The AI tutor's responses are based on the data available in the ChatGPT API, so the quality of the answers may vary depending on the subject matter.
- The application currently supports only text-based questions and answers.
- The quiz format is fixed at 3 questions per topic.

## Future Work

- Add support for multimedia-based questions and answers.
- Allow users to choose the number of questions they want to answer in the quiz.
- Improve the AI tutor's accuracy by using more advanced natural language processing techniques.
- Allow users to rate the accuracy of the AI tutor's responses, which can help improve the model over time.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
