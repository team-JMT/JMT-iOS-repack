//
//  GroupWebViewController.swift
//  JMTeng
//
//  Created by PKW on 3/15/24.
//

import UIKit
import WebKit
import SnapKit

enum WebViewUrl {
    case base
    case createGroup
    case detailGroup(id: Int)
    case none

    var urlString: String {
        switch self {
        case .base:
            return "https://jmt-frontend-ad7b8.web.app/"
        case .createGroup:
            return "https://jmt-frontend-ad7b8.web.app/group-create/name"
        case .detailGroup(let id):
            return "https://jmt-frontend-ad7b8.web.app/group-detail/\(id)/"
        case .none:
            return ""
        }
    }
}

class GroupWebViewController: UIViewController, KeyboardEvent {
    
    var transformView: UIView { self.view }
    
    var viewModel: GroupViewModel?
    var groupId: Int?
    var webViewUrlType: WebViewUrl = .base
    
    private lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        contentController.add(self, name: "webviewBridge")
        
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.userContentController = contentController
    
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardEvent { [weak self] noti in
            guard let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 1.0) {
                self?.webView.snp.updateConstraints({ make in
                    make.bottom.equalToSuperview().offset(-keyboardHeight)
                })
                self?.view.layoutIfNeeded()
            }
        } keyboardWillHide: { [weak self] noti in

            UIView.animate(withDuration: 1.0) {
                self?.webView.snp.updateConstraints({ make in
                    make.bottom.equalToSuperview().offset(0)
                })
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    

    
    func setupWebView() {
        view.addSubview(webView)
    
        webView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            guard let url = self.webView.url?.absoluteString else {
                return
            }
            
            print(url)
            
        }
    }
    
    func loadWebPage() {
        
        var url = ""
        
        switch webViewUrlType {
        case .base:
            url = WebViewUrl.base.urlString
        case .createGroup:
            url = WebViewUrl.createGroup.urlString
        case .detailGroup:
            url = WebViewUrl.detailGroup(id: groupId ?? 0).urlString
        case .none:
            url = ""
        }
        
        let accessToken = DefaultKeychainService.shared.accessToken ?? ""
    
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            webView.load(request)
        }
    }
    
    private func parseJSONStringToDictionary(jsonString: String) -> [String: Any]? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                // JSON 데이터를 딕셔너리로 파싱
                let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                return dictionary
            } catch {
                // 파싱 중 에러 발생
                print("Error parsing JSON string: \(error)")
                return nil
            }
        }
        return nil
    }
    
    private func handleJSONDataBasedOnName(jsonString: String) {
        
        if let dictionary = parseJSONStringToDictionary(jsonString: jsonString),
           let name = dictionary["name"] as? String {
            switch name {
            case "token":
                // 토큰 관련 처리
                if let onSuccess = dictionary["onSuccess"] as? String {
                    handleToken(str: onSuccess)
                }
            case "navigation":
                // 네비게이션 관련 처리
                if let data = dictionary["data"] as? [String: Any], let isVisible = data["isVisible"] as? Bool {
//                    handleNavigation(isVisible: isVisible)
                }
            case "navigate":
                if let data = dictionary["data"] as? [String: Any],
                    let route = data["route"] as? String,
                    let groupId = data["Id"] as? Int {
                    
                    handleNavigate(route: route)
                }
            case "back":
                // 뒤로가기 관련 처리
                if let data = dictionary["data"] as? [String: Any], let enable = data["enable"] as? Bool {
                    handleBack(isEnable: enable)
                }
            case "requestResponse":
                // 로그인 가입 완료 후 홈 화면으로 이동
                // 선택한 그룹으로 변경
                if let data = dictionary["data"] as? [String: Any], let groupId = data["groupId"] as? Int {
                    handleJoinGroup(groupId: groupId)
                }
            default:
                // 알 수 없는 name 값 처리
                print("Unknown name value: \(name)")
            }
        }
    }
    
    func evaluateJavaScriptFunction(functionName: String, parameter: String) {
        let script = "\(functionName)('\(parameter)')"
        webView.evaluateJavaScript(script) { result, error in
            if let error = error {
                print("Error executing JavaScript: \(error)")
            } else {
                print("Successfully executed JavaScript function: \(functionName) with parameter: \(parameter)")
            }
        }
    }
}

extension GroupWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handleJSONDataBasedOnName(jsonString: message.body as? String ?? "")
    }
}

extension GroupWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("11111")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("웹뷰가 콘텐츠를 로드하기 시작했습니다.")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("웹뷰가 콘텐츠 로드를 완료했습니다.")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("웹뷰 로드 중 오류가 발생했습니다: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("웹뷰 콘텐츠 로드 시작 중 오류가 발생했습니다: \(error.localizedDescription)")
    }
}

extension GroupWebViewController: WKUIDelegate {
    
}

// 핸들러 메소드
extension GroupWebViewController {
    
    private func handleToken(str: String) {
        let accessToken = DefaultKeychainService.shared.accessToken ?? ""
        evaluateJavaScriptFunction(functionName: str, parameter: accessToken)
    }
  
    private func handleNavigation(isVisible: Bool) {
        self.tabBarController?.tabBar.isHidden = isVisible
    }
    
    
    private func handleNavigate(route: String) {
        switch route {
        case "registRestaurant":
            UserDefaultManager.webViewSelectedGroupId = groupId
            viewModel?.coordinator?.showSearchRestaurantViewController()
        default:
            return
        }
    }
    
    private func handleBack(isEnable: Bool) {
        if isEnable {
            self.setCustomNavigationBarBackButton(goToViewController: .popVC)
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    private func handleJoinGroup(groupId: Int) {
        Task {
            do {
                try await UpdateGroupAPI.updateSelectedGroupAsync(request: SelectedGroupRequest(groupId: groupId))
                viewModel?.coordinator?.goToHomeViewController()
            } catch {
                print(error)
            }
        }
    }
}
