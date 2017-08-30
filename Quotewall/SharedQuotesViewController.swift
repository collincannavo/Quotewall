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
    
    
    @IBOutlet weak var sharedCollectionView: UICollectionView!
    
    @IBAction func addContactsButtonTapped(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    var sharedQuotes: [SharedQuote]? {
        didSet {
           self.sharedCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        fetchSharedQuotes()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let sharedQuotes = self.sharedQuotes?[indexPath.row] else { return SharedQuoteCollectionViewCell() }
        
        guard let cell = self.sharedCollectionView.dequeueReusableCell(withReuseIdentifier: "sharedCell", for: indexPath) as? SharedQuoteCollectionViewCell else { return SharedQuoteCollectionViewCell() }
        
        cell.authorLabel.text = sharedQuotes.name
        cell.quoteLabel.text = sharedQuotes.quote
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let sharedQuotes = sharedQuotes?.count else { return 0 }
        
        return sharedQuotes
    }
    
    // MARK: - Contact Picker Delegate Method
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        let contactsDispatchGroup = DispatchGroup()
        
        var contactsCount = 0
        
        let phoneNumberDispatchGroup = DispatchGroup()
        var contactsPhoneCount = 0
        
        contacts.forEach { contact in
            
            contactsDispatchGroup.enter()
            contactsCount += 1
            print(contactsCount)
            
            for number in contact.phoneNumbers {
                
                phoneNumberDispatchGroup.enter()
                contactsPhoneCount += 1
                print(contactsPhoneCount)
                
                let phoneNumber = number.value.stringValue
                
                CloudKitController.shared.createFollowedUsers(with: phoneNumber, completion: { (success) in
                    if !success {
                        
                    // Append the reference to whomever
                    }
                    phoneNumberDispatchGroup.leave()
                    contactsPhoneCount -= 1
                    print(contactsPhoneCount)
                })
            }
            
            phoneNumberDispatchGroup.notify(queue: DispatchQueue.main, execute: { 
                contactsDispatchGroup.leave()
                contactsCount -= 1
                print(contactsCount)
            })
        
        }
        
        contactsDispatchGroup.notify(queue: DispatchQueue.main) {
                self.sharedCollectionView.reloadData()
            
            guard let currentPerson = PersonController.shared.currentPerson?.ckRecord else { return }
            
            CloudKitController.shared.updateRecord(currentPerson) { (ckRecords, ckRecordID, error) in
                
                if let error = error {
                    NSLog("There was an error updating the current record: \(error.localizedDescription)")
                    
                }
                
            }
            
        }
    }
    
    
    func fetchSharedQuotes() {
        
        guard let currentPerson = PersonController.shared.currentPerson else { return }
        
        CloudKitController.shared.fetchSharedQuotes(for: currentPerson) { (success, sharedQuotes) in
            if success {
                DispatchQueue.main.async {
                    self.sharedQuotes = sharedQuotes
                }
            }
        }
    }
}
