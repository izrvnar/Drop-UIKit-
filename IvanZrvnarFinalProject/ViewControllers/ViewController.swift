//
//  ViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-05-20.
//

import UIKit

class ViewController: UIViewController{
    
    
    //MARK: - Properties
    lazy var coreDataStack = CoreDataStack(modelName: "ClothingDataModel")
    
    // array of clothes
    var dropList = [ClothingItem]()
    var clothingItem = ClothingItem()
    let today = Date()
    
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
    
    
    //MARK: - Data Source
    private lazy var tableDataSource = UITableViewDiffableDataSource<Int, ClothingItem>(tableView: tableView){
        tableView, indexPath, clothingItem in
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothingItemCell", for: indexPath) as! DropTableViewCell
        cell.nameLabel.text = clothingItem.name
        cell.dateLabel.text = "\(clothingItem.dateReleased ?? self.today)"
        
        
        
        return cell
    }
    
    func createDataSnapShot(){
        var snapshot = NSDiffableDataSourceSnapshot<Int, ClothingItem>()
        snapshot.appendSections([.max])
        snapshot.appendItems(dropList, toSection: .max)
        tableDataSource.apply(snapshot)
    }
    
    func fetchDrop(){
        let fetchRequest  = ClothingItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateReleased", ascending: true)]
        do{
            dropList = try coreDataStack.managedContext.fetch(fetchRequest)
        }catch {
            print("There was an error fetching the droplist: \(error.localizedDescription)")

        }
        DispatchQueue.main.async {
            self.createDataSnapShot()
        }
    }

   
    

    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate methods
        tableView.delegate = self
      
        
        // insert fetch clothing item function
        

    }//: View did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDrop()
        tableView.reloadData()
        
        // printing the saved location of the core data
        let docDirect = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(docDirect
        )
        
    }
    
    //MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem"{
            if let destinationVC = segue.destination as? AddDropItemViewController{
                destinationVC.coreDataStack = coreDataStack
                destinationVC.droplist = dropList
            }
        }
        
    }
    
}//: View Controller


//MARK: - Extensions

extension ViewController: UITableViewDelegate{
    
    // creating the ability to drag and delete a contact
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "Remove"){ [self](_,_, completionHandler) in
            let selected = dropList[indexPath.row]
            coreDataStack.managedContext.delete(selected)
            coreDataStack.saveContext()
            
            dropList.remove(at: indexPath.row)
            createDataSnapShot()
        
       
            completionHandler(true)
         

        }
        deleteItem.image = UIImage(systemName: "scissors")
        deleteItem.backgroundColor = UIColor(named: "red")

        let config = UISwipeActionsConfiguration(actions: [deleteItem])
        return config
    }
    
}


