//
//  LinkViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-05-23.
//

import UIKit
import WebKit

class LinkViewController: UIViewController {
    //MARK: - Properties
    var clothingItem = ClothingItem()


    
    //MARK: - Outlets
    @IBOutlet var webView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(clothingItem)
        webView.load(clothingItem.urlLink!)
        
        
        
     
        
     
        
        

        // Do any additional setup after loading the view.
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


extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
