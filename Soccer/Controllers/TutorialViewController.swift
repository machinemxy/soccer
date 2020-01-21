//
//  TutorialViewController.swift
//  Soccer
//
//  Created by Ma Xueyuan on 2020/01/21.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit
import WebKit

class TutorialViewController: UIViewController,WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://cecilma2018.blogspot.com/2018/07/tutorial-of-light-football-manager.html")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [progressButton]
        navigationController?.isToolbarHidden = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            if webView.estimatedProgress == 1 {
                navigationController?.isToolbarHidden = true
            } else {
                navigationController?.isToolbarHidden = false
                progressView.progress = Float(webView.estimatedProgress)
            }
        }
    }
}

