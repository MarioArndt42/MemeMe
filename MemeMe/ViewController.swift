//
//  ViewController.swift
//  MemeMe
//
//  Created by Mario Arndt on 25.02.22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Editor closed -> reload memes in table or collection view
    var isDismissed: (() -> Void)?
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
        
    @IBOutlet weak var shareButton: UIBarButtonItem!    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // TextFields attributes white with a black outline
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
          .strokeColor: UIColor.black,
          .foregroundColor: UIColor.white,
          .font: UIFont(name: "HelveticaNeue-CondensedBlack", size:40)!,
          .strokeWidth: -4
      ]
    
    override func viewWillAppear(_ animated: Bool) {
            //Camera is not running on simulator
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
            shareButton.isEnabled = false
             
            //Notifications for keyboard
            addNotification(notification: UIResponder.keyboardWillShowNotification, selectorFunc: #selector(keyboardWillShow))
            addNotification(notification: UIResponder.keyboardWillHideNotification, selectorFunc: #selector(keyboardWillHide(_:)))
      
    }
    
    // Add notifications
    func addNotification(notification: NSNotification.Name, selectorFunc: Selector) {
            NotificationCenter.default.addObserver(
            self,
            selector: selectorFunc,
            name: notification,
            object: nil)
    }     
     
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialize textfields
        setupTextField(topTextField, text: "TOP")
        setupTextField(bottomTextField, text: "BOTTOM")
        
    }
    
    // Initialize bottom and top textfield
    func setupTextField(_ textField: UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
        
    // Select a picture
    func imagePickerController(_:UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //showInitTextFields()
        shareButton.isEnabled = true
        //Show selected picture
        if let image = info[.originalImage] as? UIImage {
             imagePickerView.image = image
             }
        dismiss(animated: true, completion: nil)
    }
    
    // Selecting images from the camera and photo library
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    presentPickerViewController(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
    presentPickerViewController(source: .camera)
    }
    
    @IBAction func topEditDidBegin(_ sender: Any) {
        topTextField.text = ""
    }
    
    @IBAction func bottomEditDidBegin(_ sender: Any) {
        bottomTextField.text = ""
    }
    
    @IBAction func shareActivated(_ sender: UIBarButtonItem) {
        // Create shared meme
        let controller = UIActivityViewController(activityItems:
            [generateMemedImage()], applicationActivities: nil)
        
        // After Sharing
        controller.completionWithItemsHandler = {
            activity, completed, items, error in
                         if completed {
                         self.save()
                         self.dismiss(animated: true, completion: nil)
                 }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    // Cancel button
    @IBAction func discardMeme(_ sender: UIBarButtonItem) {
                shareButton.isEnabled = false
                imagePickerView.image = nil
                // Show saved Memes
                showHistory(self)
    }
          
    // Generate a view as meme
    func generateMemedImage() -> UIImage {
            hideAndShowBars(hideOrShow: "hide")
        
            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        
            hideAndShowBars(hideOrShow: "show")
            return memedImage
        }
    
    // Hide and show toolbars
    func hideAndShowBars(hideOrShow: String) {
        if hideOrShow == "hide" {
            topToolbar.isHidden = true
            bottomToolbar.isHidden = true
        }
        else {
            topToolbar.isHidden = false
            bottomToolbar.isHidden = false
        }
    }
            
    // Save the image
    func save() {
            // Generate the meme
            let memedImage = generateMemedImage()
            let meme = Meme(
                topText: topTextField.text!,
                bottomText: bottomTextField.text!,
                originalImage: imagePickerView.image!,
                memedImage: memedImage)
        
        // Add it to the memes array in Application Delegate
       (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
       
        // Show saved memes
        showHistory(self)
    }
    
    // Show saved memes
    func showHistory(_ sender: AnyObject) {
         
         // Close editor
         self.dismiss(animated: true) {
             // Editor closed -> Reload memes in table or collection view
             self.isDismissed?()
         }
     }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
    }
    
    // Return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            topTextField.resignFirstResponder()
            bottomTextField.resignFirstResponder()
            return true
    }
        
    // Show keyboard and adjusting view when editing bottomText
    @objc func keyboardWillShow(_ notification:Notification) {
            if bottomTextField.isFirstResponder {
                 if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                         let keyboardRectangle = keyboardFrame.cgRectValue
                         let keyboardHeight = keyboardRectangle.height
                         view.frame.origin.y = -keyboardHeight
                 }
             }
    }
         
    // Hide keyboard and adjusting view when editing bottomText
    @objc func keyboardWillHide(_ notification:Notification) {
             if bottomTextField.isEditing, view.frame.origin.y != 0 {
                 view.frame.origin.y = 0
             }
    }
}



