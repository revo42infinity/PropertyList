//
//  DetailsViewController.swift
//  PropertyList
//
//  Created by owner on 2/1/21.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var savedButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    //27 secilen urun neyse bilgilerini aktarmak icin yazmaya basliyoruz.bu sebeple iki degisken olusutuyoruz
    
    var selectedType = ""
    var selectedId : UUID?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //28
        if selectedType != "" { //eger type secildiyse yani bos degil ise
            //core data secilen urun bilgilerini goster.ordan cekip goster
            
            //48
           // savedButton.isEnabled = false //ustune tiklanamaz artik
            savedButton.isHidden = true //boyle yapinca hic gozukmeyecek. ama artiya tiklaninca olsun diye asagida 49.kodda artiya tiklandiginda ishidden false olacak
            
            //33 sadece tiklanan urunun uuidsini diger tarafta logda aliyoruz. string olarak tiklananlarin uuid sini aliyoruz boylece
            if let uuidstring = selectedId?.uuidString{
              //35 print(uuidstring)
                
                //35uuid gelirse ne yapacagiz? onu yazalim
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appdelegate.persistentContainer.viewContext
                
                //36 cekme islemi icin
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Properties")
                
                //38 filte ekleyecegiz. mantiksal sinirlar koy arama buna gore yapilacak demek predicate. format istiyor. neyi filtrelemek istiyoruz?? ID yi
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidstring) //id si uuidstring(yada ne isim yazarsan buna) e esit olanlari getir %@ bunun anlami...
                
                //37
                fetchRequest.returnsObjectsAsFaults = false
                
                //39
                do {
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject]{
                            //image view textview a yazdiricam
                            if let type = result.value(forKey: "type") as? String {
                                typeTextField.text = type
                                
                            }
                            if let price = result.value(forKey: "price") as? Int {
                                priceTextField.text = String(price)
                            }
                            if let location = result.value(forKey: "location") as? String {
                                locationTextField.text = location
                            }
                            //gorselin datasini alacagiz. bunu sonra uiimage a cevirecegiz .
                            if let pictData = result.value(forKey: "pictures") as? Data {
                                let image = UIImage(data: pictData) //uiimage olsturacak
                                imageView.image = image
                            }
                        }
                    }
                } catch {
                    print("error")
                    
                }
                
                
            }
            
            
            
            
        } else { //demekki yukaridaki artiya tiklayrak geldi secerek gelmedi urunu
            
           //49
            savedButton.isHidden = false
            savedButton.isEnabled = false
            //ancak gorsel sectiginde tiklandiracagiz o da 50.kodda
            
            //39 devami bos gosterelim
            typeTextField.text = ""
            locationTextField.text = ""
            priceTextField.text = ""
            
            
            
        }

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
        imageView.image = info[.originalImage] as? UIImage //editing e izin ver ya da orjinali ver vs...any verdigi icin as ile cast ettim. opsiyonel cast
        
        //50
        savedButton.isEnabled = true
        
        //11 devami
        self.dismiss(animated: true, completion: nil) //picker controller kapa, imageview a geri don
        //12 infolist ten aciklama ekle image choose description icin
    }
    
    //5
    @objc func closeKeyboard() {
        //7 klavyeyi kapama
        view.endEditing(true)
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //13 appdelegate da context vs yazacagimiz icin appdelegate i degisken yapmak lazim once. CORE Data icin aynisini yazdik.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //appdelegate i degisken olarak tanimliyoruz
        let context = appDelegate.persistentContainer.viewContext
        
        //14 13 u yaptik cunku liste kaydetmeye calisiyoruz...coredate modeli icin nsentity yapiyoruz. import coredata yaptik.
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
            try context.save() //sadece context.save yaptigimizda throws gordugumuz icin do try catch yap
        } catch {
            print("error")
            
        }
        //26 diger tarafa gecmeden once veri kaydettigimizi diger controllere haber vermek istiyorum. haber yollamak istedigimizde notfiicatin center kulllaniriz
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataSaved"), object: nil) //ne mesaji yollayacagiz
        
        
        
        
        //25 viewcontrole geri donmek lazim kaydettikten sonra
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
   

}
