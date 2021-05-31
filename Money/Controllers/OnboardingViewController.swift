//
//  WelcomeViewController.swift
//  Greatest Volcanoes
//
//  Created by Igor Rastegaev on 25.01.2021.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet var holderView: UIView!
    
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }

    private func configure() {
        // set up scrollview
        
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        
        let titles = ["Control your finances", "Choose, calculate and add category", "History of transactions"]
        
        for x in 0..<3 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            // Title, image, button
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width - 20, height: 120))
            label.numberOfLines = 0
            
            setTitle(label: label, titles: titles, index: x)
            pageView.addSubview(label)
            
            let imageView = UIImageView(frame: CGRect(x: 10, y: 120, width: pageView.frame.size.width - 20, height: pageView.frame.size.height - 60 - 130 - 15))
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height-60, width: pageView.frame.size.width - 20, height: 50))
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "onboarding-\(x+1)")
            pageView.addSubview(imageView)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.setTitle("Next", for: .normal)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x + 1
            pageView.addSubview(button)
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * 3, height: 0)
        scrollView.isPagingEnabled = true
        
    }
    
    func setTitle(label: UILabel, titles: [String], index: Int) {
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-Bold", size: 32)
        label.text = titles[index]
    }
    
    @objc func didTapButton(_ button : UIButton) {
        guard button.tag < 3 else {
            // dismiss
            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        // scroll to next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
    
}
