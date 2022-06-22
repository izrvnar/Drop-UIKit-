//
//  ClosetViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-06-13.
//

import UIKit

class ClosetViewController: UIViewController{
    
    // enum for sorting
    enum TableSort: String {
        case all
        case shoes
        case shirts
        case pants
        case accessories
        case other
    }
    //MARK: - Properties
    var menuOptions:[menuOption] = [
        menuOption(title: "All"),
        menuOption(title: "Shoes"),
        menuOption(title: "Shirts"),
        menuOption(title: "Pants"),
        menuOption(title: "Accessories"),
        menuOption(title: "Other")
    ]
    let today = Date()
    
    // document library property
    var documentLibrary: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(paths[0])
        
        return paths[0]
    }
    
    
    
    
    //date formatter for label
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .none
        df.doesRelativeDateFormatting = true
        df.dateStyle = .medium
        return df
    }()
    
    // properties for menu
    var displayMenu = false
    let screen = UIScreen.main.bounds
    var home = CGAffineTransform()
    
    // creating the user closet
    var userCloset = [ClothingItem]()
    var coreDataStack : CoreDataStack!
    // default sort order
    var sortOrder: TableSort = .all
    //create a new property to load all the sorted items
    var sortedTable = [ClothingItem]()
    
    
    //MARK: - Data Source
    private lazy var tableDataSource = UITableViewDiffableDataSource<Int, ClothingItem>(tableView: closetTableView){ [self]
        tableView, indexPath, clothingItem in
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothingItemCell", for: indexPath) as! DropTableViewCell
        cell.nameLabel.text = clothingItem.name
        cell.dateLabel.text = (self.dateFormatter.string(from:clothingItem.dateReleased ?? today))
        
        // fetching image
        if let clothingImage = clothingItem.image{
            cell.clothingItemImageView.image = fetchImage(withIdentifier: clothingImage)
        }
        
        
        return cell
    }
    
    func createDataSnapShot(){
        var snapshot = NSDiffableDataSourceSnapshot<Int, ClothingItem>()
        snapshot.appendSections([.max])
        //display the sorted table results
        snapshot.appendItems(sortedTable, toSection: .max)
        tableDataSource.apply(snapshot)
    }
    
    func fetchCloset(){
        let fetchRequest  = ClothingItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateReleased", ascending: true)]
        do{
            userCloset = try coreDataStack.managedContext.fetch(fetchRequest)
            //copy the fetched results into the sorted array - this will be the actual data for this view
            sortedTable = userCloset
        }catch {
            print("There was an error fetching the droplist: \(error.localizedDescription)")
            
        }
        DispatchQueue.main.async {
            self.createDataSnapShot()
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet var closetTableView: UITableView!
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBAction func showMenu(_ sender: UISwipeGestureRecognizer) {
        if displayMenu == false && swipeGesture.direction == .right{
            showMenu()
            displayMenu = true
        }
    }

    struct menuOption{
        var title = String()
    }
    
    
    //MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.backgroundColor = .clear
        
        closetTableView.delegate = self
        
        home = closetTableView.transform
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add fetch closet
        fetchCloset()
        closetTableView.reloadData()
    }
    
    
    //MARK: - Methods
    func showMenu() {
        
        self.closetTableView.layer.cornerRadius = 40
        // self.viewBG.layer.cornerRadius = self.containerView.layer.cornerRadius
        let x = screen.width * 0.8
        let originalTransform = self.closetTableView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.8, y: 0.8)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x, y: 0)
        UITableView.animate(withDuration: 0.7, animations: {
            self.closetTableView.transform = scaledAndTranslatedTransform
        })
    }
    
    func hideMenu() {
        
        UITableView.animate(withDuration: 0.7, animations: {
            
            self.closetTableView.transform = self.home
            self.closetTableView.layer.cornerRadius = 0
        })
    }
    
    // sort table function
    func sortTable(){
        //determine the sort order and load all of the sorted results into the sorted table
        switch sortOrder {
        case .all:
            sortedTable = userCloset.sorted(by: {$0.dateReleased! > $1.dateReleased!})
        case .shoes:
            sortedTable = userCloset.filter{$0.type == "Shoes"}
        case .shirts:
            sortedTable = userCloset.filter{$0.type == "Shirt"}
        case .pants:
            sortedTable = userCloset.filter{$0.type == "Pants"}
        case .accessories:
            sortedTable = userCloset.filter{$0.type == "Accessories"}
        case .other:
            sortedTable = userCloset.filter{$0.type == "Other"}
        }
    }
    
    // fetch image method
    func fetchImage(withIdentifier id: String) -> UIImage?{
        if let imagePath = documentLibrary?.appendingPathComponent(id), let imageFromDisk = UIImage(contentsOfFile: imagePath.path){
            return imageFromDisk
    }
        return nil
}
    
}//: end of view controller

extension ClosetViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        cell.backgroundColor = .clear
        cell.descriptionLabel.text = menuOptions[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //make sure we are selecting in the menutableview, not the closet tableview since BOTH will call this method.
        if tableView == menuTableView {
        if let indexPath = menuTableView.indexPathForSelectedRow {
            let currentCell = (menuTableView.cellForRow(at: indexPath) ?? UITableViewCell()) as UITableViewCell
            //check to see what row we selected and set the specified sort order
            switch indexPath.row {
            case 0:
                sortOrder = .all
            case 1:
                sortOrder = .shoes
            case 2:
                sortOrder = .shirts
            case 3:
                sortOrder = .pants
            case 4:
                sortOrder = .accessories
            default:
                sortOrder = .other
            }
            //sort the table
            sortTable()
            //update the snapshot so the table reloads with just the sorted items
            createDataSnapShot()
            
            currentCell.alpha = 0.5
            UITableView.animate(withDuration: 1, animations: {
                currentCell.alpha = 1
                
            })
        }
            
            if displayMenu == true{
                hideMenu()
                displayMenu = false
            }

        }
        
    }
    
}



