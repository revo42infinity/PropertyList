//
//  DetailsViewController.swift
//  PropertyList
//
//  Created by owner on 2/1/21.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        
        //8 gorsele tiklanma
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
    }
    //9
    @objc func selectImage() {
        //10 galeriye gidecegiz
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary //kaynagini belirle
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil) //completion islem bitince bisey yapicanmi hayir
        
        
        
    }
    
    //11 gorseli sectin sonra nolacak
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage //editing e izin ver ya da orjinali ver vs
        self.dismiss(animated: true, completion: nil) //picker controller kapa, imageview a geri don
        //12 infolist ten aciklama ekle image choose description icin
    }
    
    //5
    @objc func closeKeyboard() {
        //7 klavyeyi kapama
        view.endEditing(true)
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //13 appdelegate da context vs yazacagimiz icin appdelegate i degisken yapmak lazim once
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //appdelegate i degisken olarak tanimliyoruz
        let context = appDelegate.persistentContainer.viewContext
        
        //14
        let houses = NSEntityDescription.insertNewObject(forEntityName: "Properties", into: context)
        houses.setValue(typeTextField.text, forKey: "type") //anahtar kelime icin deger tanimla. anahtar kelime attribute lar
        houses.setValue(locationTextField.text, forKey: "location")
        
        //fiyati stringden int e cevirelim
        if let price = Int(priceTextField.text!) {
            houses.setValue(price, forKey: "price")
        }
        
        //15 universal unique id...her seferinde baska deger olusturacak
        houses.setValue(UUID(), forKey: "id")
        
        //16 gorseli binary data yapmamiz lazim
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        
        houses.setValue(data, forKey: "pictures")
        
        //17
        do {
            try context.save() //throws gordugumuz icin do try catch yap
        } catch {
            print("error")
            
        }
        
    }
    
   

}
