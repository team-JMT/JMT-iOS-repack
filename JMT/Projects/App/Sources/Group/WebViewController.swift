//
//  WebViewViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/21/24.
//

import UIKit
import WebKit
import SnapKit

//class WebViewController: UIViewController {
//
//    @IBOutlet weak var webViewGroup: UIView!/** 배경 뷰 */
//
//    private var webView: WKWebView!/** 웹 뷰 */
//
//    var search: String!/** 검색어 */
//    var url: String!/** url */
//
//
//    /** life cycle */
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        /** 네비게이션 바 타이틀 */
//        self.navigationItem.title = search
//
//        let preferences = WKPreferences()
//        preferences.javaScriptEnabled = true
//        preferences.javaScriptCanOpenWindowsAutomatically = true
//
//        let contentController = WKUserContentController()
//        contentController.add(self, name: "bridge")
//
//        let configuration = WKWebViewConfiguration()
//        configuration.preferences = preferences
//        configuration.userContentController = contentController
//
//        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
//
//        var components = URLComponents(string: url)!
//        components.queryItems = [ URLQueryItem(name: "query", value: search) ]
//
//        guard let url = components.url else {
//            print("유효하지 않은 URL입니다.")
//            return
//        }
//        let request = URLRequest(url: url)
//        webView.load(request)
//
//
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
//        webViewGroup.addSubview(webView)
//        setAutoLayout(from: webView, to: webViewGroup)
//        webView.load(request)
//
//        webView.alpha = 0
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
//            self.webView.alpha = 1
//        }) { _ in
//
//        }
//
//    }
//
//    /** auto leyout 설정 */
//    public func setAutoLayout(from: UIView, to: UIView) {
//
//        from.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.init(item: from, attribute: .leading, relatedBy: .equal, toItem: to, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint.init(item: from, attribute: .trailing, relatedBy: .equal, toItem: to, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint.init(item: from, attribute: .top, relatedBy: .equal, toItem: to, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint.init(item: from, attribute: .bottom, relatedBy: .equal, toItem: to, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
//        view.layoutIfNeeded()
//    }
//
//}
//
//extension WebViewController: WKNavigationDelegate {
//
//    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        print("\(navigationAction.request.url?.absoluteString ?? "")" )
//
//        decisionHandler(.allow)
//    }
//}
//
//extension WebViewController: WKUIDelegate {
//
//    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//
//    }
//}
//
//extension WebViewController: WKScriptMessageHandler {
//
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//
//        print(message.name)
//    }
//}

class WebViewController: UIViewController {
    
    @IBOutlet weak var webViewGroup: UIView!
    
    var webView: WKWebView!
    var url: String?
    
    
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      self.navigationController?.setNavigationBarHidden(true, animated: true)
      setCustomNavigationBarBackButton(isSearchVC: false)
  }

    
      override func viewDidLoad() {
          super.viewDidLoad()
          
          setupWebView()
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
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
    }
}
