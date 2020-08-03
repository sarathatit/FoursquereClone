//
//  SignUpViewController.swift
//  Foursquare Clone
//
//  Created by sarath kumar on 31/07/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField:UITextField!
    @IBOutlet weak var conformPassWordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    

    private func setupUI() {
        
        self.view.backgroundColor = UIColor.viewBackground
        logoImageView.layer.cornerRadius = 10
        logoImageView.layer.masksToBounds = true
        signUpButton.backgroundColor = UIColor.pinkColor
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.masksToBounds = true
    }
    
    //MARK: - Action Methods
    
    @IBAction func signInButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpAction() {
        
        if userNameTextField.text != "" && passWordTextField.text != "" {
            
            let user = PFUser()
            user.username = userNameTextField.text!
            user.password = passWordTextField.text!
            
            user.signUpInBackground { (success, error) in
                
                if error != nil {
                    self.showAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "signUptoPlace", sender: nil)
                }
            }
        }
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

