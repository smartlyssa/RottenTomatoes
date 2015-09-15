//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Lyssa on 9/12/15.
//  Copyright © 2015 thegeekgoddess.net. All rights reserved.
//

import UIKit
import AFNetworking
import KVNProgress


private let CELL_NAME = "net.thegeekgoddess.rottentomatoes.moviecell"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var errorView: UIView!
    @IBOutlet var networkErrorLabel: UILabel!
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var movies: NSArray?
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {

        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.movieTableView.addSubview(refreshControl)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
//        cell.textLabel?.text = "\(indexPath.row)"
        
        let movieDictionary = movies![indexPath.row] as! NSDictionary
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME) as! MovieCell
        cell.movieTitleLabel.text = movieDictionary["title"] as? String
        cell.movieDescriptionLabel.text = movieDictionary["synopsis"] as? String

        let url = NSURL(string: movieDictionary.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        NSLog("TableView? \(movieTableView.frame)")
        
//        let RottenTomatoesURLString = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
        
//        let request = NSMutableURLRequest(URL: NSURL(string:RottenTomatoesURLString)!)
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data , response, error ) -> Void in
//            if let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.movies = dictionary["movies"] as? NSArray
//                    self.movieTableView.reloadData()
//                }
////                NSLog("\(dictionary)")
//            } else {
//            
//            }
//        }
//        
//        task.resume()
        
        refresh(self)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        NSLog("movie cell is clicked")
        
        let cell = sender as! UITableViewCell
        let indexPath = movieTableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetaisViewController
        movieDetailsViewController.movie = movie as! NSDictionary
        
        KVNProgress.show()
        
    }
    
    func refresh(sender:AnyObject) {
        
        KVNProgress.show()
        
        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request,queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            
            if let error = error {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.errorView.hidden = true
                    self.errorView.backgroundColor = UIColor.blackColor()
                    self.networkErrorLabel.backgroundColor = UIColor.whiteColor()
                    self.networkErrorLabel.text = "Network Error!"
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.movies = responseDictionary["movies"] as? NSArray
                NSLog("Count \(responseDictionary.count)")
                self.movieTableView.reloadData()
                
            }
            
            NSLog("Errors?:\(error?.localizedDescription)")
            NSLog("\(responseDictionary)")
            
        }
        
        // Simulate API loading
        delay(2, closure: {
            self.refreshControl.endRefreshing()
            KVNProgress.dismiss()
        })
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
}

class MovieCell:UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
}

