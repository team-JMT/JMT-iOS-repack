//
//  ServiceUserVC.swift
//  JMTeng
//
//  Created by 이지훈 on 2/22/24.
//

import Foundation
import UIKit
import WebKit

class ServiceUseVC: UIViewController {
    
    var viewModel: ServiceUseViewModel?
  
    @IBOutlet weak var wkweb: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    private func loadWebView() {
        if let url = URL(string: "https://sticky-gymnast-69e.notion.site/500db50080704b0ea084aa7295e38ab5?pvs=4") {
            let request = URLRequest(url: url)
            wkweb.load(request)
        }
    }

}
