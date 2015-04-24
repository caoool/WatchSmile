//
//  ViewController.swift
//  WatchSmile
//
//  Created by Lu Cao on 4/18/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, MWFeedParserDelegate {

    @IBOutlet weak var jokeLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var parsedItems = [MWFeedItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        parse()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func parse() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.beginParsing()
        }
    }
    
    
    func beginParsing() {
        
        // Create feed parser and pass the URL of the feed
        let feedURL = NSURL(string: "feed://www.jokesareawesome.com/rss/random/")
        let feedParser = MWFeedParser(feedURL: feedURL)
        
        // Delegate must conform to `MWFeedParserDelegate`
        feedParser.delegate = self;
        
        // Parse the feeds info
        feedParser.feedParseType = ParseTypeFull;
        
        // Connection type
        feedParser.connectionType = ConnectionTypeSynchronously;
        
        // Begin parsing
        feedParser.parse()
    }

    @IBAction func buttonClicked() {
        parse()
    }

    func feedParserDidStart(parser: MWFeedParser!) {
        println("Started Parsing: \(parser.url)")
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        println("Parsed Feed Info: \(info.title)")
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        println("Parsed Feed Item: \(item.title)")
        parsedItems.append(item)
        println("Title: \(item.title)")
        println("Link: \(item.link)")
        println("Summary: \(item.summary)")
        println("Content: \(item.content)")
        println("Identifier: \(item.identifier)")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.jokeLabel.text = item.summary.stringByConvertingHTMLToPlainText()
            self.button.setTitle("Next Smile! 😆", forState: .Normal)
        }
        
        
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        println("Finished Parsing: \(parsedItems.count) items parsed")
    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        println("Finished Parsing With Error: \(error)")
        dispatch_async(dispatch_get_main_queue()) {
            self.jokeLabel.text = "Opps, the connection seems lost"
            self.button.setTitle("Refresh", forState: .Normal)
        }
        
    }
}
