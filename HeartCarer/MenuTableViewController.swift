//
//  MenuTableViewController.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-14.
//  Copyright (c) 2014 UVic. All rights reserved.
//


import UIKit

class MenuTableViewController: UITableViewController {
    
    var selectedMenuItem : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: MenuTableViewCell? = nil
            //tableView.dequeueReusableCellWithIdentifier("Cell") as? MenuTableViewCell
        
        if (cell == nil) {
            
            cell = MenuTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
            
            // disable some cells when no user login
            if (UserInfoManager.hasLoggedIn() == false) {
                if (indexPath.row == 1 || indexPath.row == 3) {
                    cell!.backgroundColor = UIColor.clearColor()
                    cell!.textLabel?.textColor = UIColor.lightGrayColor()
                }
            }
            
            var cellImage: UIImage?
            var cellText: String?
            
            switch (indexPath.row) {
            case 0:
                cellText = "Heart Rate Monitor"
                cellImage = UIImage(named: "hrmonitor_64.png")
                break
                
            case 1:
                cellText = "Data Management"
                cellImage = UIImage(named: "clouddata_64.png")
                break
                
            case 2:
                cellText = "Account Setting"
                cellImage = UIImage(named: "personal_64.png")
                break
                
            case 3:
                cellText = "Notification Setting"
                cellImage = UIImage(named: "notification_64.png")
                break
                
            case 4:
                cellText = "General Setting"
                cellImage = UIImage(named: "setting_64.png")
                break
                
            default:
                cellText = "About"
                cellImage = UIImage(named: "about_64.png")
                break
            }
            
            cell!.textLabel?.font = UIFont(name: "Helvetica", size: 14)
            if (cellText != nil) {
                cell?.textLabel?.text = cellText
            } else {
                cell?.textLabel?.text = "View Controller #\(indexPath.row + 1)"
            }
            
            if (cellImage != nil) {
                cell?.imageView?.image = cellImage
                cell?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            }
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //println("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        selectedMenuItem = indexPath.row
        sideMenuController()?.setContentViewControllerByIndex(selectedMenuItem)
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // disable some cells when no user login
        if (UserInfoManager.hasLoggedIn() == false) {
            if indexPath.row == 1 || indexPath.row == 3 {
                return false
            }
        }
        
        return true
    }
    

}
 

// Re-define the table view cell for the custom side menu
class MenuTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView?.frame = CGRectMake(8, 8, 34, 34)
        self.textLabel?.frame = CGRectMake(0, 0, 200, 50)
        self.textLabel?.frame.origin.x = self.contentView.bounds.origin.x + 50
        self.textLabel?.center.y = 25
        self.textLabel?.font = UIFont(name: "Helvetica", size: 16)
        self.contentMode = UIViewContentMode.ScaleAspectFit
    }

}
