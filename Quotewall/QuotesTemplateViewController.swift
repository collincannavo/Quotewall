//
//  QuotesTemplateViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class QuotesTemplateViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var closeQuotationImage: UIImageView!
    @IBOutlet weak var openQuotationImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var imageTransparentView: UIView!
    @IBOutlet weak var quoteTextField: UITextView!
    @IBOutlet weak var personNameTextField: UITextField!
    @IBOutlet weak var addBackgroundImage: UIButton!
    @IBOutlet weak var quoteCellView: UIView!

    // MARK: - Properties
    
    var quote: Quote?
    var quoteCollectionCell = QuotesCollectionViewCell()
    weak var delegate: PhotoSelectViewControllerDelegate?
    
    
    // MARK: - Actions
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let quote = quoteTextField.text,
            let person = personNameTextField.text
            else { return }
        
        if quote.isEmpty || person.isEmpty {
            
            unableToSaveAlert()
            return
            
        } else {
           
            saveQuoteToQuotewall(with: { (success) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    
                }
            })
            
 
        }
    }
    
    // MARK: - Functions
    
    
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
            let text = quoteTextField.text
            else { return }
        
        var backgroundImageData:  Data? = nil
//        if let imageData = quoteCollectionCell.backgroundImage.image {
//            backgroundImageData = UIImagePNGRepresentation(imageData)
//        }
        
        QuoteController.shared.createQuote(with: name, text: text, image: backgroundImageData) { (success) in
            
            DispatchQueue.main.async {
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
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
    
}

protocol PhotoSelectViewControllerDelegate: class {
    func photoSelectViewControllerSelected(_ image: UIImage)
}
