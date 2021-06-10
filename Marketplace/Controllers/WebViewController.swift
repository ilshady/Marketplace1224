//
//  WebViewController.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 02.03.2021.
//

import UIKit
import WebKit
import ProgressHUD

class WebViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }()
    
    override func loadView() {
        view = webView
        ProgressHUD.show()

    }
    
    init(with url: String, token: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show()
        
        webView.navigationDelegate = self
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            if let token = token {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            webView.load(URLRequest(url: url))
        } else {
            webView.load(URLRequest(url: URL(string: url)!))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.showError()
    }
    
}
