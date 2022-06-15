//
//  ViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-05-20.
//

import UIKit

class ViewController: UIViewController{
    
    
    //MARK: - Properties
    var coreDataStack : CoreDataStack!
    var clothingItem = ClothingItem()
    // array of clothes
    var dropList = [ClothingItem]()
    let today = Date()
    var userCloset : [ClothingItem]!
    


    
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
    private lazy var tableDataSource = UITableViewDiffableDataSource<Int, ClothingItem>(tableView: tableView){ [self]
        tableView, indexPath, clothingItem in
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothingItemCell", for: indexPath) as! DropTableViewCell
        cell.nameLabel.text = clothingItem.name
        cell.dateLabel.text = (self.dateFormatter.string(from:clothingItem.dateReleased ?? today))
        
        
        cell.delegate = self

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
      
        
       // requesting notification from user
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge,.sound], completionHandler: {
            granted, error in
            
            if granted {
                print("Access has been granted")
            } else {
                print("Access has not been granted")
            }
        })
    
        
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
        } else if segue.identifier == "itemLink"{
            if let desintationVC = segue.destination as? LinkViewController{
                guard let selectedIndex = tableView.indexPathForSelectedRow else {return}
                let itemToPass = tableDataSource.itemIdentifier(for: selectedIndex)
                desintationVC.clothingItem = itemToPass!
            }
        } else if segue.identifier == "editItem"{
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let passedItem = dropList[indexPath.row]
            if let destinationVC = segue.destination as? AddDropItemViewController {
                destinationVC.coreDataStack = coreDataStack
                destinationVC.clothingItem = passedItem
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

extension ViewController: CellTapDelegate{
    func closetButtonTapped(cell: DropTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        guard let closetItem = tableDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        userCloset.append(closetItem)
        
        
        
    }
    
    func buttonTapped(cell: DropTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
               
        let destinationVC = LinkViewController()
        guard let itemToPass = tableDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        destinationVC.clothingItem = itemToPass
        
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }

    
}


