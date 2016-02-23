//
//  AboutInfoController.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-15.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit

class AboutInfoController: UIViewController {
    
    let ECGLogoView: UIImageView = UIImageView()
    let appNameLabel: UILabel = UILabel()
    let authorNameLabel: UILabel = UILabel()
    let updateAppButton: UIPlainButton = UIPlainButton(titleColor: UIColor.whiteColor(), backgroundColor: UIColorPlatte.red600)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
        
        configNavigationBar()
        
        setUIContents()
        setUILayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    // configurations for the navigation bar
    func configNavigationBar() {
        
        // Re-define the navigation title
        let titleImage = UIImageView(frame: CGRectMake(0, 3, 25, 25))
        titleImage.image = UIImage(named: "about_64.png")
        
        let titleText = UILabel(frame: CGRectMake(28, 0, 200, 30))
        titleText.text = "About"
        titleText.textAlignment = NSTextAlignment.Left
        titleText.font = UIFont(name: "Helvetica Neue", size: 16)
        titleText.adjustsFontSizeToFitWidth = true
        //titleText.textColor = UIColor.blueColor()
        
        let navTitle = UIView(frame: CGRectMake(0, 0, 200, 30))
        navTitle.addSubview(titleImage)
        navTitle.addSubview(titleText)
        self.navigationItem.titleView = navTitle
        
        // Re-define the left bar items for toggling the side menu
        let buttonToggleMenu: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonToggleMenu.frame = CGRectMake(0, 0, 25, 25)
        buttonToggleMenu.setImage(UIImage(named:"ic_drawer.png"), forState: UIControlState.Normal)
        buttonToggleMenu.addTarget(self, action: "toggleMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        var barLeftButtonToggleMenu: UIBarButtonItem = UIBarButtonItem(customView: buttonToggleMenu)
        self.navigationItem.setLeftBarButtonItem(barLeftButtonToggleMenu, animated: true)
        
        // Re-define the right bar items
        let buttonUpdateApp: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonUpdateApp.frame = CGRectMake(0, 0, 28, 28)
        buttonUpdateApp.setImage(UIImage(named:"ic_action_download.png"), forState: UIControlState.Normal)
        buttonUpdateApp.addTarget(self, action: "updateApp:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightButtonUpdateApp: UIBarButtonItem = UIBarButtonItem(customView: buttonUpdateApp)
        
        let buttonFeedback: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonFeedback.frame = CGRectMake(0, 0, 28, 28)
        buttonFeedback.setImage(UIImage(named:"ic_action_chat.png"), forState: UIControlState.Normal)
        buttonFeedback.addTarget(self, action: "feedbackChat:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightButtonFeedback: UIBarButtonItem = UIBarButtonItem(customView: buttonFeedback)

        self.navigationItem.setRightBarButtonItems([barRightButtonFeedback, barRightButtonUpdateApp], animated: true)
        
    }
    
    
    // UI contents configuration
    func setUIContents() {
      
        // Draw the ECG logo and show the App name
        let ECGLogoSize: CGFloat = 100.0
        ECGLogoView.image = UIImage(named: "main_heart_beat_128.png")
        self.view.addSubview(ECGLogoView)
        
        appNameLabel.textAlignment = NSTextAlignment.Center
        appNameLabel.font = UIFont(name: "Helvetica Neue", size: 20)
        appNameLabel.text = "Heart Carer V0.1"
        self.view.addSubview(appNameLabel)
        
        authorNameLabel.textAlignment = NSTextAlignment.Center
        authorNameLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        authorNameLabel.numberOfLines = 0               // allow multiple lines
        authorNameLabel.text = "Created by Weiheng Ni \n\n Copyright \u{00A9}2014 Xiaodai Dong \n\n All Rights Reserved"
        self.view.addSubview(authorNameLabel)
        

        // Add a plain buton for checking update
        updateAppButton.setTitle("Check for update", forState: UIControlState.Normal)
        updateAppButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        updateAppButton.addTarget(self, action: "checkForUpdate:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(updateAppButton)
        

    }
    
    func setUILayout() {
        // Set auto-layout for the About page
        // The dictionary for auto-layout using NSLayoutConstraint
        var viewDict: Dictionary<String, AnyObject> = [:]
        viewDict["ECGLogoView"] = ECGLogoView
        viewDict["appNameLabel"] = appNameLabel
        viewDict["authorNameLabel"] = authorNameLabel
        viewDict["updateAppButton"] = updateAppButton
        SimpleUILayout.enableConstraintForViewItems(itemArray: Array(viewDict.values))
        
        // Position for drawing items
        let tbMargin: CGFloat = (self.view.frame.height - self.navigationController!.navigationBar.frame.height) * 0.16
        let viewDrawOriginY = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
        
        self.view.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: ECGLogoView, toItem: self.view, axisForCenter: "x", itemSize: CGPointMake(80, 80)))
        self.view.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: appNameLabel, toItem: self.view, axisForCenter: "x", itemSize: nil))
        self.view.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: authorNameLabel, toItem: self.view, axisForCenter: "x", itemSize: nil))
        self.view.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: updateAppButton, toItem: self.view, axisForCenter: "x", itemSize: CGPointMake(200.0, 0.0)))
        self.view.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: updateAppButton, toItem: self.view, axisForCenter: "x", itemSize: CGPointMake(200.0, 40.0)))
        
        self.view.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: ECGLogoView, toItem: self.view, attribute: NSLayoutAttribute.Top, marginSize: viewDrawOriginY + tbMargin))
        self.view.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: updateAppButton, toItem: self.view, attribute: NSLayoutAttribute.Bottom, marginSize: tbMargin))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[ECGLogoView]-(<=20)-[appNameLabel]-(>=30)-[authorNameLabel]-(>=30)-[updateAppButton]", options: nil, metrics: nil, views: viewDict))
        
    }
    
    // actions for the touch events of the navigation items
    func toggleMenu(sender: UIButton) {
        sideMenuController()?.sideMenu?.toggleMenu()
    }
    
    func updateApp(sender: UIButton) {
        println("updateApp")
    }
    
    func feedbackChat(sender: UIButton) {
        println("feedbackChat")
    }
    
    func checkForUpdate(sender: UIButton) {
        //updateAppButton.backgroundColor = UIColorPlatte.red600light
        println("check for update")
    }


}

