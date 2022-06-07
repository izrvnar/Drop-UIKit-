//
//  AddDropItemViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-05-22.
//

import UIKit
import CoreData

class AddDropItemViewController: UIViewController {
    
    //MARK: - Properties
    var droplist = [ClothingItem]()
    var typeResults = ["Shoes", "Shirt", "Pants", "Accessories", "Other"]
    var coreDataStack : CoreDataStack!
    var selectedType = "Shoes"
    
    
    
    
    //MARK: - Outlets
    @IBOutlet var nameInput: UITextField!
    @IBOutlet var brandInput: UITextField!
    @IBOutlet var dateInput: UIDatePicker!
    @IBOutlet var typePicker: UIPickerView!
    @IBOutlet var linkInput: UITextField!
    @IBOutlet var noteInput: UITextField!
    @IBOutlet var imageInput: UIImageView!
    @IBAction func saveItem(_ sender: Any) {
        save()
        
        let delay = 1.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.dataSource = self
        typePicker.delegate = self
        
        
        


        // Do any additional setup after loading the view.
    }
    
    //MARK: - Methods
    func save(){
        let newDrop = ClothingItem(context: coreDataStack.managedContext)
        newDrop.name = nameInput.text ?? ""
        newDrop.dateReleased = dateInput.date
        newDrop.brand = brandInput.text ?? ""
        newDrop.notes = noteInput.text ?? ""
        newDrop.urlLink = linkInput.text ?? ""
        
        //TODO: Add image and type to the data. The image extension is complete but not sure if working
        newDrop.type = selectedType
        
        
        

        
        coreDataStack.saveContext()
        
        droplist.append(newDrop)
    
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

//MARK: -Extensions

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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = typeResults[row]
        print(selectedType)
    }
    
}



// setting the image to the core data
//extension AddDropItemViewController: UIImagePickerControllerDelegate{
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//
//        guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
//            return
//        }
//        let dataImage = chosenImage.pngData()
//
//
//        let context = self.coreDataStack.managedContext
//
//        guard let user = NSEntityDescription.insertNewObject(forEntityName: "image", into: context) as? ClothingItem else {
//            return
//        }
//        user.image = dataImage
//
//
//        do {
//            try context.save()
//        } catch {
//            print("Could not save. \(error), \(error.localizedDescription)")
//        }
//
//
//    }
//}