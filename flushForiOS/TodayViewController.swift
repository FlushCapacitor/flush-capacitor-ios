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
    
    let kColorUnknown = UIColor.lightGrayColor()
    let kColorOccupied = UIColor(hue: 0/360.0, saturation: 0.7, brightness: 0.9, alpha: 1.0)
    let kColorAvailable = UIColor(hue: 120/360.0, saturation: 0.7, brightness: 0.9, alpha: 1.0)
    let kColorTest = UIColor(hue: 160/360.0, saturation: 0.7, brightness: 0.9, alpha: 1.0)
    var timer:NSTimer?
    
    func paint(button: UIView?, receivedStatus status: Bool? ) {
        guard let _ = button?.backgroundColor else {
            print("ininitialized")
            return
        }
        
        guard let s = status else {
            button?.backgroundColor = kColorUnknown
            return
        }
        
        if (s) {
            button?.backgroundColor = kColorAvailable
        } else {
        	button?.backgroundColor = kColorOccupied
        }
    }

    func displayStatus(statuses:[String:Bool]) {
        paint(LeftStatus, receivedStatus: statuses["L"])
        paint(RightStatus, receivedStatus: statuses["R"])
    }
    
    func fetchStatuses() {
        dispatch_async(dispatch_get_main_queue()) {
        	self.toilet.updateStatuses(self.displayStatus)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		preferredContentSize = CGSizeMake(0, 50)
        RightStatus.layer.borderWidth = CGFloat(2)
        LeftStatus.layer.borderWidth = CGFloat(2)

        fetchStatuses()
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "fetchStatuses", userInfo:nil, repeats: true)
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
