//
//  ViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-05-20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate{
    
    
    //MARK: - Properties
    lazy var coreDataStack = CoreDataStack(modelName: "ClothingDataModel")
    
    // array of clothes
    var dropList = [ClothingItem]()
    
    //date formatter for label
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .none
        df.doesRelativeDateFormatting = true
        df.dateStyle = .medium
        return df
    }()
    
    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    

    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate methods
        tableView.delegate = self
        tableView.dataSource = self
        
        // insert fetch clothing item function
        

    }//: View did load
    
}//: View Controller


//MARK: - Extensions
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothingItemCell", for: indexPath) as! DropTableViewCell
        let item = dropList[indexPath.row]
        
        cell.nameLabel?.text = item.name
        cell.dateLabel?.text = dateFormatter.string(from: item.dateReleased ?? Date())
        
        
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropList.count
    }
    
    
}

