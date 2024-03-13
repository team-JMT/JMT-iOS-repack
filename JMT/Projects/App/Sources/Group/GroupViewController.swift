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
        guard let accessToken = DefaultKeychainService.shared.accessToken else {
            print("Access token is not available")
            return
        }
        
        let storyboard = UIStoryboard(name: "Group", bundle: nil)
        if let webVc = storyboard.instantiateViewController(withIdentifier: "OriginWebViewController") as? OriginWebViewController {
            webVc.accessToken = accessToken
            self.navigationController?.pushViewController(webVc, animated: true)
            print("Navigating to OriginWebViewController with access token:", accessToken)
        }
    }
    
    
    
    @IBAction func didTabShowCustomURLButton(_ sender: Any) {
        guard let urlString = tf.text, !urlString.isEmpty, let url = URL(string: urlString),
              let accessToken = DefaultKeychainService.shared.accessToken else {
            print("URL text or Access token is not available")
            return
        }
        
        // URLRequest 객체 생성
        var request = URLRequest(url: url)
        // HTTP 헤더에 엑세스 토큰 추가
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // WebViewController 인스턴스 생성 및 요청 객체 전달
        let storyboard = UIStoryboard(name: "Group", bundle: nil)
        if let webViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            webViewController.request = request // WebViewController에서 request 프로퍼티를 정의해야 함
            self.navigationController?.pushViewController(webViewController, animated: true)
            print("Navigating with URL: \(urlString)")
            print("Access Token: \(accessToken)")
        }
    }
}
