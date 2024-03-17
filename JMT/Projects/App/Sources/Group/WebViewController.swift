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
        // "bridge"에서 "webviewBridge"로 이름 변경
        contentController.add(self, name: "webviewBridge")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        webViewGroup.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        loadInitialRequest()
    }

    func loadInitialRequest() {
        if let urlString = self.url, let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            // 여기에서 액세스 토큰을 추가
            if let accessToken = DefaultKeychainService.shared.accessToken {
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                print("==")
            }
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
        if message.name == "bridge" {
            handleBridgeMessage(message)
        }
    }
    
    private func handleBridgeMessage(_ message: WKScriptMessage) {
        guard let body = message.body as? [String: AnyObject],
              let action = body["name"] as? String else {
            print("Invalid message format")
            return
        }
        
        switch action {
        case "token":
            if let token = body["data"] as? String {
                handleReceivedToken(token)
            }
        // 다른 메시지 유형에 따른 처리를 여기에 추가
        default:
            print("Unhandled action: \(action)")
        }
    }
    
    private func handleReceivedToken(_ token: String) {
        // 토큰을 처리하는 로직, 예를 들어 Keychain에 저장
        print("Received token: \(token)")
        DefaultKeychainService.shared.accessToken = token
        // 필요한 경우 서버로 토큰 전송 등의 추가 작업 수행
    }
}
