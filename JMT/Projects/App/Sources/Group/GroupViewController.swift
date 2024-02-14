//
//  GroupViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit
import WebKit


class GroupViewController: UIViewController, WKUIDelegate {

    var viewModel: GroupViewModel?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func loadView() {
        
        
           let webConfiguration = WKWebViewConfiguration()
           webView = WKWebView(frame: .zero, configuration: webConfiguration)
           webView.uiDelegate = self
           view = webView
       }


       override func viewDidLoad() {
           super.viewDidLoad()
           
           let myURL = URL(string:"https://jmt-frontend-ad7b8.web.app/")
           let myRequest = URLRequest(url: myURL!)
           webView.load(myRequest)
       }

}
