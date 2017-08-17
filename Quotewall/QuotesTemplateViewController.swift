//
//  QuotesTemplateViewController.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/15/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

class QuotesTemplateViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, PhotoSelectorCellDelegate {
    
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
    var quoteCollectionCell = QuoteCollectionViewCell()
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
    
    override func viewDidLoad() {
        setUpCellDisplay()
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
            let text = quoteTextField.text
            else { return }
        
        var backgroundImageData:  Data? = nil
        if let imageData = quoteCollectionCell.backgroundImage.image {
            backgroundImageData = UIImagePNGRepresentation(imageData)
        }
        
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
    

    
    fileprivate func setUpCellDisplay() {
        
        if let customView = Bundle.main.loadNibNamed("QuoteCollectionViewCell", owner: self, options: nil)?.first as? QuoteCollectionViewCell {
            quoteCollectionCell = customView
            quoteCollectionCell.authorNameLabel.text = personNameTextField.text
            quoteCollectionCell.quoteTextField.text = quoteTextField.text
            quoteCollectionCell.openQuotationImage = openQuotationImage
            quoteCollectionCell.closeQuotationImage = closeQuotationImage
            quoteCollectionCell.quote = quote
            quoteCollectionCell.bounds = quoteCellView.bounds
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.photoSelectViewControllerSelected(image)
            quoteCollectionCell.backgroundImage.image = image.fixOrientation()
            quoteCollectionCell.backgroundImage.contentMode = .scaleAspectFit
            quoteCollectionCell.backgroundImageButton.setTitle("", for: .normal)
        }
    }
    
    // MARK: - TextField Delegate Functions
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let author = personNameTextField.text,
            let quote = quoteTextField.text
            else { return }
        
        quoteCollectionCell.authorNameLabel.text = author
        quoteCollectionCell.quoteTextField.text = quote
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldReturnResponder(textField)
        return true
    }
    
    fileprivate func textFieldReturnResponder(_ textField: UITextField){
        if textField == quoteTextField {
            quoteTextField.resignFirstResponder()
            personNameTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
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
    
}

protocol PhotoSelectViewControllerDelegate: class {
    func photoSelectViewControllerSelected(_ image: UIImage)
}
