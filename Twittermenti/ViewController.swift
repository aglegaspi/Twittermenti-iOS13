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

class ViewController: UIViewController {
    
    let swifter = Swifter(consumerKey: S.apikey, consumerSecret: S.apisecret)
    let sentimentClassifier = TweetSentimentClassifier()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prediction = try! sentimentClassifier.prediction(text: "@apple is a great company")
        print(prediction.label)
        
        swifter.searchTweet(using: "@apple", lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
            //print(results)
        }) { (error) in
            print("Error w/Twitter API request: \n \(error)")
        }
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

