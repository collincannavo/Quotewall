//
//  SharedQuotesViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit
import ContactsUI

class SharedQuotesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CNContactPickerDelegate {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var sharedCollectionView: UICollectionView!
    
    @IBAction func addContactsButtonTapped(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    let gradient = CAGradientLayer()
    var sharedQuotes: [SharedQuote]? {
        didSet {
           self.sharedCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedCollectionView.delegate = self
        sharedCollectionView.dataSource = self
        
        fetchSharedQuotes()
        gradient.colors = [UIColor.gradientBlueColor.cgColor, UIColor.gradientGreenColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
        
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        tabBarController?.tabBar.backgroundColor = UIColor.clear
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let sharedQuotes = self.sharedQuotes?[indexPath.row] else { return QuotesCollectionViewCell() }
        
        guard let cell = self.sharedCollectionView.dequeueReusableCell(withReuseIdentifier: "sharedQuote", for: indexPath) as? QuotesCollectionViewCell else { return QuotesCollectionViewCell() }
        
        cell.authorNameLabel.text = sharedQuotes.name
        cell.quoteTextLabel.text = sharedQuotes.quote
        cell.titleLabel.text = sharedQuotes.title

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let sharedQuotes = sharedQuotes?.count else { return 0 }
        
        return sharedQuotes
    }
    
    // MARK: - Contact Picker Delegate Method
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        let contactsDispatchGroup = DispatchGroup()
        
        let phoneNumberDispatchGroup = DispatchGroup()
        
        contacts.forEach { contact in
            
            contactsDispatchGroup.enter()

            PersonController.shared.currentPerson?.followedUserNames.append(contact)
            
            for number in contact.phoneNumbers {
                
                phoneNumberDispatchGroup.enter()
     
                
                let phoneNumber = number.value.stringValue
                
                CloudKitController.shared.createFollowedUsers(with: phoneNumber, completion: { (success) in
                    if !success {
                        
                        
                    }
                    phoneNumberDispatchGroup.leave()

                })
            }
            
            phoneNumberDispatchGroup.notify(queue: DispatchQueue.main, execute: {
                contactsDispatchGroup.leave()

            })
            
        }
        
        contactsDispatchGroup.notify(queue: DispatchQueue.main) {

            
            guard let currentPerson = PersonController.shared.currentPerson?.ckRecord else { return }
            
            CloudKitController.shared.updateRecord(currentPerson) { (ckRecords, ckRecordID, error) in
                
                if let error = error {
                    NSLog("There was an error updating the current record: \(error.localizedDescription)")
                    
                }
                
            }
            
        }
    }
    
    func fetchSharedQuotes() {
        
        guard let currentPerson = PersonController.shared.currentPerson
            else { return }
        
        CloudKitController.shared.fetchSharedQuotes(for: currentPerson) { (success, sharedQuotes) in
            if success {
                DispatchQueue.main.async {
                    self.sharedQuotes = sharedQuotes
                }
            }
        }
    }
}
