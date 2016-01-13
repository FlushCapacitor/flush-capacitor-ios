//
//  TodayViewController.swift
//  flushForiOS
//
//  Created by Tomas Novella on 1/6/16.
//  Copyright © 2016 Tomas Novella. All rights reserved.
//

import UIKit
import NotificationCenter
import Foundation


class TodayViewController: UIViewController, NCWidgetProviding {
    var toilet = ToiletStatus()
    
    let kColorUnknown = UIColor(white: 0.7, alpha: 1.0)
    let kColorOccupied = UIColor(hue: 0/360.0, saturation: 0.7, brightness: 0.9, alpha: 1.0)
    let kColorAvailable = UIColor(hue: 120/360.0, saturation: 0.7, brightness: 0.9, alpha: 1.0)
    
    var timer:NSTimer?
    
    func paint(button: UIView?, receivedStatus status: Bool? ) {
        if let s = status {
            if (s) {
                button?.backgroundColor = kColorOccupied
            } else {
                button?.backgroundColor = kColorAvailable
            }
        } else {
            button?.backgroundColor = kColorUnknown
        }
        
    }
    
    func displayStatus() {
        let statuses  = toilet.getStatuses()
        paint(LeftStatus, receivedStatus: statuses["L"])
        paint(RightStatus, receivedStatus: statuses["R"])
        
        print ("testStatus-> \(toilet.getStatuses())")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayStatus()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "displayStatus", userInfo:nil, repeats: true)

        RightStatus.backgroundColor = kColorUnknown
        LeftStatus.backgroundColor = kColorUnknown
		preferredContentSize = CGSizeMake(0, 50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    

    @IBOutlet var LeftStatus: UIView!
    @IBOutlet var RightStatus: UIView!
    
}
