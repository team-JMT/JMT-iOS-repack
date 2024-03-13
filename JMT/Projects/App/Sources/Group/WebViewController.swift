//
//  WebViewViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/21/24.
//

import UIKit
import WebKit
import SnapKit


class WebViewController: UIViewController {
    
    @IBOutlet weak var webViewGroup: UIView!
    
    var webView: WKWebView!
    var url: String?
    var request: URLRequest? // URLRequest 객체를 받을 프로퍼티

    
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      self.navigationController?.setNavigationBarHidden(true, animated: true)
      setCustomNavigationBarBackButton(isSearchVC: false)
  }

    
      override func viewDidLoad() {
          super.viewDidLoad()
          
          setupWebView()
          loadRequest()
      }
  
    
    func setupWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "bridge")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        webViewGroup.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        if let url = URL(string: url ?? "") {
            var request = URLRequest(url: url)
            let accessToken = DefaultKeychainService.shared.accessToken ?? ""
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            webView.load(request)
        }
    }
    
    
    func loadRequest() {
        guard let request = request else {
            print("URLRequest is not available")
            return
        }
        
        webView.load(request)
    }
    
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
    }
}
