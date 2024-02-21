//
//  GroupViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit
//import WebKit


class GroupViewController: UIViewController {
    
    var viewModel: GroupViewModel?
    
    //@IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var tf: UITextField!
    
    //    override func loadView() {
    //
    //
    //        let webConfiguration = WKWebViewConfiguration()
    //        webView = WKWebView(frame: .zero, configuration: webConfiguration)
    //        webView.uiDelegate = self
    //        view = webView
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        let myURL = URL(string:"https://jmt-frontend-ad7b8.web.app/")
        //        let myRequest = URLRequest(url: myURL!)
        // webView.load(myRequest)
        
    }
    
    @IBAction func goOrginWeb(_ sender: Any) {


        let storyboard = UIStoryboard(name: "Group", bundle: nil)
        if let webVc = storyboard.instantiateViewController(withIdentifier: "OriginWebViewController") as? OriginWebViewController {
            self.navigationController?.pushViewController(webVc, animated: true)
        }
    }

    
    @IBAction func goUrl(_ sender: Any) {
        guard let urlText = tf.text, !urlText.isEmpty else { return }
        
        if let navigationController = self.navigationController, !(navigationController.topViewController is WebViewController) {
            let storyboard = UIStoryboard(name: "Group", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
                // 사용자가 입력한 URL을 WebViewController의 url 프로퍼티로 직접 전달합니다.
                viewController.url = urlText
                
                navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    
}
