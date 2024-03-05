//
//  File.swift
//  JMTeng
//
//  Created by 이지훈 on 2/22/24.
//


import UIKit
import WebKit

class ServiceTermsVC: UIViewController {

    var viewModel = ServiceTermsViewModel()
    
    @IBOutlet weak var wkweb: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    private func loadWebView() {
        if let url = URL(string: "https://sticky-gymnast-69e.notion.site/b46471d11dac4fae995704d35bf93192?pvs=4") {
            let request = URLRequest(url: url)
            wkweb.load(request)
        }
    }
}
