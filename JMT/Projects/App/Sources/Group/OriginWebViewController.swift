//
//  OriginWebViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/21/24.
//

import UIKit
import WebKit


class OriginWebViewController: UIViewController, WKUIDelegate {
    var viewModel: GroupViewModel?
    var accessToken: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
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
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        }
    }
}

