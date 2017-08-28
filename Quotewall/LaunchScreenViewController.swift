//
//  LaunchScreenViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/18/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class LaunchScreenViewController: UIViewController {
    
    let cloudKitManager = CloudKitController()
    let gradient = CAGradientLayer()
    
    
    override func viewDidLoad() {
        
        
        gradient.colors = [UIColor.gradientBlueColor.cgColor, UIColor.gradientGreenColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        CloudKitController.shared.verifyCloudKitLogin { (success) in
            if success {
                self.fetchData()
            } else {
                self.performSegue(withIdentifier: "toDeadEnd", sender: self)
            }
        }
    }
    
    func fetchData() {
        CloudKitController.shared.fetchCurrentUser { (success, person) in
            if success {
                if person != nil {
                    CloudKitController.shared.fetchQuotewalls(completion: { (success) in
                        if success {
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Constants.currentQuotewallFetchedNotification, object: self)
                            }
                        }
                    })
                    
                    CloudKitController.shared.fetchCurrentQuotewall(completion: { (success, quotewall) in
                        if success {
                            DispatchQueue.main.async {
                                
                            }
                        }
                    
                    CloudKitController.shared.fetchCurrentQuotewallQuotes(completion: { (success) in
                        if success {
                            DispatchQueue.main.async {
                                
                            }
                        }
                    })
                        
                        self.performSegue(withIdentifier: "toSharedQuotes", sender: self)
                        
                        
                    })
                } else {
                    CloudKitController.shared.createUser(with: "DefaultName", completion: { (_) in
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Constants.sharedQuotesFetchedNotification, object: self)
                            
                            self.performSegue(withIdentifier: "toSharedQuotes", sender: self)
                        }
                        
                    })
                }
            }
            
        }
    }
}
