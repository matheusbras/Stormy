//
//  ViewController.swift
//  Stormy
//
//  Created by Matheus Bras on 19/09/14.
//  Copyright (c) 2014 Matheus Bras. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiKey = "b18be53daa84b744cc8ca39a9a5fcf7e"
    @IBOutlet var icon: UIImageView!
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var precipitation: UILabel!
    @IBOutlet var summary: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "37.8267,-122.423", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as NSDictionary

                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.icon.image = currentWeather.icon!
                    self.currentTime.text = "At \(currentWeather.currentTime!) It is"
                    self.temperature.text = String(currentWeather.temperature)
                    self.humidity.text = NSString(format: "%.2f", currentWeather.humidity)
                    self.precipitation.text = NSString(format: "%.2f", currentWeather.precipProbability)
                    self.summary.text = currentWeather.summary
                })
            }
            
        })
        
        downloadTask.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

