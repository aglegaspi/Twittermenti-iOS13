import Cocoa
import CreateML

let url = URL(fileURLWithPath: "/Volumes/LEXPORT/Developer/iOS13-Course-Angela-Yu/Twittermenti-iOS13/twitter-sanders-apple3.csv")
let data = try MLDataTable(contentsOf: url)

// made for MLDataTable spits data in 80/20 (training/data)
let(trainingData,testingData) = data.randomSplit(by: 0.8, seed: 5)

// the MLTextClassifier with train up by using out trainingData the sentimentClassifier then becomes our ML Model
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")

let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

