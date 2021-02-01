//
//  ViewController.swift
//  PropertyList
//
//  Created by owner on 2/1/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var viewController: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //1 nav barda arti button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addbuttonclicked))
    }
//2
    @objc func addbuttonclicked() {
        //3
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }

}

