//
//  OriginWebViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/21/24.
//

import UIKit
import WebKit


class OriginWebViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler {
    
    
    var keychainAccess: KeychainAccessible = DefaultKeychainAccessible()
    
    var viewModel: GroupViewModel?
    var accessToken: String?
    
    
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(self, name: "webviewBridge") // webviewBridge 핸들러 추가
        webConfiguration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 액세스 토큰이 있을 경우, 해당 토큰을 사용하여 요청
        if let accessToken = accessToken {
            // 웹뷰에 로드할 URL 설정. 예시 URL을 실제 사용하는 URL로 변경해야 함
            let url = URL(string: "https://jmt-frontend-ad7b8.web.app/")!
            var request = URLRequest(url: url)
            // HTTP 헤더에 Authorization 토큰 추가
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            webView.load(request)
        } else {
            // 액세스 토큰이 없을 경우, 기본 URL 로드
            let myURL = URL(string: "https://jmt-frontend-ad7b8.web.app/")!
            print("non-url")
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        }
    }
    
    
    
    
    
    func fetchAccessToken(completion: @escaping (String?) -> Void) {
        // 키체인에서 액세스 토큰 가져오기
        if let accessToken = keychainAccess.getToken("accessToken") {
            completion(accessToken)
        } else {
            completion(nil)
            print("Access token is not available")
        }
    }
    
    func handleTabBarVisibility(isVisible: Bool) {
        if let tabBar = self.tabBarController?.tabBar {
            if isVisible {
                tabBar.layer.zPosition = 0
                tabBar.isUserInteractionEnabled = true
            } else {
                tabBar.layer.zPosition = -1
                tabBar.isUserInteractionEnabled = false
            }
        }
    }
    
    // 공유하기 이벤트 발생시키기
    func handleShareEvent() {
        guard let url = webView.url else {
            print("No URL to share.")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    //원하는 라우터로 이동하기 (식당)
    func loadWebViewWithRoute(route: String) {
        let baseURL = "https://jmt-matzip.dev/detail/"
        let targetURLString = baseURL + route
        if let targetURL = URL(string: targetURLString) {
            webView.load(URLRequest(url: targetURL))
        } else {
            print("Invalid URL: \(targetURLString)")
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 메시지 이름이 "webviewBridge"인지 확인
        guard message.name == "webviewBridge",
              let bodyString = message.body as? String,
              let data = bodyString.data(using: .utf8) else {
            print("Unable to decode the bridge request")
            return
        }
        
        // 메시지 내용을 BridgeRequest로 디코딩
        let decoder = JSONDecoder()
        if let bridgeRequest = try? decoder.decode(BridgeRequest.self, from: data) {
            // 이벤트 이름에 따라 처리
            handleBridgeRequest(bridgeRequest)
        } else {
            print("Error decoding BridgeRequest")
        }
    }
    
    private enum WebRequest: String {
        case back = "back"
        case token = "token"
        case navigation = "navigation"
        case share = "share"
        case navigate = "navigate"
    }

    
    private func handleBridgeRequest(_ request: BridgeRequest) {
        switch request.name {
        case "token":
            handleTokenRequest(request)
        case "back":
            handleBackRequest(request)
        case "navigation":
            handleNavigationRequest(request)
        case "share":
            handleShareRequest()
        case "navigate":
            if let route = request.data?.route {
                loadWebViewWithRoute(route: route)
            }
        default:
            print("Unhandled bridge request: \(request.name)")
        }
    }
    
    private func handleTokenRequest(_ request: BridgeRequest) {
        if let token = keychainAccess.getToken("accessToken") {
            guard let onSuccess = request.onSuccess else {
                print("onSuccess callback not provided.")
                return
            }
            webView.evaluateJavaScript("\(onSuccess)('\(token)')") { result, error in
                if let error = error {
                    print("Error executing onSuccess JavaScript: \(error)")
                } else {
                    print("Successfully executed onSuccess JavaScript with token: \(token)")
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
    
    
    private func handleBackRequest(_ request: BridgeRequest) {
        if let enable = request.data?.enable {
            print("'back' request received, enable: \(enable)")
        }
    }

    private func handleNavigationRequest(_ request: BridgeRequest) {
        if let isVisible = request.data?.isVisible {
            print("'navigation' request received, isVisible: \(isVisible)")
            handleTabBarVisibility(isVisible: isVisible)
        }
    }

    private func handleShareRequest() {
        print("'share' request received")
        handleShareEvent()
    }

    
}


struct BridgeRequest: Decodable {
    let name: String
    let data: WebEventData?
    let onSuccess: String?
    let onFailed: String?
}

struct WebEventData: Decodable {
    let route: String?
    let enable: Bool?
    let isVisible: Bool?
}


 struct WebEvent: Decodable {
    let event: String
    let isEnableBack: Bool?
    let isTabBarVisible: Bool?
    let route: String?
}

 struct WebBridgeEvent: Decodable {
    let name: String
    let data: WebEventData
    let onSuccess: String
    let onFailed: String
}
