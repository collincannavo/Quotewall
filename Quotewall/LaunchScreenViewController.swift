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

class LaunchScreenViewController: UIViewController, UITextFieldDelegate {
    
    let cloudKitManager = CloudKitController()
    let gradient = CAGradientLayer()
    let person = PersonController()
    var cellTextField = UITextField()
    
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
                self.iCloudReminder()
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
                    
                    DispatchQueue.main.async {
                        
                        self.performSegue(withIdentifier: "toSharedQuotes", sender: self)
                    }
                    
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        self.createUser()
                    }
                
                }
            }
        }
    }
    
    
    func createUser() {
        
        var phoneNumberTextField: UITextField?
        
        let alert = UIAlertController(title: "Please Enter Your Phone Number", message: "This will allow your friends and family to follow any quotes you want to share", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            phoneNumberTextField = textField
            textField.delegate = self
            self.cellTextField = textField
            phoneNumberTextField?.placeholder = "Phone Number"
            phoneNumberTextField?.keyboardType = .phonePad
        }
        
        let okAction = UIAlertAction(title: "Save", style: .default, handler: { (phoneNumber) in
            
            guard let phoneNumber = phoneNumberTextField?.text
                else { return }
            
            self.cloudKitManager.createUser(with: "DefaultName", phone: phoneNumber, completion: { (_) in
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "toSharedQuotes", sender: self)
                }
            })
        })

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cellTextField = textField.text, !cellTextField.isEmpty else { return }
        textField.resignFirstResponder()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if self.cellTextField == textField {
            textField.text = lastText.format("(NNN) NNN-NNNN", oldString: text)
            return false
        }
        return true
    }
    
    func iCloudReminder() {
        let alert = UIAlertController(title: "Please Log into iCloud", message: "Please check you Settings and ensure you sign into iCloud before you can access Quotewall", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
