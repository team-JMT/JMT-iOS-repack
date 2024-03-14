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
    var request: URLRequest? 
    
    var webViewBottomConstraint: Constraint?

    
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
        
        webView.snp.makeConstraints { make in
                    make.top.leading.trailing.equalToSuperview()
                    // webViewBottomConstraint를 사용하여 하단 제약을 설정
                    self.webViewBottomConstraint = make.bottom.equalToSuperview().constraint
                }
    }
    
    
    func loadRequest() {
        guard let request = request else {
            print("URLRequest is not available")
            return
        }
        
        webView.load(request)
    }
    
    func setupKeyboardObservers() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
       @objc func keyboardWillShow(notification: NSNotification) {
           if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
               let keyboardHeight = keyboardRectangle.height
               // 키보드 높이만큼 webViewBottomConstraint 조정
               webViewBottomConstraint?.update(inset: keyboardHeight)
               view.layoutIfNeeded()
           }
       }

       @objc func keyboardWillHide(notification: NSNotification) {
           // 키보드가 숨겨질 때 하단 제약을 원래대로 조정
           webViewBottomConstraint?.update(inset: 0)
           view.layoutIfNeeded()
       }
       
       deinit {
           // 옵저버 제거
           NotificationCenter.default.removeObserver(self)
       }
    
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
    }
}
