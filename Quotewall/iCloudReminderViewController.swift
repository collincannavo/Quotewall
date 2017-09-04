//
//  iCloudReminderViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 9/3/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class iCloudReminderViewController: UIViewController {

    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gradient.colors = [UIColor.gradientBlueColor.cgColor, UIColor.gradientGreenColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
    }

 
   
}
