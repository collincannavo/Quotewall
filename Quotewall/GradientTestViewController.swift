//
//  GradientTestViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/28/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class GradientTestViewController: UIViewController {

    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let blue = UIColor(red: 48/255.0, green: 62/255.0, blue: 103/255.0, alpha: 1.0)
        let orange = UIColor(red: 244/255.0, green: 88/255.0, blue: 53/255.0, alpha: 1.0)
        let pink = UIColor(red: 196/255.0, green: 70/255.0, blue: 107/255.0, alpha: 1.0)
        gradient.colors = [blue.cgColor, pink.cgColor, orange.cgColor]
        gradient.locations = [0.0, 0.75, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x:1.0, y:0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
