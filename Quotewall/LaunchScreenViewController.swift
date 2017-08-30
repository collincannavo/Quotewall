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
    let person = PersonController()
    
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

                    })
                    
                    CloudKitController.shared.fetchCurrentQuotewall(completion: { (success, quotewall) in

                        })
                        
                    
                    CloudKitController.shared.fetchCurrentQuotewallQuotes(completion: { (success) in

                    })
                    
                    self.performSegue(withIdentifier: "toSharedQuotes", sender: self)
                    
                } else {
                    
                    self.createUser()
                
                }
            }
        }
    }
    
    
    func createUser() {
        
        var phoneNumberTextField: UITextField?
        
        let alert = UIAlertController(title: "Please Enter Your Phone Number", message: "This will allow your friends and family to follow any quotes you want to share", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            phoneNumberTextField = textField
            phoneNumberTextField?.placeholder = "Phone Number"
            phoneNumberTextField?.keyboardType = .phonePad
        }
        
        let okAction = UIAlertAction(title: "Save", style: .default, handler: { (phoneNumber) in
            
            guard let phoneNumber = phoneNumberTextField?.text
                else { return }
            
            self.cloudKitManager.createUser(with: "DefaultName", phone: phoneNumber, completion: { (_) in
                
                self.performSegue(withIdentifier: "toSharedQuotes", sender: self)
            })
        })

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}
