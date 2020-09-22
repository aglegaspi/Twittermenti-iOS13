import Cocoa
import CreateML

// location of where our data exists. the entire file path.
let url = URL(fileURLWithPath: "/Volumes/LEXPORT/Developer/iOS13-Course-Angela-Yu/Twittermenti-iOS13/twitter-sanders-apple3.csv")

// data can be imported from a JSON or a CSV data format. if we try to convert a file to a MLDataTable (JSON, CSV) we need a "try" to handle whether it can or not.
let data = try MLDataTable(contentsOf: url)

// made for MLDataTable spits data set in 80/20 (trainingData/testingData). this is only available for CreateML.
// 0.8 represents 80%. a seed relates to how random number generaters works.
// Creates two mutually exclusive, randomly divided subsets of the table.
let(trainingData,testingData) = data.randomSplit(by: 0.8, seed: 5)
//print(testingData.description)

// the MLTextClassifier with train up by using out trainingData the sentimentClassifier then becomes our ML Model
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

// metric to figure out the accuracy
let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")
//print(evaluationMetrics.classificationError)

// the fraction of examples that were incorrectly labeled by this model.
// example if you had 90% -> 0.9
let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

let metadata = MLModelMetadata(author: "Alex", shortDescription: "model trained to classify sentiment of Tweets", version: "1.0")

// create the MLMODEL in the location we desire.
try sentimentClassifier.write(to: URL(fileURLWithPath: "/Volumes/LEXPORT/Developer/iOS13-Course-Angela-Yu/Twittermenti-iOS13/TweetSentimentClassifier.mlmodel"))

try sentimentClassifier.prediction(from: "@apple is a terrible company")
try sentimentClassifier.prediction(from: "@apple is an amazing company")
try sentimentClassifier.prediction(from: "@apple is a company")
