//
//  MovieDetaisViewController.swift
//  RottenTomatoes
//
//  Created by Lyssa Laudencia on 9/14/15.
//  Copyright © 2015 thegeekgoddess.net. All rights reserved.
//

import UIKit


class MovieDetaisViewController: UIViewController {

    @IBOutlet var posterDetailView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var synopsisLabel: UILabel!
    
    var movie: NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        var url = movie.valueForKeyPath("posters.thumbnail")
//        NSLog("url: \(url)")
        
        // Codepath Hack
        let range = url?.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            url = url!.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        let imageUrl = NSURL(string: url as!  String)!
//        NSLog("image url: \(imageUrl)")
//        
//        if (url as! String == imageUrl) {
//            NSLog("the links are the same!")
//        } else {
//            NSLog("the links are different!")
//        }
        
        posterDetailView.setImageWithURL(imageUrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


//     MARK: - Navigation
//
//     In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         Get the new view controller using segue.destinationViewController.
    
//         Pass the selected object to the new view controller.
//    }


}
