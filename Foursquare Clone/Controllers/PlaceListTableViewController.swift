//
//  PlaceListTableViewController.swift
//  Foursquare Clone
//
//  Created by sarath kumar on 31/07/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit
import Parse

class PlaceListTableViewController: UITableViewController {
    
    var placeNameArray = [String]()
    var idArray = [String]()
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        getParseData()
    }
    
    //MARK: - Custom Methods
    
    private func setUpUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonAction))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
    }
    
    private func getParseData() {
        
        let query = PFQuery(className: "Place")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.showAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "error")
            } else {
                if objects != nil {
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.idArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String {
                            if let id = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.idArray.append(id)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Action Methods
    
    @objc func addBarButtonAction() {
        performSegue(withIdentifier: "PlaceListToAddPlace", sender: nil)
    }
    
    
    @objc func logoutAction() {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                self.showAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            } else {
                self.performSegue(withIdentifier: "PlaceVCToSignIn", sender: nil)
            }
        }
    }
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.placeNameArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = self.idArray[indexPath.row]
        performSegue(withIdentifier: "PlaceListToDetail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let query = PFQuery(className: "Place")
            query.getObjectInBackground(withId: self.idArray[indexPath.row]) { (object, error) in
                if error != nil {
                    self.showAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "error")
                } else {
                    if object != nil {
                        object?.deleteInBackground()
                        self.idArray.remove(at: indexPath.row)
                        self.placeNameArray.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        
                        object?.saveInBackground()
                    }
                }
            }
        }
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaceListToDetail" {
            let destinationVC = segue.destination as! PlaceDetailsViewController
            destinationVC.chosenPlaceId = selectedId
        }
    }
}
