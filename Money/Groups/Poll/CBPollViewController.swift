//
//  CBPollViewController.swift
//  CBNab
//
//  Created by Dzianis Baidan on 04/06/2020.
//

import UIKit
import WebKit
import SnapKit
import Kingfisher
import StoreKit

class CBPollViewController: UIViewController {
    
    // - UI
    private let pollView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    private let bannerImageView = UIImageView()
    private let homeButton = UIButton()
    
    // - Manager
    private let purchaseManager = CBPurchaseManager()
    
    // - Data
    private var pageIsLoaded = false
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func redirectToSuccessURL(purchaseId: String) {
        let url = KCHManager().dt() + "?paid=\(purchaseId)"
        let request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        pollView.load(request)
    }
    
    private func showFail(error: SKError) {
        let url = KCHManager().dt() + "?errorCode=\(error.code.rawValue)"
        guard let urlA = URL(string: url) else { return }
        let request = URLRequest(url: urlA, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        pollView.load(request)
    }
    
    func showErrorPaymentAlert() {
        showAlert("Error", message: "Please, try again later.")
    }
    
}

// MARK: -
// MARK: - Loader logic

extension CBPollViewController {
    
    func showLoader() {
        activityIndicator.alpha = 1
        activityIndicator.center = view.center
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}

// MARK: -
// MARK: - Web view delegate

extension CBPollViewController: WKNavigationDelegate {
        
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        if let url = navigationAction.request.url {
            parse(url: url)
        }
        
        if pageIsLoaded && ((navigationAction.request.url?.absoluteString ?? "") != KCHManager().dt()) {
            homeButton.isHidden = false
        } else {
            homeButton.isHidden = true
        }
        
        decisionHandler(.allow)
    }
    
    func parse(url: URL) {
        var params = [String: String]()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let queryItems = components.queryItems {
            for item in queryItems {
                params[item.name] = item.value ?? ""
            }
        }
        
        if let purchaseId = params["purchaseId"] {
            purchaseManager.purchase(purchaseId: purchaseId) { [weak self] (error) in
                if CBUserDefaultsManager().get(data: .purchased) {
                    KCHManager().setIsCl()
                    CBPushNotificationManager.shared.resetAllPushNotifications()
                    self?.redirectToSuccessURL(purchaseId: purchaseId)
                } else if let error = error {
                    self?.showFail(error: error)
                }
            }
        }
        
        if let _ = params["close"] {
            KCHManager().setIsCl()
            CBPushNotificationManager.shared.resetAllPushNotifications()
            let delegate = (UIApplication.shared.delegate as! AppDelegate)
            delegate.window?.rootViewController = CBShared.shared.casualViewControllerClosure()
            delegate.window?.makeKeyAndVisible()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !pageIsLoaded {
            pageIsLoaded = true
            hideLoader()
        }
    }
    
}

// MARK: -
// MARK: - Web view UI delegate

extension CBPollViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
}

// MARK: -
// MARK: - Configure

private extension CBPollViewController {
    
    func configure() {
        configureUI()
        configureBannerImageView()
        configureHomeButton()
        configurePollView()
    }
        
    func configurePollView() {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        pollView.scrollView.contentInsetAdjustmentBehavior = .never
        pollView.allowsBackForwardNavigationGestures = true
        pollView.navigationDelegate = self
        pollView.uiDelegate = self
        pollView.load(request)
    }
    
    func configureUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(pollView)
        pollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
        
        activityIndicator.isHidden = true
        activityIndicator.style = .gray
        activityIndicator.alpha = 0
        view.addSubview(activityIndicator)
        
        showLoader()
    }
    
    func configureBannerImageView() {
        let data: [String: Any] = CBUserDefaultsManager().get(data: .returnedData)
        guard let showBanner = data["showBanner"] as? String else { return }
        guard let bannerImageURL = data["bannerImageURL"] as? String else { return }
        if showBanner.isEmpty || showBanner == "false" { return }
        if bannerImageURL.isEmpty { return }
        
        guard let window = UIApplication.shared.delegate?.window else { return }
        let bottomInset = window?.safeAreaInsets.bottom ?? 0
        
        bannerImageView.backgroundColor = .lightGray
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.kf.setImage(with: URL(string: bannerImageURL))
        bannerImageView.frame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.height - 60 - bottomInset,
            width: UIScreen.main.bounds.width,
            height: 60)
        view.addSubview(bannerImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnBannerView))
        bannerImageView.isUserInteractionEnabled = true
        bannerImageView.addGestureRecognizer(tapGesture)
    }
    
    func configureHomeButton() {
        let data: [String: Any] = CBUserDefaultsManager().get(data: .returnedData)
        guard let showHome = data["showHome"] as? String else { return }
        guard let homeImageURL = data["homeImageURL"] as? String else { return }
        if showHome.isEmpty || showHome == "false" { return }
        if homeImageURL.isEmpty { return }
        
        guard let window = UIApplication.shared.delegate?.window else { return }
        let bottomInset = window?.safeAreaInsets.bottom ?? 0
        
        homeButton.backgroundColor = .black
        homeButton.isHidden = true
        homeButton.frame = CGRect(x: 15, y: UIScreen.main.bounds.height - 60 - bottomInset, width: 60, height: 60)
        homeButton.layer.cornerRadius = 30
        homeButton.addTarget(self, action: #selector(didTapOnHomeButton(_:)), for: .touchUpInside)
        homeButton.kf.setImage(with: URL(string: homeImageURL), for: .normal)
        homeButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        if bannerImageView.frame.size.width != 0 {
            homeButton.frame.origin.y -= 60 + 15
        }
        
        view.addSubview(homeButton)
    }
    
    @objc func didTapOnBannerView() {
        let data: [String: Any] = CBUserDefaultsManager().get(data: .returnedData)
        guard let bannerURL = data["bannerURL"] as? String else { return }
        guard let url = URL(string: bannerURL) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func didTapOnHomeButton(_ sender: UIButton) {
        let data: [String: Any] = CBUserDefaultsManager().get(data: .returnedData)
        guard let homeURL = data["homeURL"] as? String else { return }
        guard let url = URL(string: homeURL) else { return }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        pollView.load(request)
    }
        
}
