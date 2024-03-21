//
//  CreateGroupViewController.swift
//  JMTeng
//
//  Created by PKW on 3/20/24.
//

import UIKit
import WebKit
import SnapKit

class CreateGroupViewController: UIViewController, KeyboardEvent {

    var transformView: UIView { self.view }
    weak var coordinator: CreateGroupCoordinator?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        loadWebPage()
    }
    
    func setupWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "webviewBridge")
        
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.userContentController = contentController
    
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func loadWebPage() {
        let url = WebViewUrl.createGroup.urlString
        let accessToken = DefaultKeychainService.shared.accessToken ?? ""
    
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            webView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
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
}

extension CreateGroupViewController {
    private func handleTokenRequest(str: String) {
        let accessToken = DefaultKeychainService.shared.accessToken ?? ""
        evaluateJavaScriptFunction(functionName: str, parameter: accessToken)
    }
    
    private func evaluateJavaScriptFunction(functionName: String, parameter: String) {
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

extension CreateGroupViewController {
    
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
                    handleTokenRequest(str: onSuccess)
                }
            case "navigation":
                // 네비게이션 관련 처리
                if let data = dictionary["data"] as? [String: Any], let isVisible = data["isVisible"] as? Bool {
                    self.tabBarController?.tabBar.isHidden = !isVisible
                }
            case "requestResponse":
                if let data = dictionary["data"] as? [String: Any], let groupId = data["groupId"] as? Int {
                    coordinator?.goToHomeViewController()
                }
            default:
                // 알 수 없는 name 값 처리
                print("Unknown name value: \(name)")
            }
        }
    }
}

extension CreateGroupViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handleJSONDataBasedOnName(jsonString: message.body as? String ?? "")
    }
}

extension CreateGroupViewController: WKNavigationDelegate {
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

extension CreateGroupViewController: WKUIDelegate {
    
}
