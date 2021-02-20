//
//  ViewController.swift
//  PropertyList
//
//  Created by owner on 2/1/21.
//

import UIKit
import CoreData

//18
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   
    @IBOutlet weak var tableView: UITableView!
    
    
    //22 iki dizi olsuturucaz. cunku tableview da sadece id ve type cekecegiz.hafizayi dogru kullanmak icin herseyi burada cekmeyecegiz diger tarafta zaten yapacagiz
    var typeDizi = [String]()
    var idDizi = [UUID]()
    
    //29
    var selecttype = ""
    var selectUUID : UUID?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        tableView.delegate = self
        tableView.dataSource = self

        
        
        
        
        //1 nav barda arti button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addbuttonclicked))
        
        //22
        takeData()
        
    }
    
    //26 gorunum gosterilmeden once cagriliyor
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(takeData), name: NSNotification.Name?(NSNotification.Name(rawValue: "DataSaved")), object: nil) //gozlemci ekleyecegiz/notification centerde gozlemcilere haber veriyor cunku
        //bildirim gelirse nae yapacak? selector..ordaki func da take Data olacak
    }
    
    
    //19
    @objc func takeData() {
        //27 detailsVC de kaydedince oncekileri tekrar aldi kaydetti iki kere kayi olmamasi icin yapiyoruz bunu
        typeDizi.removeAll(keepingCapacity: false)
        idDizi.removeAll(keepingCapacity: false)
        //19 devam
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //veri cekme istegi yapmamiz lazim...istegi degisken olarak tanimlamak lazim
        //20
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Properties")
        fetchRequest.returnsObjectsAsFaults = false
        //veriler buyuk olunca false olsun
        
        //21
        do {
            let results = try context.fetch(fetchRequest)
            //34
            if results.count > 0 { //sonuclar sifirdan buyukse bu islemleri yap diyoruz
                //21
                for result in results as! [NSManagedObject]  {//cast ediyoruz nsmangedobeect olarak...coredatadan gelecgni biliyoruz
                    
                    
                    //23 if let yaptik let type = result.value(forKey: "type") as? String
                    if let type = result.value(forKey: "type") as? String {
                        typeDizi.append(type)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        idDizi.append(id)
                        
                    }
                }
                
                //24 datalari degistrdik guncelle dememiz lazim
                tableView.reloadData()
                
            }
            
            
        }
                catch {
                    print("error")
                    
                }
            }
        
    
    
    
//2
    @objc func addbuttonclicked() {
        //32 secilen type bos string olduguna emin olurska her arti butona tiklandiginda bos string olarak gidecek diger tarafta da bos gelince detailsvc anlayacak. giderken bos string gidecek yani
        selecttype = ""
        
        //3
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    //19
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeDizi.count     //24
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
       //25 cell.textLabel?.text = "test"
        //25
        cell.textLabel?.text = typeDizi[indexPath.row]
        return cell
    }
    
    //30
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController //nereye gidecek
            destinationVC.selectedType = selecttype
            destinationVC.selectedId = selectUUID
            //verileri esitledik
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //31
        selecttype = typeDizi[indexPath.row]
        selectUUID = idDizi[indexPath.row]
        
        
        //30
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    //40 silme islemlerine basliyoruz
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { //kontrole diyoruz. sonra ilgili veriyi veri tabanindan cekicez sonra silicez asagida
            
            //41 ilgili veriyi cekmemiz lazim
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Properties")
            let uuidString = idDizi[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            //yukarisi diger trafla ayni yaptik kodlari
            
            //42
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 { //sifirdan buyukse
                    for result in results as! [NSManagedObject]{ //tekil sonuca ulasiyoruz
                        if let id = result.value(forKey: "id") as? UUID { //bu sonuc hangi uuid den cektiyse onun sonucu olmasi lazim saglamasini yapalim.bunu alabilirsek asagiyi kontrol edelim
                            if id == idDizi[indexPath.row] { //eger cektigim veirnin id si gercekten secilen id ye esitse yuzde yuz emin olabiliriz.bunu yapmaya gerek yok ama genede yazalim.
                                
                                //43
                                context.delete(result) //artik siliniyor
                                //44 bunlardanda silmis olalim
                                typeDizi.remove(at: indexPath.row)
                                idDizi.remove(at: indexPath.row)
                                //45 guncelle tableview
                                self.tableView.reloadData()
                                //46
                                do{
                                    try context.save()
                                } catch {
                                    
                                }
                                //47 donguyu durdur diyoruz. optional. ektsra onlem
                                break
                                
                            }
                        }
                    }
                }
                
            } catch {
                print("error")
            }
            
            
            
            
            
        }
    }
}

