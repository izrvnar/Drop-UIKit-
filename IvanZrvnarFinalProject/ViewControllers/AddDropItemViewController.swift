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
    var clothingItem : ClothingItem?
    
    // document library property
    var documentLibrary: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(paths[0])
        
        return paths[0]
    }
    
    
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
        
        let delay = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    //MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.dataSource = self
        typePicker.delegate = self
        
        if let clothingItem = clothingItem {
            nameInput.text = clothingItem.name
            brandInput.text = clothingItem.brand
            dateInput.date = clothingItem.dateReleased!
            linkInput.text = clothingItem.urlLink
            noteInput.text = clothingItem.notes
            selectedType = clothingItem.type!
            
            if let imageString = clothingItem.image{
                imageInput.image = fetchImage(withIdentifier: imageString)
            }
        }
        
        // image double tap method
        imageInput.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(cameraDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        imageInput.addGestureRecognizer(doubleTap)
        
    }//: View did load
    
    //MARK: - Methods
    func save(){
        
        if clothingItem == nil{
            
            let newDrop = ClothingItem(context: coreDataStack.managedContext)
            newDrop.name = nameInput.text ?? ""
            newDrop.dateReleased = dateInput.date
            newDrop.brand = brandInput.text ?? ""
            newDrop.notes = noteInput.text ?? ""
            newDrop.urlLink = linkInput.text ?? ""
            newDrop.type = selectedType
            
            //TODO: Add image and type to the data. The image extension is complete but not sure if working
            if let image = imageInput.image{
                let clothingImage = UUID().uuidString
                newDrop.image = clothingImage
                saveImage(image: image, withIdentifier: clothingImage)
            }
            
            
            //set up notification
            let content = UNMutableNotificationContent()
            content.title = "\(newDrop.name ?? "Clothing Item") is dropping now"
            content.subtitle = "Click notifiation to be sent to your saved link"
            
            guard let dateReleased = newDrop.dateReleased else {return}
            
            let calendar: Set<Calendar.Component> = [.month, .day, .year, .hour, .minute]
            let date = Calendar.current.dateComponents(calendar, from: dateReleased)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            
            let request = UNNotificationRequest(identifier: "notification.date.\(UUID().uuidString)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {
                error in
                if let error = error  {
                    print("Error with calendar timer - \(error.localizedDescription)")
                }
            })
            
            coreDataStack.saveContext()
            
            droplist.append(newDrop)
            
        } else{
            
            // saving the edited clothing item
            clothingItem?.name = nameInput.text
            clothingItem?.brand = brandInput.text
            clothingItem?.dateReleased = dateInput.date
            clothingItem?.urlLink = linkInput.text
            clothingItem?.notes = noteInput.text
            
            // update the image
            if let image = imageInput.image{
                if let clothingImage = clothingItem?.image {
                    saveImage(image: image, withIdentifier: clothingImage)
                } else{
                    let clothingImage = UUID().uuidString
                    clothingItem?.image = clothingImage
                    saveImage(image: image, withIdentifier: clothingImage)
                }
            }
            
            // adding to the droplist
            droplist.append(clothingItem!)
            coreDataStack.saveContext()
            
        }
        
    }
    // alert method
    func showErrorAlert(withMessage message: String){
        let alert = UIAlertController(title: "Missing Information", message: message , preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        
        present(alert, animated: true)
        
    }
    
    //opening camera
    @objc func cameraDoubleTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
    }
    
    //MARK: - Image Methods
    // fetch image
    func fetchImage(withIdentifier id: String) -> UIImage?{
        if let imagePath = documentLibrary?.appendingPathComponent(id), let imageFromDisk = UIImage(contentsOfFile: imagePath.path){
            return imageFromDisk
    }
        return nil
}
    
    //save image
    func saveImage(image: UIImage, withIdentifier id: String){
        if let imagePath = documentLibrary?.appendingPathComponent(id){
            if let data = image.jpegData(compressionQuality: 0.8){
                do {
                    try data.write(to: imagePath)
                } catch {
                    print("Error saving the image - \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    
    
    
    
}//: view controller


    
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

extension AddDropItemViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameInput.resignFirstResponder()
        brandInput.resignFirstResponder()
        linkInput.resignFirstResponder()
        noteInput.resignFirstResponder()
        return true
    }
}



// setting the image to the core data
extension AddDropItemViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else{
            return
        }
        
        imageInput.image = image
        

    }
}

extension AddDropItemViewController: UINavigationControllerDelegate{
    
}
