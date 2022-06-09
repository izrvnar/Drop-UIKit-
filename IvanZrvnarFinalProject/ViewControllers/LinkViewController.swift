//
//  LinkViewController.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-05-23.
//

import UIKit
import WebKit

class LinkViewController: UIViewController, WKUIDelegate {
    //MARK: - Properties
    var clothingItem : ClothingItem!


    
    //MARK: - Outlets
    @IBOutlet var webView: WKWebView!
    

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let link = clothingItem.urlLink else { return }
        guard let myURL = URL(string:link) else { return }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }

}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */




