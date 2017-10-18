//
//  QuotesTemplateViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class QuotesTemplateViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var imageTransparentView: UIView!
    @IBOutlet weak var quoteTextField: UITextView!
    @IBOutlet weak var personNameTextField: UITextField!
    @IBOutlet weak var addBackgroundImage: UIButton!
    @IBOutlet weak var quoteCellView: UIView!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var quoteCard: UIView!
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!

    // MARK: - Properties
    
    var quotewall: Quotewall?
    var senderIsMainCollection: Bool = false
    var senderIsFavoriteCollection: Bool = false
    var quote: Quote?
    var favoriteQuote: FavoriteQuote?
    var quoteCollectionCell = QuotesCollectionViewCell()
    let imagePicker = UIImagePickerController()
    let navigation = UINavigationController()
    let gradient = CAGradientLayer()
    
    // MARK: - Actions
   
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        guard let currentQuote = quote,
            let currentQuotewall = quotewall
            else { return }
        
        self.delete(quote: currentQuote, from: currentQuotewall) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
<<<<<<< HEAD
    
=======
   
>>>>>>> version2ID
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
<<<<<<< HEAD
        if senderIsMainCollection {
=======
        view.endEditing(true)
        if senderIsFavoriteCollection {
>>>>>>> version2ID
            
            guard let quoteText = quoteTextField.text,
                let author = personNameTextField.text,
                let title = titleTextField.text,
                let currentQuote = self.quote
                else { return }

            
<<<<<<< HEAD
            if quoteText.isEmpty || author.isEmpty {
=======
            var backgroundImageData: Data? = nil
            if let backgroundImage = backgroundImage.image {
                backgroundImageData = UIImagePNGRepresentation(backgroundImage)
            }
            
            if quote.isEmpty || author.isEmpty {
>>>>>>> version2ID
                
                unableToSaveAlert()
                return
                
            } else {
                
                self.update(quote: currentQuote, author: author, quoteText: quoteText, title: title, completion: { (success) in

                        if success {
                            self.dismiss(animated: true, completion: nil)
                        
                    }
                })
                
            }
            
        } else if senderIsMainCollection {
            
            guard let quote = quote,
                let author = personNameTextField.text,
                let text = quoteTextField.text
                else { return }
            
            var backgroundImageData: Data? = nil
            
            if let backgroundImage = backgroundImage.image {
                backgroundImageData = UIImagePNGRepresentation(backgroundImage) }
            
            if text.isEmpty || author.isEmpty {
                
                unableToSaveAlert()
                return
                
            } else {
                
                updatedSavedQuote(quote, author: author, text: text, backgroundImage: backgroundImageData)
                
            }
            
        } else {
            
            guard let quote = quoteTextField.text,
                let person = personNameTextField.text
                else { return }
            
            if quote.isEmpty || person.isEmpty {
                
                unableToSaveAlert()
                return
                
            } else {
                
                saveQuoteToQuotewall(with: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                    }
                })
            }
        }
<<<<<<< HEAD

=======
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFavoriteButtonTapped(_ sender: Any) {
        
        print("Favorite button tapped")
        guard let quote = quoteTextField.text,
            let author = personNameTextField.text
            
            else { return }
        
        var backgroundData: Data? = nil
        if let backgroundImage = backgroundImage.image {
            backgroundData = UIImagePNGRepresentation(backgroundImage)
        }
        
        
        FavoriteQuoteController.shared.createFavoriteQuote(with: author, quote: quote, image: backgroundData) { (success) in
            if !success {
                NSLog("There was an error creating a favorite quote")
            }
        }
        
>>>>>>> version2ID
    }
       
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quoteTextField.delegate = self
        personNameTextField.delegate = self
        titleTextField.delegate = self
        updateViews()
        
        if senderIsMainCollection {
            deleteButton.isHidden = false
            deleteImage.isHidden = false
        }
        
        gradient.colors = [UIColor.gradientBlueColor.cgColor, UIColor.gradientGreenColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
       
        imagePicker.delegate = self
        navigationBar.delegate = self as? UINavigationBarDelegate
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        quoteCard.layer.shadowOpacity = 1.0
        quoteCard.layer.shadowRadius = 4
        quoteCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        quoteCard.layer.shadowColor = UIColor.black.cgColor

        
    }
    
    // MARK: - Image Picker Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            backgroundImage.contentMode = .scaleToFill
            backgroundImage.image = pickedImage.fixOrientation()
            backgroundImage.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func selectPhotoTapped(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
    }
    
    func saveQuoteToQuotewall(with completion: @escaping (Bool)-> Void) {
        
        guard let name = personNameTextField.text,
            let text = quoteTextField.text,
            let quotewall = quotewall,
            let title = titleTextField.text
            else { return }
        
        var backgroundImageData:  Data? = nil
        if let imageData = backgroundImage?.image {
            backgroundImageData = UIImagePNGRepresentation(imageData)
        }
    
        QuoteController.shared.createQuote(with: name, text: text, title: title, image: backgroundImageData, quotewall: quotewall) { (success) in
            
            DispatchQueue.main.async {
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
<<<<<<< HEAD
    func delete(quote: Quote, from quotewall: Quotewall, with completion: @escaping (Bool) -> Void) {
        let currentQuote = quote
        let currentQuotewall = quotewall
        
        QuoteController.shared.removeQuote(currentQuote, from: currentQuotewall) { (success) in
            if success {
                
                completion(true)
                
            } else {
                self.unableToDeleteAlert()
                completion(false)
            }
        }
        
    }
    
    // MARK: - Text Field and View Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textFieldReturnResponder(textField)
       
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
    return true
=======
    func updatedSavedQuote(_ quote: Quote, author: String, text: String, backgroundImage: Data? = nil) {
        
        QuotewallController.shared.updatedQuote(with: quote, name: author, text: text, backgroundImage: backgroundImage) { (_) in
            
            return
        }
>>>>>>> version2ID
    }
    

    // MARK: - Alert controllers
    
    fileprivate func unableToSaveAlert() {
        let alert = UIAlertController(title: "Unable To Save Quote", message: "Please make sure you have both the quote and the name of the person who said it", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    func photoSelectCellSelected(backgroundImageButtonTapped: UIButton) {
        selectPhotoTapped(sender: backgroundImageButtonTapped)
    }
    
    func savedSuccessfully() {
        let alert = UIAlertController(title: "Success!", message: "Your new quote was saved successfully", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteSuccessful() {
        let alert = UIAlertController(title: "Successfully Deleted!", message: "", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK!", style: .default, handler: nil)
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func unableToDeleteAlert() {
        let alert = UIAlertController(title: "Unable to Delete", message: "Please try again later", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK!", style: .default, handler: nil)
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Helper Functions
    
    func updateViews() {
        
        deleteButton.isHidden = true
        deleteImage.isHidden = true
        
        guard let quote = quote else { return }
        
        personNameTextField.text = quote.name
        quoteTextField.text = quote.text
        titleTextField.text = quote.title

    }

    
    func textFieldReturnResponder(_ textField: UITextField) {
        
            textField.resignFirstResponder()
        }
    
    func animateViewMoving(up: Bool, moveValue: CGFloat) {
        
            let movementDuration: TimeInterval = 0.5
            
            let movement: CGFloat = (up ? -moveValue : moveValue)
            
            UIView.beginAnimations("animateView", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration)
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            UIView.commitAnimations()
        }
    
    func update(quote: Quote, author: String, quoteText: String, title: String, completion: @escaping (Bool) -> Void) {
        
        QuoteController.shared.updateQuote(quote, withQuoteData: author, quoteText: quoteText, title: title) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
  
    
}

