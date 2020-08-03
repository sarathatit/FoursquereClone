//
//  AddPlaceViewController.swift
//  Foursquare Clone
//
//  Created by sarath kumar on 01/08/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit

class AddPlaceViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeTypeTextField: UITextField!
    @IBOutlet weak var placeAtmosphereTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    //MARK: - Custom Methods
    
    private func setupUI() {
        placeImageView.layer.cornerRadius = 10
        placeImageView.layer.masksToBounds = true
        nextButton.layer.cornerRadius = 10
        nextButton.layer.masksToBounds = true
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(imageSelectingAction))
        placeImageView.addGestureRecognizer(imageGesture)
        placeImageView.isUserInteractionEnabled = true
    }
    
    //MARK: - Action Methods
    
    @objc func imageSelectingAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonAction() {
        if placeNameTextField.text != "" && placeTypeTextField.text != "" && placeAtmosphereTextField.text != "" {
            if let image = placeImageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeImage = image
                placeModel.placeName = placeNameTextField.text!
                placeModel.placeType = placeTypeTextField.text!
                placeModel.placeAtmosphere = placeAtmosphereTextField.text!
            }
            performSegue(withIdentifier: "AddPlaceToSelectLocation", sender: nil)
        } else {
            self.showAlert(titleInput: "Error!", messageInput: "Fields should not be empty!")
        }
        
    }
    
    //MARK: - Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.placeImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }

}
