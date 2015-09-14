//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Lyssa on 9/12/15.
//  Copyright © 2015 thegeekgoddess.net. All rights reserved.
//

import UIKit
import AFNetworking

private let CELL_NAME = "net.thegeekgoddess.rottentomatoes.moviecell"

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var movies: NSArray?

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
        
//        let doraURL = "http://kidtivity.com/wp-content/uploads/2015/08/Dora_backpack-running.jpeg"
//        cell.posterView.setImageWithURL(NSURL(string: doraURL as String)!)
        let url = NSURL(string: movieDictionary.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("TableView? \(movieTableView.frame)")
        
        let RottenTomatoesURLString = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
        
        let request = NSMutableURLRequest(URL: NSURL(string:RottenTomatoesURLString)!)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data , response, error ) -> Void in
            if let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                dispatch_async(dispatch_get_main_queue()) {
                    self.movies = dictionary["movies"] as? NSArray
                    self.movieTableView.reloadData()
                }
                NSLog("\(dictionary)")
            } else {
            
            }
        }
        task.resume()
        
    }    
}

class MovieCell:UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
}

