//
//  NewCarViewController.swift
//  ForCFT2
//
//  Created by Дмитрий Геращенко on 28.09.2020.
//  Copyright © 2020 Дмитрий Геращенко. All rights reserved.
//

import UIKit
import os.log

class NewCarViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var yearTexField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var car: Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manufacturerTextField.delegate = self
        modelTextField.delegate = self
        bodyTextField.delegate = self
        yearTexField.delegate = self
        
        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        guard let manufacText = manufacturerTextField.text , let modelText = modelTextField.text else {
            fatalError("Navigation Title could't be empty.")
        }
        navigationItem.title = "\(manufacText) \(modelText)"
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        carImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("", log: OSLog.default, type: .debug)
            return
        }
        let image = carImage.image
        let manufacturer = manufacturerTextField.text ?? ""
        let model = modelTextField.text ?? ""
        let body = bodyTextField.text ?? ""
        let year = yearTexField.text ?? ""

        car = Car(image: image, manufacturer: manufacturer, model: model, bodyType: body, year: year)
    }
    
    //MARK: ACTIONS
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        manufacturerTextField.resignFirstResponder()
        modelTextField.resignFirstResponder()
        bodyTextField.resignFirstResponder()
        yearTexField.resignFirstResponder()
//
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func updateSaveButtonState() {
        let text = manufacturerTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}
