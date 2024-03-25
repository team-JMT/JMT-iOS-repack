////
////  WebViewViewController.swift
////  JMTeng
////
////  Created by 이지훈 on 2/21/24.
//
//import UIKit
//import WebKit
//import SnapKit
//
//class WebViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler {
//    
//    @IBOutlet weak var webViewGroup: UIView!
//    
//    var webView: WKWebView!
//    var url: String?
//    var request: URLRequest?
//    
//    var webViewBottomConstraint: Constraint?
//    var keychainAccess: KeychainAccessible = DefaultKeychainAccessible()
//    
//<<<<<<< HEAD
//=======
//  override func viewWillAppear(_ animated: Bool) {
//      super.viewWillAppear(animated)
//      
//      self.navigationController?.setNavigationBarHidden(true, animated: true)
//      setCustomNavigationBarBackButton(goToViewController: .popVC)
//  }
//
//>>>>>>> ea32156181f806bd467e587fc84a68ed5959a176
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        setCustomNavigationBarBackButton(isSearchVC: false)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupWebView()
//        loadRequest()
//    }
//    
//    func setupWebView() {
//        let contentController = WKUserContentController()
//        contentController.add(self, name: "webviewBridge")
//        
//        let config = WKWebViewConfiguration()
//        config.userContentController = contentController
//        
//        webView = WKWebView(frame: .zero, configuration: config)
//        webViewGroup.addSubview(webView)
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        
//        webView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.equalToSuperview()
//        }
//        
//<<<<<<< HEAD
//        loadInitialRequest()
//=======
////        if let url = URL(string: url ?? "") {
////            var request = URLRequest(url: url)
////            let accessToken = DefaultKeychainService.shared.accessToken ?? ""
////            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
////            webView.load(request)
////        }
//        
//        webView.snp.makeConstraints { make in
//                    make.top.leading.trailing.equalToSuperview()
//                    // webViewBottomConstraint를 사용하여 하단 제약을 설정
//                    self.webViewBottomConstraint = make.bottom.equalToSuperview().constraint
//                }
//>>>>>>> ea32156181f806bd467e587fc84a68ed5959a176
//    }
//    
//    func loadInitialRequest() {
//        if let urlString = self.url, let url = URL(string: urlString) {
//            var request = URLRequest(url: url)
//            if let accessToken = DefaultKeychainService.shared.accessToken {
//                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//            }
//            webView.load(request)
//        }
//    }
//    
//    func loadRequest() {
//        guard let request = self.request else {
//            print("URLRequest is not available")
//            return
//        }
//        webView.load(request)
//    }
//    
//    func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            webViewBottomConstraint?.update(inset: keyboardHeight)
//            view.layoutIfNeeded()
//        }
//    }
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        webViewBottomConstraint?.update(inset: 0)
//        view.layoutIfNeeded()
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        if message.name == "webviewBridge" {
//            guard let messageString = message.body as? String,
//                  let messageData = messageString.data(using: .utf8) else {
//                print("Invalid message format")
//                return
//            }
//            
//            decodeAndHandleMessage(messageData)
//        }
//        
//        if message.name == "callbackHandler" {
//            // 메시지 내용 파싱
//            guard let messageBody = message.body as? String,
//                  let messageData = messageBody.data(using: .utf8),
//                  let jsonObject = try? JSONSerialization.jsonObject(with: messageData, options: []) as? [String: AnyObject],
//                  let event = jsonObject["event"] as? String else {
//                print("Invalid message format")
//                return
//            }
//            
//            // 라우트 이벤트 처리
//            switch event {
//            case "navigate":
//                if let route = jsonObject["route"] as? String {
//                    navigateToRoute(route: route, params: jsonObject)
//                }
//            default:
//                print("Unhandled event: \(event)")
//                
//            }
//        }
//        
//        
//        // 라우트에 따른 이동 로직
//        func navigateToRoute(route: String, params: [String: AnyObject]) {
//            // 예시: 라우트 이름에 따라 다른 ViewController로 이동
//            switch route {
//            case "editRestaurant":
//                if let restaurantId = params["restaurantId"] as? String {
//                    // `restaurantId`를 사용하여 레스토랑 수정 페이지로 이동하는 로직 구현
//                    print("Navigate to editRestaurant with ID: \(restaurantId)")
//                }
//            default:
//                print("Unknown route: \(route)")
//            }
//        }
//    }
//    
//    private func decodeAndHandleMessage(_ messageData: Data) {
//        let decoder = JSONDecoder()
//        if let message = try? decoder.decode(WebBridgeRequest.self, from: messageData) {
//            handleBridgeRequest(message)
//        } else {
//            print("Error decoding bridge request")
//        }
//    }
//    
//    private func handleTokenRequest(_ request: WebBridgeRequest) {
//        if let token = keychainAccess.getToken("accessToken") {
//            guard let onSuccess = request.onSuccess else {
//                print("onSuccess callback not provided.")
//                return
//            }
//            webView.evaluateJavaScript("\(onSuccess)('\(token)')") { result, error in
//                if let error = error {
//                    print("Error executing onSuccess JavaScript: \(error)")
//                } else {
//                    print("Successfully executed onSuccess JavaScript with token: \(String(describing: result))")
//                }
//            }
//        } else {
//            guard let onFailed = request.onFailed else {
//                print("onFailed callback not provided.")
//                return
//            }
//            webView.evaluateJavaScript("\(onFailed)('Token not available')") { result, error in
//                if let error = error {
//                    print("Error executing onFailed JavaScript: \(error)")
//                } else {
//                    print("Successfully executed onFailed JavaScript.")
//                }
//            }
//        }
//    }
//    
//    
//    private func navigateToRoute(route: String, groupId: Int) {
//        // 'PlaceAdd' 라우트에 대한 처리
//        if route == "PlaceAdd" {
//            // groupId를 사용하여 맛집 등록 페이지로 이동하는 로직을 구현합니다.
//            print("Navigate to PlaceAdd with groupId: \(groupId)")
//            // 예시: `PlaceAddViewController`로의 이동 로직을 구현할 수 있습니다.
//        } else {
//            print("Unknown route: \(route)")
//        }
//    }
//    
//    // handleBridgeRequest 함수 내에서 handleTokenRequest 함수 호출
//    private func handleBridgeRequest(_ request: WebBridgeRequest) {
//        switch request.name {
//        case "token":
//            handleTokenRequest(request) // 올바른 인스턴스를 전달합니다.
//        case "back":
//            if let enable = request.data?.enable {
//                handleBackAction(enable: enable)
//            }
//        case "navigate":
//               if let route = request.data?.route, let groupId = request.data?.groupId {
//                   navigateToRoute(route: route, groupId: groupId)
//               }
//        case "share":
//            handleShareEvent()
//        case "navigate":
//            if let route = request.data?.route {
//                navigateToRoute(route: route)
//            }
//        default:
//            print("Unhandled action: \(request.name)")
//        }
//    }
//    
//    
//    
//    
//    private func handleReceivedToken(_ token: String) {
//        print("Received token: \(token)")
//        DefaultKeychainService.shared.accessToken = token
//    }
//    
//    private func handleBackAction(enable: Bool) { // enable 값을 인자로 받습니다.
//        print("'back' request received, enable: \(enable)")
//        // 여기서 뒤로 가기 동작을 구현하거나 enable 값에 따른 추가적인 로직을 추가합니다.
//    }
//    
//    
//    
//    private func handleNavigationVisibility(isVisible: Bool) {
//        if let tabBar = self.tabBarController?.tabBar {
//            if isVisible {
//                tabBar.layer.zPosition = 0
//                tabBar.isUserInteractionEnabled = true
//            } else {
//                tabBar.layer.zPosition = -1
//                tabBar.isUserInteractionEnabled = false
//            }
//            print("Navigation visibility: \(isVisible)")
//        }
//    }
//    
//    
//    private func handleShareEvent() {
//        guard let url = webView.url else {
//            print("No URL to share.")
//            return
//        }
//        
//        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//        present(activityViewController, animated: true, completion: nil)
//        
//    }
//    
//    private func navigateToRoute(route: String) {
//        let baseURL = "https://jmt-matzip.dev/detail/"
//        let targetURLString = baseURL + route
//        if let targetURL = URL(string: targetURLString) {
//            webView.load(URLRequest(url: targetURL))
//        } else {
//            print("Invalid URL: \(targetURLString)")
//        }
//        print("Navigate to route: \(route)")
//    }
//    
//}
//
//struct WebBridgeRequest: Decodable {
//    let name: String
//    let data: BridgeEventData?
//    let onSuccess: String?
//    let onFailed: String?
//}
//
//
//struct BridgeEventData: Decodable {
//    let groupId: Int?  
//    let enable: Bool?
//    let isVisible: Bool?
//    let route: String?
//}
