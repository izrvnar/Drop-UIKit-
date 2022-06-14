//
//  ClosetViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-06-13.
//

import UIKit

class ClosetViewController: UIViewController {
    
    //MARK: - Properties
    var menuOptions:[menuOption] = [
        menuOption(title: "All"),
        menuOption(title: "Shoes"),
        menuOption(title: "Shirts"),
        menuOption(title: "Pants"),
        menuOption(title: "Accessories"),
        menuOption(title: "Other")
    ]
    
    var displayMenu = false
    let screen = UIScreen.main.bounds
    var home = CGAffineTransform()
    
    
    

    
    
    
    
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
    func showMenu(){
        self.closetTableView.layer.cornerRadius = 40
        // self.viewBG.layer.cornerRadius = self.containerView.layer.cornerRadius
        let x = screen.width * 0.8
        let originalTransform = self.closetTableView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.8, y: 0.8)
            let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x, y: 0)
            UIView.animate(withDuration: 0.7, animations: {
                self.closetTableView.transform = scaledAndTranslatedTransform
            })
        
    }
    
    func hideMenu() {
        
            UIView.animate(withDuration: 0.7, animations: {
                
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
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let currentCell = (tableView.cellForRow(at: indexPath) ?? UITableViewCell()) as UITableViewCell
            
            currentCell.alpha = 0.5
            UIView.animate(withDuration: 1, animations: {
                currentCell.alpha = 1
                
            })
            
            
        }
        
    }
    
    
}

