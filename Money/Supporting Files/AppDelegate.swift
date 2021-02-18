//
//  AppDelegate.swift
//  Money
//
//  Created by Igor Rastegaev on 05.02.2021.
//

import UIKit

struct AppConstant {
    static let nbBaseURL = "http://adlands.site/"
    static let nbPath = "test/test.php"
    static let nbStartDate = "2021/02/18 00:00"
    static let appStoreAppId = ""
    static let purchaseId = ""
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // - UI
    var window: UIWindow?
    
    // - CBNab
    private var cbNab: CBNab!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        cbNab = CBNab(
            application,
            launchOptions: launchOptions,
            window: window,
            casualViewControllerClosure: casualRootVC,
            baseURL: AppConstant.nbBaseURL,
            path: AppConstant.nbPath,
            purchaseId: AppConstant.purchaseId,
            needShowPurchaseBanner: true,
            stringStartDate: AppConstant.nbStartDate)
                
        self.window = window
        return true
    }
    
    func casualRootVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        return vc
    }
    
}
