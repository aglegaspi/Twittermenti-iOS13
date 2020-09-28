//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    //MARK: - PROPERTIES
    
    // instance of the SwifteriOS framework that acts like a wrapper around the Twitter API making it easier to access endpoints
    let swifter = Swifter(consumerKey: S.apikey, consumerSecret: S.apisecret)
    
    // create a machine learning model with the TweetSentimentClassifier model
    let sentimentClassifier: TweetSentimentClassifier = {
        do {
            let config = MLModelConfiguration()
            return try TweetSentimentClassifier(configuration: config)
        } catch {
            fatalError("Couldn't create TweetSentimentClassifier: \(error)")
        }
    }()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - METHODS
    
    @IBAction func predictPressed(_ sender: Any) {
        fetchTweets()
    }
    
    func fetchTweets() {
        if let searchText = textField.text {
            let prediction = try! sentimentClassifier.prediction(text: "@apple is a great company")
            print(prediction.label)
            
            swifter.searchTweet(using: searchText, // user input
                                lang: "en", // only return English results to this API call
                                count: K.tweetCount, // the aount of results we expect from the search
                                tweetMode: .extended, // allows us to retreive the full text from the tweet
                                success: { (results, metadata) in
                                    
                                    // set this array to TSCI objects to pass in the classifers predictions expected type
                                    var tweets = [TweetSentimentClassifierInput]()
                                    
                                    for i in 0..<K.tweetCount {
                                        if let tweet = results[i]["full_text"].string {
                                            
                                            // turns each tweet into the expected type for the array in order to append
                                            let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                                            tweets.append(tweetForClassification)
                                        }
                                    }
                                    
                                    self.makePrediction(with: tweets)
                
                                }) { (error) in
                print("Error w/Twitter API request: \n \(error)")
            }
        }
    }
    
    func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        do {
            
            // pass in array of TweetSentimentClassifierInput objects and if successful store data in predictions array
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            
            var sentimentScore = 0
            
            // loops through the predictions array and on each prediction objecet print the value of the label property
            for prediction in predictions {
                let sentiment = prediction.label
                
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            
            self.updateUI(with: sentimentScore)
            
        } catch {
            print("Error making prediction: \(error)")
        }
    }
    
    func updateUI(with sentimentScore: Int) {
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😀"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        }  else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
    
}

