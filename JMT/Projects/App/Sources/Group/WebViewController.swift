//
//  WebViewViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/21/24.

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var webViewGroup: UIView!
    
    var webView: WKWebView!
    var url: String?
    var request: URLRequest?
    
    var webViewBottomConstraint: Constraint?
    var keychainAccess: KeychainAccessible = DefaultKeychainAccessible()

    
    
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
            if let accessToken = DefaultKeychainService.shared.accessToken {
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
            webView.load(request)
        }
    }
    
    func loadRequest() {
        guard let request = self.request else {
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
            webViewBottomConstraint?.update(inset: keyboardHeight)
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        webViewBottomConstraint?.update(inset: 0)
        view.layoutIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "webviewBridge" {
            guard let messageString = message.body as? String,
                  let messageData = messageString.data(using: .utf8) else {
                print("Invalid message format")
                return
            }
            
            decodeAndHandleMessage(messageData)
        }
    }
    
    private func decodeAndHandleMessage(_ messageData: Data) {
        let decoder = JSONDecoder()
        if let message = try? decoder.decode(WebBridgeRequest.self, from: messageData) {
            handleBridgeRequest(message)
        } else {
            print("Error decoding bridge request")
        }
    }
//    
//    private func callJavaScriptFunction(functionName: String) {
//        let script = "\(functionName)();" // 예: setAccessToken() 형태로 JavaScript 함수 호출
//        webView.evaluateJavaScript(script, completionHandler: { (result, error) in
//            if let error = error {
//                print("JavaScript 실행 오류: \(error.localizedDescription)")
//            } else {
//                print("JavaScript 함수 실행 결과: \(String(describing: result))")
//            }
//        })
//    }
//    
    private func handleTokenRequest(_ request: WebBridgeRequest) {
        if let token = keychainAccess.getToken("accessToken") {
            guard let onSuccess = request.onSuccess else {
                print("onSuccess callback not provided.")
                return
            }
            webView.evaluateJavaScript("\(onSuccess)('\(token)')") { result, error in
                if let error = error {
                    print("Error executing onSuccess JavaScript: \(error)")
                } else {
                    print("Successfully executed onSuccess JavaScript with token: \(String(describing: result))")
                }
            }
        } else {
            guard let onFailed = request.onFailed else {
                print("onFailed callback not provided.")
                return
            }
            webView.evaluateJavaScript("\(onFailed)('Token not available')") { result, error in
                if let error = error {
                    print("Error executing onFailed JavaScript: \(error)")
                } else {
                    print("Successfully executed onFailed JavaScript.")
                }
            }
        }
    }

    // handleBridgeRequest 함수 내에서 handleTokenRequest 함수 호출
    private func handleBridgeRequest(_ request: WebBridgeRequest) {
        switch request.name {
        case "token":
            handleTokenRequest(request) // 올바른 인스턴스를 전달합니다.
        case "back":
            if let enable = request.data?.enable {
                handleBackAction(enable: enable)
            }
        case "navigation":
            if let isVisible = request.data?.isVisible {
                handleNavigationVisibility(isVisible: isVisible)
            }
        case "share":
            handleShareEvent()
        case "navigate":
            if let route = request.data?.route {
                navigateToRoute(route: route)
            }
        default:
            print("Unhandled action: \(request.name)")
        }
    }

    
    
    
    private func handleReceivedToken(_ token: String) {
        print("Received token: \(token)")
        DefaultKeychainService.shared.accessToken = token
    }
    
    private func handleBackAction(enable: Bool) { // enable 값을 인자로 받습니다.
        print("'back' request received, enable: \(enable)")
        // 여기서 뒤로 가기 동작을 구현하거나 enable 값에 따른 추가적인 로직을 추가합니다.
    }
    
    
    
    private func handleNavigationVisibility(isVisible: Bool) {
        if let tabBar = self.tabBarController?.tabBar {
            if isVisible {
                tabBar.layer.zPosition = 0
                tabBar.isUserInteractionEnabled = true
            } else {
                tabBar.layer.zPosition = -1
                tabBar.isUserInteractionEnabled = false
            }
            print("Navigation visibility: \(isVisible)")
        }
    }
    
    
    private func handleShareEvent() {
        guard let url = webView.url else {
            print("No URL to share.")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    private func navigateToRoute(route: String) {
        let baseURL = "https://jmt-matzip.dev/detail/"
        let targetURLString = baseURL + route
        if let targetURL = URL(string: targetURLString) {
            webView.load(URLRequest(url: targetURL))
        } else {
            print("Invalid URL: \(targetURLString)")
        }
        print("Navigate to route: \(route)")
    }
}

struct WebBridgeRequest: Decodable {
    let name: String
    let data: BridgeEventData?
    let onSuccess: String?
    let onFailed: String?
}


struct BridgeEventData: Decodable {
    let enable: Bool?
    let isVisible: Bool?
    let route: String?
}
