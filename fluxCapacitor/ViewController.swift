//
//  ViewController.swift
//  fluxCapacitor
//
//  Created by Tomas Novella on 1/6/16.
//  Copyright © 2016 Tomas Novella. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    internal var pocetStlaceni: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.rootViewController
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

