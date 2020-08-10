//
//  BKWebViewController.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/4/30.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

public class BKWebViewController: UIViewController{
    
    /// 进度条
    private lazy var progressView: UIProgressView = {
        let prgv=UIProgressView()
        prgv.progressViewStyle = .bar;
        return prgv
    }()
    
    /// 等待加载菊花
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let act=UIActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 88, height: 88)))
        act.center=CGPoint(x: self.view.center.x, y: self.view.center.y-22)
        act.style = .gray;
        act.hidesWhenStopped=true
        return act
    }()
    
    /// 网页链接
    open var url:URL?
    
    /// 网页HTML
    open var html:String?
    
    /// request对象
    open var request:URLRequest?
    
    private(set) var currentURL: String?
    
    open lazy var wkWebView: WKWebView = {
        let config = WKWebViewConfiguration();
        config.preferences=WKPreferences();
        config.preferences.javaScriptEnabled=true;
        config.preferences.javaScriptCanOpenWindowsAutomatically=false;
        config.selectionGranularity = WKSelectionGranularity.character;
        config.allowsInlineMediaPlayback = true;
        config.userContentController=WKUserContentController()
        let js = " $('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,user-scalable=true\">' );"
        let script=WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        let web = WKWebView(frame: self.view.bounds, configuration: config)
        web.navigationDelegate = self;
        web.uiDelegate = self;
        web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        web.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        return web
    }()
    
    convenience init(_ url: URL?) {
        self.init()
        self.url=url
    }
    convenience init(_ html: String?) {
        self.init()
        self.html=html
    }
    convenience init(_ request: URLRequest?) {
        self.init()
        self.request=request
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.init(white: 243/255.0, alpha: 1);
        self.extendedLayoutIncludesOpaqueBars=true;
        self.automaticallyAdjustsScrollViewInsets=false;
        self.edgesForExtendedLayout = .init(rawValue: 0);
        self.view.addSubview(self.wkWebView);
        if (self.request != nil) {
            self.wkWebView.load(self.request!)
        }else if self.url != nil {
            if self.url!.isFileURL {
                let accessURL = self.url!.deletingLastPathComponent()
                self.wkWebView.loadFileURL(self.url!, allowingReadAccessTo: accessURL)
            }else{
                self.request = URLRequest(url: self.url!)
                self.wkWebView.load(self.request!)
            }
        }else if self.html != nil {
            self.wkWebView.loadHTMLString(self.html!, baseURL: nil)
        }
        
        self.wkWebView.addSubview(self.activityIndicator)
        self.navigationController?.navigationBar.addSubview(self.progressView)
        self.wkWebView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(0)
        }
        self.activityIndicator.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(88)
        }
        self.progressView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(2)
        }
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "title") {
            let title = change?[.newKey]
            self.title = title as? String;
        }else if (keyPath == "estimatedProgress"){
            let num = change?[.newKey] as! NSNumber
            let progress = Float(truncating: num);
            progressView.setProgress(progress, animated: true)
        }
    }
}

extension BKWebViewController: WKNavigationDelegate{
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载网页...");
        activityIndicator.startAnimating()
        progressView.isHidden = false;
        progressView.progress = 0.0;

    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("完成网页加载。");
        activityIndicator.stopAnimating()
        progressView.isHidden = true;
        progressView.progress = 1.0;

    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("网页加载失败：\(error.localizedDescription)");
        activityIndicator.stopAnimating()
        progressView.isHidden = true;
        progressView.progress = 0.0;
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("网页加载失败：\(error.localizedDescription)");
        activityIndicator.stopAnimating()
        progressView.isHidden = true;
        progressView.progress = 0.0;
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("HTTPHeader:\(String(describing: navigationAction.request.allHTTPHeaderFields))");
        print("\n****href:\(String(describing: navigationAction.request.url?.absoluteString))");
        if let cur_url = navigationAction.request.url {
            if cur_url.absoluteString == "about:blank" {
                decisionHandler(.cancel);
            }else if cur_url.scheme != "http" && cur_url.scheme != "https" && cur_url.isFileURL == false {
                if UIApplication.shared.canOpenURL(cur_url) {
                    let msg = "將要離開\(String(describing: Bundle.main.infoDictionary?["CFBundleDisplayName"]))"
                    self.showAlert(nil,msg:msg, buttons: "取消","允許") { (index) in
                        print("\(index)")
                        if index == 1 {
                            UIApplication.shared.open(cur_url, options: [:], completionHandler: nil)
                            
                        }
                    }
                    decisionHandler(.cancel);
                }else{
                    decisionHandler(.allow);
                }
            }else if cur_url.host == "apps.apple.com" || cur_url.host == "itunes.apple.com"{
                let msg="將要離開\(String(describing: Bundle.main.infoDictionary?["CFBundleDisplayName"]))\n打開\"App Store\""
                self.showAlert(nil,msg:msg, buttons: "取消","允許") { (index) in
                    print("\(index)")
                    if index == 1 {
                        UIApplication.shared.open(cur_url, options: [:], completionHandler: nil)
                        
                    }
                }
                decisionHandler(.cancel);
            }else{
                decisionHandler(.allow);
            }
        }else{
            decisionHandler(.allow);
        }
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // 判断服务器采用的验证方法
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            // 如果没有错误的情况下 创建一个凭证，并使用证书
            if (challenge.previousFailureCount == 0) && challenge.protectionSpace.serverTrust != nil {
                
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential);
            }else {
                // 验证失败，取消本次验证
                completionHandler(.cancelAuthenticationChallenge, nil);
            }
        }else {
            completionHandler(.cancelAuthenticationChallenge, nil);
        }
    }
}
extension BKWebViewController: WKUIDelegate{
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //内页跳转
        let frameInfo:WKFrameInfo? = navigationAction.targetFrame;
        if (!(frameInfo?.isMainFrame ?? false)) {
            webView.load(navigationAction.request)
        }
        return nil;

    }
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
       let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            completionHandler(false);
        }))
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(true);
        }))
        self.present(alertController, animated: true, completion:nil )
    }
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: prompt, message: "", preferredStyle: .alert);
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "完成", style: .default, handler: { (action) in
            completionHandler(alertController.textFields?.first?.text);
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert);
         alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
             completionHandler();
         }))
         self.present(alertController, animated: true, completion:nil )
    }
}
