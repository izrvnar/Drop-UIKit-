//
//  ClosetViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-06-13.
//

import UIKit

class ClosetViewController: UIViewController, CellTapDelegate {
    func closetButtonTapped(cell: DropTableViewCell) {
        
    }
    
    func buttonTapped(cell: DropTableViewCell) {
        
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
    
    //MARK: - Data Source
    private lazy var tableDataSource = UITableViewDiffableDataSource<Int, ClothingItem>(tableView: closetTableView){ [self]
        tableView, indexPath, clothingItem in
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothingItemCell", for: indexPath) as! DropTableViewCell
        cell.nameLabel.text = clothingItem.name
        cell.dateLabel.text = (self.dateFormatter.string(from:clothingItem.dateReleased ?? today))
        cell.layer.cornerRadius = 40
        
        
        cell.delegate = self

        return cell
    }
    
    func createDataSnapShot(){
        var snapshot = NSDiffableDataSourceSnapshot<Int, ClothingItem>()
        snapshot.appendSections([.max])
        snapshot.appendItems(userCloset, toSection: .max)
        tableDataSource.apply(snapshot)
    }
    
    func fetchCloset(){
        let fetchRequest  = ClothingItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateReleased", ascending: true)]
        do{
            userCloset = try coreDataStack.managedContext.fetch(fetchRequest)
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
    
    @IBAction func hideMenu(_ sender: Any) {
        if displayMenu == true{
            hideMenu()
            displayMenu = false
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        
        if let indexPath = menuTableView.indexPathForSelectedRow {
            let currentCell = (tableView.cellForRow(at: indexPath) ?? UITableViewCell()) as UITableViewCell
            
            currentCell.alpha = 0.5
            UITableView.animate(withDuration: 1, animations: {
            currentCell.alpha = 1
                
            })
            
            
        }
        
    }
    
    
}

