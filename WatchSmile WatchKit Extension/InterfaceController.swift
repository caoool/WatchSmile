//
//  InterfaceController.swift
//  Watch, Smile WatchKit Extension
//
//  Created by Lu Cao on 4/13/15.
//  Copyright (c) 2015 LoopCowStudio. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, MWFeedParserDelegate {
    
    var dateFormatter : NSDateFormatter {
        let dateFmt = NSDateFormatter()
        dateFmt.dateStyle = .MediumStyle
        dateFmt.timeStyle = .NoStyle
        return dateFmt
    }
    
    @IBOutlet weak var jokeLabel: WKInterfaceLabel!
    @IBOutlet weak var button: WKInterfaceButton!
    
    var parsedItems = [MWFeedItem]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        parse()
        
        
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
    
    @IBAction func nextJoke() {
        parse()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
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
            self.jokeLabel.setText(item.summary.stringByConvertingHTMLToPlainText())
            self.button.setTitle("Next Smile! 😆")
        }
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        println("Finished Parsing: \(parsedItems.count) items parsed")
    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        println("Finished Parsing With Error: \(error)")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.jokeLabel.setText("Opps, the connection seems lost")
            self.button.setTitle("Refresh")
        }
    }
    
}
