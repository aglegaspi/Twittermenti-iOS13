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
    
    let swifter = Swifter(consumerKey: S.apikey, consumerSecret: S.apisecret)
    
    let sentimentClassifier: TweetSentimentClassifier = {
        do {
            let config = MLModelConfiguration()
            return try TweetSentimentClassifier(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create TweetSentimentClassifier")
        }
    }()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prediction = try! sentimentClassifier.prediction(text: "@apple is a great company")
        print(prediction.label)
        
        
        swifter.searchTweet(using: "@apple", // <-- this will change to be set to the user input from textField
                            lang: "en", // only return English results to this API call
                            count: 100, // the aount of results we expect from the search
                            tweetMode: .extended, // allows us to retreive the full text from the tweet
                            success: { (results, metadata) in
            
            // set this array to TSCI objects to pass in the classifers predictions expected type
            var tweets = [TweetSentimentClassifierInput]()
            
            for i in 0..<100 {
                if let tweet = results[i]["full_text"].string {
                    
                    // turns each tweet into the expected type for the array in order to append
                    let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                    tweets.append(tweetForClassification)
                }
            }
            do {
                
                // pass in array of TweetSentimentClassifierInput objects and if successful store data in predictions array
                let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                
                // loops through the predictions array and on each prediction objecet print the value of the label property
                for prediction in predictions {
                    print(prediction.label)
                }
            } catch {
                print("Error making prediction: \(error)")
            }
            
            
            //print(results)
        }) { (error) in
            print("Error w/Twitter API request: \n \(error)")
        }
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

