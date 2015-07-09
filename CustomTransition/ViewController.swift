//
//  ViewController.swift
//  CustomTransition
//
//  Created by Colin Dunn on 3/14/15.
//  Copyright (c) 2015 Colin Dunn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let transitionManger = TransitionManger()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blueColor()
        
        button.setTitle("Present", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "present", forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         button.frame = view.frame
    }
    
    func present() {
        let viewController = ViewController()
        viewController.modalPresentationStyle = .Custom
        viewController.transitioningDelegate = transitionManger
        
        if view.backgroundColor == UIColor.blueColor() {
            viewController.view.backgroundColor = UIColor.whiteColor()
            viewController.button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        }
        
        transitionManger.presentingController = viewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}