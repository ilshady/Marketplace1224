//
//  WebViewController.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 02.03.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }()
    
    override func loadView() {
        view = webView
    }
    
    init(with url: String, token: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        
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
