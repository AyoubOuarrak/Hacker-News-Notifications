//
//  HackerNewsAPI.swift
//  Hacker News Notification
//
//  Created by Ayoub Ouarrak on 28/05/2016.
//  Copyright © 2016 Ayoub Ouarrak. All rights reserved.
//

import Foundation

struct Story {
    var title: String
    var url: String
    var score:Int
}

class HackerNewsAPI {
    let notification = NSUserNotification.init()
    let session = NSURLSession.sharedSession()
    var topStories = [Int]()
    
    /*
     *  get array of stories from hacker news 
     */
    func getStories(stories: String) {
        // uri for the stories hacker news json
        let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/\(stories).json")
        let task = session.dataTaskWithURL(url!) { data, response, err in
            if let error = err {
                NSLog("api error: \(error)")
            }
            
            // get a response
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                // response ok
                case 200:
                    // save the stories json into an array
                    self.topStories = self.storiesFromJSONData(data!)!
                    
                    // show a notification that we get the stories
                    switch stories {
                        case "beststories":
                            self.notification.title = "Hacker News"
                            self.notification.informativeText = "Best Stories updated!"
                        
                        case "topstories":
                            self.notification.title = "Hacker News"
                            self.notification.informativeText = "Top Stories updated!"
                        
                        case "newstories":
                            self.notification.title = "Hacker News"
                            self.notification.informativeText = "New Stories updated!"
                       
                        default:
                            self.notification.title = "Hacker News"
                            self.notification.informativeText = "Stories updated!"
                    }
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    
                // bad responses
                case 401:
                    self.notification.title = "Hacker News"
                    self.notification.informativeText = "Cannot get last top stories"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    NSLog("api returned an 'unauthorized' response. Did you set your API key?")
                
                default:
                    self.notification.title = "Hacker News"
                    self.notification.informativeText = "Cannot get last top stories"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    NSLog("api returned response: %d %@", httpResponse.statusCode, NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    /*
     *  parse the stories array json and return an array of story ids
     */
    func storiesFromJSONData(data: NSData) -> [Int]? {
        var stories = [Int]()
        
        do {
            // try to parse the json
            stories = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [Int]
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        return stories
    }
    
    /*
     *  parse a story json and return a structure of type story that contain title, url and score
     */
    func storyFromJSONData(data: NSData) -> Story? {
        let json : [String:AnyObject]
        
        do {
            // try to parse the json story
            json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        // save the json into a story structure
        let story = Story(
            title: json["title"] as! String,
            url: json["url"] as! String,
            score: json["score"] as! Int
        )
        
        return story
    }
    
    /*
     *  return a random story from the array of stories 
     */
    func showRandomStory() {
        // generate a random number between 0 and the size of stories array
        let randomStory = topStories[Int(arc4random_uniform(UInt32(topStories.count)))]
        
        // get the random story json
        let urlStory = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/\(randomStory).json?print=pretty")
        
        let task = session.dataTaskWithURL(urlStory!) { data, response, err in
            if let error = err {
                NSLog("api error: \(error)")
            }
            
            // parse the response
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                // response ok
                case 200:
                    // save the url so it can be used to open the story in the default browser
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let story = self.storyFromJSONData(data!)!
                    defaults.setValue(story.url, forKey: "storyUrl")
                    
                    // show a notification with the title and the url of the story
                    self.notification.title = "\(story.title)"
                    self.notification.informativeText = "\(story.url)"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    
                // bad responses
                case 401:
                    self.notification.title = "Hacker News"
                    self.notification.informativeText = "Cannot get last stories"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    NSLog("api returned an 'unauthorized' response. Did you set your API key?")
                    
                default:
                    self.notification.title = "Hacker News"
                    self.notification.informativeText = "Cannot get last stories"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    NSLog("api returned response: %d %@", httpResponse.statusCode, NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
}