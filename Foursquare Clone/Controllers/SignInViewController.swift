//
//  SignInViewController.swift
//  Foursquare Clone
//
//  Created by sarath kumar on 31/07/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signinButon: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Custom Methods
    
    private func setupUI() {
        
        self.view.backgroundColor = UIColor.viewBackground
        self.signinButon.backgroundColor = UIColor.pinkColor
        logoImageView.layer.cornerRadius = 10
        logoImageView.layer.masksToBounds = true
        signinButon.layer.cornerRadius = 10
        signinButon.layer.masksToBounds = true
        
        
    }
    
    // MARK: - Action Methods
    
    @IBAction func signUpButtonAction() {
        
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    
    @IBAction func loginAction() {
        
        if userNameTextField.text != "" && passWordTextField.text != "" {

            PFUser.logInWithUsername(inBackground: userNameTextField.text!, password: passWordTextField.text!) { (user, error) in
                if error != nil {
                    self.showAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "signIntoPlace", sender: nil)
                }
            }
        }
    }
}
