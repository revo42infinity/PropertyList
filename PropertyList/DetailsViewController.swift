//
//  DetailsViewController.swift
//  PropertyList
//
//  Created by owner on 2/1/21.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //4 keyboard kapama bir yere tiklaninca. once bir yere tiklanmayi algilama
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        
        //6
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    //5
    @objc func closeKeyboard() {
        //7 klavyeyi kapama
        view.endEditing(true)
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
   

}
