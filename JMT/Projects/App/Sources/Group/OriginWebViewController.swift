//
//  OriginWebViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/21/24.
//

import UIKit
import WebKit


class OriginWebViewController: UIViewController, WKUIDelegate {
    
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
