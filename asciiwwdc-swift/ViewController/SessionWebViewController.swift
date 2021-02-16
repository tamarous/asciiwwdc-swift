//
//  SessionWebViewController.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/14.
//

import Foundation
import UIKit
import WebKit

class SessionWebViewController: UIViewController {
    var session:Session?
    var favorited:UIBarButtonItem!
    var settings:UIBarButtonItem!
    
    lazy var webView:WKWebView = {
        let webView = WKWebView(frame: self.view.bounds, configuration: WKWebViewConfiguration())
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.backgroundColor = .white
        
        webView.navigationDelegate = self
        webView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        
        settings = UIBarButtonItem.init(image: UIImage.init(systemName: "gear"), style: .plain, target: self, action: #selector(settingsTapped))
        var imageName = "star"
        if let session = self.session {
            imageName = session.favorited ? "star.fill" : "star"
        }
        favorited = UIBarButtonItem.init(image: UIImage.init(systemName: imageName), style: .plain, target: self, action: #selector(favoritedTapped))
        navigationItem.rightBarButtonItems = [favorited, settings]
        
        if let session = self.session {
            navigationItem.title = session.name
            
            if let urlStr = session.hrefLink {
                let url = URL.init(string: urlStr)
                let urlRequest = URLRequest.init(url:url!)
                webView.isHidden = true
                webView.load(urlRequest)
            }
        }
    }
    
    @objc func settingsTapped() {
        
    }
    
    @objc func favoritedTapped() {
        if let session = self.session {
            self.session?.favorited = !session.favorited
        }
        var imageName = "star"
        if let session = self.session {
            imageName = session.favorited ? "star.fill" : "star"
        }
        favorited.image = UIImage.init(systemName: imageName)
    }
}

extension SessionWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let removeHeader = "var collections=document.getElementsByTagName(\"header\");for(var i=0;i<collections.length;i++){var element=collections[i];element.style.display='none';}"
        let removeFooter = "var collections=document.getElementsByTagName(\"footer\");for(var i=0;i<collections.length;i++){var element=collections[i];element.style.display='none';}"
        let script = removeHeader + removeFooter
        self.webView.evaluateJavaScript(script) { [weak self] (result, error) in
            self?.webView.isHidden = false
        }
    }
}
