//
//  AddDropItemViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-05-22.
//

import UIKit

class AddDropItemViewController: UIViewController {
    
    //MARK: - Properties
    var droplist = [ClothingItem]()
    var typeResults = ["Shoes", "Shirt", "Pants", "Accessories", "Other"]
    var coreData : CoreDataStack!
    
    
    
    
    //MARK: - Outlets
    @IBOutlet var nameInput: UITextField!
    @IBOutlet var brandInput: UITextField!
    @IBOutlet var dateInput: UIDatePicker!
    @IBOutlet var typePicker: UIPickerView!
    @IBOutlet var linkInput: UITextField!
    @IBOutlet var noteInput: UITextField!
    @IBOutlet var imageInput: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.dataSource = self
        typePicker.delegate = self
        


        // Do any additional setup after loading the view.
    }
    
    //MARK: - Methods
    func save(){
        let newDrop = ClothingItem(context: self.coreData.managedContext)
        newDrop.name = nameInput.text ?? ""
        newDrop.dateReleased = dateInput.date
        newDrop.brand = brandInput.text ?? ""
        newDrop.notes = noteInput.text ?? ""
        newDrop.urlLink = linkInput.text ?? ""

        self.coreData.saveContext()
        
        self.droplist.append(newDrop)
        
            
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddDropItemViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        typeResults.count
    }
    
    
}

extension AddDropItemViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        typeResults[row]
    }
}
