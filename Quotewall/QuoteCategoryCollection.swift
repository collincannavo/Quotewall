//
//  QuoteCategoryCollection.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class QuoteCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    let gradient = CAGradientLayer()
    let longGesture = UILongPressGestureRecognizer()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var quoteCategoryCollection: UICollectionView!
    
    
    
    // MARK: - Actions
    
    @IBAction func addQuotewallButtonTapped(_ sender: Any) {
        createQuotewallTitle()
    }
    
    // MARK: - CollectionView Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuotewalls { (_) in
        self.quoteCategoryCollection.reloadData()
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self as? UIGestureRecognizerDelegate
        longPress.delaysTouchesBegan = true
        self.quoteCategoryCollection?.addGestureRecognizer(longPress)
    
        gradient.colors = [UIColor.gradientBlueColor.cgColor, UIColor.gradientGreenColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
        
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        
    }
    
    func refresh() {
        self.quoteCategoryCollection.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return QuotewallController.shared.quotewalls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let quotewall = QuotewallController.shared.quotewalls[indexPath.row]
        
        let newQuotewall = quotewall
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quoteCategoryCollectionCell", for: indexPath) as? CategoryCollectionViewCell else { return CategoryCollectionViewCell() }
        
        cell.quotewallTitle.text = newQuotewall.category
        
        cell.quotewall = quotewall
        
        return cell
    }
    
    // MARK: - Alert
    
    func quoteActions(image: Data?) {
        let alert = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        
        let addBackgroundImageButton = UIAlertAction(title: "Add Background Image", style: .default) { (backgroundImage) in
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(addBackgroundImageButton)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }

    
    // MARK: - Long Gesture Press Function
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .ended {
            return
        }
        
        let p = gesture.location(in: self.quoteCategoryCollection)
        
        if let indexPath = self.quoteCategoryCollection.indexPathForItem(at: p) {
            
            let cell = QuotewallController.shared.quotewalls[indexPath.row]
            
            let image = cell.backgroundImage
            
            quoteActions(image: image)
        } else {
            NSLog("Couldn't find the right index path")
        }
        
    }
    
    // MARK: - Create Quotewall title
    
    func createQuotewallTitle() {
        
        var quotewallTitle: UITextField?
        
        let alertController = UIAlertController(title: "Let's Do This!", message: "What would you like for your Quotewall title (e.g. Funny, Work, Family)?", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            quotewallTitle = textField
            quotewallTitle?.placeholder = "Title of Quotewall"
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
           
           
            guard let title = quotewallTitle?.text
                else { return }
            
            if title.isEmpty {
                let alert = UIAlertController(title: "Sorry, I couldn't save it. Please add a title", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okButton)
              
                self.present(alert, animated: true, completion: nil)
                
            } else {
            
                QuotewallController.shared.createQuotewall(with: title)
                DispatchQueue.main.async {
                    self.quoteCategoryCollection.reloadData()
                }
        }
    }

        alertController.addAction(dismissAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Background Image picker Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editQuoteCollection" {
            
            if let indexPath = self.quoteCategoryCollection.indexPathsForSelectedItems?.first,
                let detailsVC = segue.destination as? QuoteCollectionViewController {
                
                let quotewall = QuotewallController.shared.quotewalls[indexPath.row]
                
                        detailsVC.quotewall = quotewall
            }
        }
    }

    
    // MARK: - Fetch quotewalls function
    func fetchQuotewalls(completion: @escaping(Bool) -> Void) {
        
        
        CloudKitController.shared.fetchCurrentUser { (success, person) in
            if success && (person != nil) {
                
                //  All quotewalls
                
                CloudKitController.shared.fetchCurrentPersonQuotewalls(completion: { (success, quotewalls) in
                   
                    if success {
                        
                        let dispatchGroup = DispatchGroup()
                        
                        for quotewall in QuotewallController.shared.quotewalls {
                            dispatchGroup.enter()
                            
                            CloudKitController.shared.fetchQuotesForQuotewall(quotewall, completion: { (success, quotes) in
                                quotewall.quotes = quotes
                                dispatchGroup.leave()
                            })
                        }
                        
                        dispatchGroup.notify(queue: DispatchQueue.main, execute: { 
                            completion(true)
                        })
                        
                    }

                    
                })
                
            }
        }
    }
}
