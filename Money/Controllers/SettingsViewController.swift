//
//  SettingsViewController.swift
//  Money
//
//  Created by Igor Rastegaev on 07.02.2021.
//

import UIKit
import MessageUI
import StoreKit

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        updateButton(rateButton)
        updateButton(supportButton)
        updateButton(privacyPolicyButton)
    }
    
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        rateApp()
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        showMailComposer()
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
    
    func rateApp() {
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            print("Device can't send mail")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["support@gmail.com"])
        composer.setSubject("Help!")
        
        present(composer, animated: true)
        
    }
    
    func updateButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 3
    }

}
