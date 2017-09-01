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
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var imageTransparentView: UIView!
    @IBOutlet weak var quoteTextField: UITextView!
    @IBOutlet weak var personNameTextField: UITextField!
    @IBOutlet weak var addBackgroundImage: UIButton!
    @IBOutlet weak var quoteCellView: UIView!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!

    // MARK: - Properties
    
    var quotewall: Quotewall?
    var senderIsMainCollection: Bool = false
    var senderIsFavoriteCollection: Bool = false
    var quote: Quote?
    var favoriteQuote: FavoriteQuote?
    var quoteCollectionCell = QuotesCollectionViewCell()
    let imagePicker = UIImagePickerController()
    let navigation = UINavigationController()
    // MARK: - Actions
   
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if senderIsFavoriteCollection {
            
            guard let favoriteQuote = favoriteQuote,
                let quote = quoteTextField.text,
                let author = personNameTextField.text
                else { return }

            
            if quote.isEmpty || author.isEmpty {
                
                unableToSaveAlert()
                return
                
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

    }
       
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quoteTextField.delegate = self
        personNameTextField.delegate = self
        
        updateViews()
       
        imagePicker.delegate = self
        navigationBar.delegate = self as? UINavigationBarDelegate
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
    }
    
    // MARK: - Image Picker Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            backgroundImage.contentMode = .scaleToFill
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
            let quotewall = quotewall
            else { return }
        
        var backgroundImageData:  Data? = nil
        if let imageData = backgroundImage?.image {
            backgroundImageData = UIImagePNGRepresentation(imageData)
        }
    
        QuoteController.shared.createQuote(with: name, text: text, image: backgroundImageData, quotewall: quotewall) { (success) in
            
            DispatchQueue.main.async {
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
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
    
    // MARK: - Helper Functions
    
    func updateViews() {
        guard let quote = quote else { return }
        
        personNameTextField.text = quote.name
        quoteTextField.text = quote.text

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
    
}

