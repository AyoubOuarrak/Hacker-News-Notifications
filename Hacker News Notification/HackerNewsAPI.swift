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
    
    func HackerNewsAPI() {
        notification.title = "Hacker News"
    }
    
    func getStories(stories: String) {
        let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/\(stories).json")
        let task = session.dataTaskWithURL(url!) { data, response, err in
            
            if let error = err {
                NSLog("api error: \(error)")
            }
            
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    self.topStories = self.storiesFromJSONData(data!)!
                    switch stories {
                        case "beststories":
                            self.notification.informativeText = "Best Stories updated!"
                        
                        case "topstories":
                            self.notification.informativeText = "Top Stories updated!"
                        
                        case "newstories":
                            self.notification.informativeText = "New Stories updated!"
                       
                        default:
                            self.notification.informativeText = "Stories updated!"
                    }
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    
                case 401:
                    self.notification.informativeText = "Cannot get last top stories"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    NSLog("api returned an 'unauthorized' response. Did you set your API key?")
                
                default:
                    self.notification.informativeText = "Cannot get last top stories"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    NSLog("api returned response: %d %@", httpResponse.statusCode, NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    func storiesFromJSONData(data: NSData) -> [Int]? {
        var stories = [Int]()
        
        do {
            stories = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [Int]
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        return stories
    }
    
    func storyFromJSONData(data: NSData) -> Story? {
        let json : [String:AnyObject]
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        let story = Story(
            title: json["title"] as! String,
            url: json["url"] as! String,
            score: json["score"] as! Int
        )
        
        return story

    }
    
    func showRandomStory() {
        let randomStory = topStories[Int(arc4random_uniform(UInt32(topStories.count)))]
        let urlStory = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/\(randomStory).json?print=pretty")
        
        
        let task = session.dataTaskWithURL(urlStory!) { data, response, err in
            if let error = err {
                NSLog("api error: \(error)")
            }
            
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    let story = self.storyFromJSONData(data!)!
                    self.notification.title = "\(story.title)"
                    self.notification.informativeText = "\(story.url)"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    
                case 401:
                    self.notification.informativeText = "Cannot get last top stories"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    NSLog("api returned an 'unauthorized' response. Did you set your API key?")
                    
                default:
                    self.notification.informativeText = "Cannot get last top stories"
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(self.notification)
                    NSLog("api returned response: %d %@", httpResponse.statusCode, NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
}