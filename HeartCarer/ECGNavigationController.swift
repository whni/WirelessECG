//
//  ECGNavigationController.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-14.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit

class ECGNavigationController: UINavigationController, ENSideMenuProtocol, ENSideMenuDelegate {
    
    internal var sideMenu : ENSideMenu?
    internal var sideMenuAnimationType : ENSideMenuAnimation = .Default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // user login status recovery
        
        // generate a temporary user
        tmpUser = UserInfo()   // userid: "0"
        currentUser = tmpUser
        
        // recover user information when one user is stored in local database
        if let user = userManager.getUserInfo("any") {
            currentUser!.username = user.username
            currentUser!.password = user.password
            currentUser!.userid = user.userid
            
            currentUser!.name_first = user.name_first
            currentUser!.name_last = user.name_last
            currentUser!.email = user.email
            currentUser!.phone = user.phone
            
            currentUser!.msg_emer = user.msg_emer
            currentUser!.phone_emer = user.phone_emer
            currentUser!.ifsendmsg = user.ifsendmsg
            currentUser!.ifappendloc = user.ifappendloc
            
            currentUser!.ifCSmode = user.ifCSmode
            currentUser!.length_sample = user.length_sample
            currentUser!.bpmthreshold = user.bpmthreshold
        }
        
        // side menu configuration
        sideMenu = ENSideMenu(sourceView: self.view, menuTableViewController: MenuTableViewController(), menuPosition:.Left)
        sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 220.0 // optional, default is 160
        sideMenu?.bouncingEnabled = false
        
        // default view controller
        self.setViewControllers([viewControllerSet[0]], animated: false)
        
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        if self.viewControllers.last != nil {
            return self.viewControllers.last!.shouldAutorotate()
        } else {
            return true
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if self.viewControllers.last != nil {
            return self.viewControllers.last!.supportedInterfaceOrientations()
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        //println("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        //println("sideMenuWillClose")
    }
    
    // MARK: - Navigation
    func setContentViewController(contentViewController: UIViewController) {
        self.sideMenu?.toggleMenu()
        switch sideMenuAnimationType {
        case .None:
            self.setViewControllers([contentViewController], animated: false)
            break
        default:
            self.setViewControllers([contentViewController], animated: true)
            break
        }
    }
    
    func setContentViewControllerByIndex(contentViewControllerIndex: Int) {
        // recover orientation to portrait first
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        setContentViewController(viewControllerSet[contentViewControllerIndex])
    }

    
}
