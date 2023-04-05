class Topic {
  String name;
  List<String> questions;

  Topic(this.name, this.questions);
}

final List<Topic> topics = [
  Topic("Intro to ML training", [
    "What is ML?",
    "What is the difference between supervised and unsupervised learning?",
    "What is the difference between classification and regression?",
  ]),
  Topic("Steps in Training", [
    "What is the difference between training and testing?",
    "What is the difference between validation and cross-validation?no",
    "What is the difference between precision and recall?",
  ]),
  Topic("Data Collection", [
    "What is the difference between data and information?",
    "What is the difference between structured and unstructured data?",
    "What is Data Mining?",
  ]),
  Topic("Preprocessing", [
    "What is Preprocessing?",
    "What is the difference between feature engineering and feature selection?",
    "What is the difference between feature scaling and normalization?",
  ]),
  Topic("Training",[
    "What is the difference between training and testing?",
    "What is the difference between validation and cross-validation?",
    "What is the difference between precision and recall?",
    "What is the difference between accuracy and F1 score?",
    "What is the difference between precision and recall?",
    "What is the difference between accuracy and F1 score?",
  ]),
];