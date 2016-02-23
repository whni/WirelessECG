//
//  GeneralSettingController.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-15.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit

class GeneralSettingController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // Table View
    var cells: NSArray = []
    var tableView: UITableView!
    
    let bluetoothSwitch = UISwitch()
    let bluetoothSwitchCell = RightToggleCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    
    let wifiSwitch = UISwitch()
    let wifiSwitchCell = RightToggleCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    
    let locationButton = UIPlainButton(titleColor: UIColor.blackColor(), backgroundColor: UIColor.grayColor())
    let locationButtonCell = RightToggleCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    
    let compressiveModeSwitch = UISwitch()
    let compressiveModeSwitchCell = RightToggleCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    
    let saveLengthCell = NumberSelectCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, numArray: NSMutableArray(array: saveLengthOption), leftStr: "Save Length", rightStr: "min")
    
    let bpmThresCell = NumberSelectCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, numArray: NSMutableArray(array: bpmThresOption), leftStr: "Low BPM", rightStr: "/ min")
    
    var tableFooterView: UIView!
    let saveInCloudButton: UIPlainButton = UIPlainButton(titleColor: UIColor.whiteColor(), backgroundColor: UIColorPlatte.red600)
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if (cell.isKindOfClass(RightToggleCell)) {
            return (cell as RightToggleCell).rowHeight
        }
        
        if (cell.isKindOfClass(NumberSelectCell)) {
            return (cell as NumberSelectCell).pickerHeight()
        }
        
        return tableView.estimatedRowHeight
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        switch (section) {
        case 0:
            return "Wireless Settings"
        case 1:
            return "ECG Settings"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row] as UITableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(NumberSelectCell)) {
            var datePickerTableViewCell = cell as NumberSelectCell
            datePickerTableViewCell.selectedInTableView(tableView)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.section == 1 && indexPath.row > 0) {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == cells.count - 1 {
            return tableFooterView
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == cells.count - 1 {
            return 100
        } else {
            return 0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configNavigationBar()
        
        setUIContents()
        setUILayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        compressiveModeSwitch.setOn(currentUser!.ifCSmode, animated: false)
        
        var saveLengthMin: Int = Int(currentUser!.length_sample / 60 / 1000)
        var saveLengthIndex = find(saveLengthOption, saveLengthMin)
        if saveLengthIndex == nil {
            saveLengthCell.numberIndex = 0
        } else {
            saveLengthCell.numberIndex = saveLengthIndex!
        }
        
        var lowbpm: Int = Int(currentUser!.bpmthreshold)
        var lowbpmIndex = find(bpmThresOption, lowbpm)
        if lowbpmIndex == nil {
            bpmThresCell.numberIndex = 0
        } else {
            bpmThresCell.numberIndex = lowbpmIndex!
        }
        
        if UserInfoManager.hasLoggedIn() {
            
            saveInCloudButton.setTitle("Save In Cloud", forState: UIControlState.Normal)
            
        } else {
            
            saveInCloudButton.setTitle("Save Temporarily", forState: UIControlState.Normal)
        }
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
        let titleImage = UIImageView(frame: CGRectMake(0, 2, 25, 25))
        titleImage.image = UIImage(named: "setting_64.png")
        
        let titleText = UILabel(frame: CGRectMake(28, 0, 200, 30))
        titleText.text = "General Setting"
        titleText.textAlignment = NSTextAlignment.Left
        titleText.font = UIFont(name: "Helvetica", size: 16)
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
        self.navigationItem.setLeftBarButtonItems([barLeftButtonToggleMenu], animated: true)
        
    }
    
    
    func setUIContents() {
        
        // mode selector and data picker table cells
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        bluetoothSwitch.setOn(false, animated: false)
        bluetoothSwitch.addTarget(self, action: "toggleBluetooth:", forControlEvents: UIControlEvents.ValueChanged)
        bluetoothSwitchCell.rightView = bluetoothSwitch
        bluetoothSwitchCell.leftText.text = "Bluetooth"

        wifiSwitch.setOn(true, animated: false)
        wifiSwitch.addTarget(self, action: "toggleWifi:", forControlEvents: UIControlEvents.ValueChanged)
        wifiSwitchCell.rightView = wifiSwitch
        wifiSwitchCell.leftText.text = "Wi-Fi"
        
        locationButton.setTitle("Setting", forState: UIControlState.Normal)
        locationButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
        locationButton.addTarget(self, action: "locationServiceSetting:", forControlEvents: UIControlEvents.TouchUpInside)
        locationButtonCell.rightView = locationButton
        locationButtonCell.rightViewSize = CGSizeMake(60, 30)
        locationButtonCell.leftText.text = "Location Service"

        compressiveModeSwitch.setOn(true, animated: false)
        compressiveModeSwitch.addTarget(self, action: "toggleCompressiveMode:", forControlEvents: UIControlEvents.ValueChanged)
        compressiveModeSwitchCell.rightView = compressiveModeSwitch
        compressiveModeSwitchCell.leftText.text = "Compressive Sensing Mode"
        
        saveInCloudButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        saveInCloudButton.setTitle("Save in Clound", forState: UIControlState.Normal)
        saveInCloudButton.addTarget(self, action: "saveInCloud:", forControlEvents:UIControlEvents.TouchUpInside)
        
        // footer view for button
        tableFooterView = UIView()
        tableFooterView.backgroundColor = UIColor.clearColor()
        tableFooterView.addSubview(saveInCloudButton)
        saveInCloudButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: saveInCloudButton, toItem: tableFooterView, axisForCenter: "x", itemSize: CGPointMake(self.tableView.frame.width * 0.6, 40)))
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: saveInCloudButton, toItem: tableFooterView, axisForCenter: "y", itemSize: nil))
        
        cells = [
            [bluetoothSwitchCell, wifiSwitchCell, locationButtonCell],
            [compressiveModeSwitchCell, saveLengthCell, bpmThresCell]
        ]
        self.view.addSubview(self.tableView)
        
    }
    
    func setUILayout() {

    }

    
    // Actions for the touch events of the navigation items
    func toggleMenu(sender: UIButton) {
        sideMenuController()?.sideMenu?.toggleMenu()
    }
    
    func saveInCloud(sender: UIButton) {
        println("saveInCloudButton")
        
        if UserInfoManager.hasLoggedIn() {
            
            var request = HTTPTask()
            request.requestSerializer = JSONRequestSerializer()
            request.responseSerializer = nil
            // POST(JSON) getdatalist
            var params: Dictionary<String, AnyObject> = ["userid":currentUser!.userid.toInt()!, "ifcsmode":compressiveModeSwitch.on, "ifturnoffbt":false, "savelength":(saveLengthOption[saveLengthCell.numberIndex] * 1000 * 60), "lowbpm":bpmThresOption[bpmThresCell.numberIndex]]
            request.POST("http://ecg.ece.uvic.ca/rest/upgeneralsetting", parameters: params,
                success: { (response: HTTPResponse) in
                    println("response from: \(response.URL!)")
                    if let data = response.responseObject as? NSData {
                        let result = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                        println("data: \(result)")
                        
                        if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil) {
                            self.asyncAlert(title: "Save Error", alertMsg: "Error: \(result)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                            return
                        }
                        
                        currentUser!.ifCSmode = self.compressiveModeSwitch.on
                        currentUser!.length_sample = Int32(saveLengthOption[self.saveLengthCell.numberIndex] * 1000 * 60)
                        currentUser!.bpmthreshold = Int32(bpmThresOption[self.bpmThresCell.numberIndex])
                        
                        if userManager.saveUserInfo(currentUser!) == true {
                            
                            self.asyncAlert(title: "Update Sussessfully", alertMsg: "User settings have been uploaded to the ECG server.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
                            
                        } else {
                            
                            self.asyncAlert(title: "Database Error", alertMsg: "Can not save user settings locally! Please log in again.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                            // codes to log out ??
                        }
                        
                    }
                },
                failure: {(error: NSError, response: HTTPResponse?) in
                    println("error: \(error)")
                    self.asyncAlert(title: "Save Error!", alertMsg: "Unable to upload settings to the ECG server.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                }
            )

            
        } else {
            // save settings to tmpUser (userid "0")
            currentUser!.ifCSmode = compressiveModeSwitch.on
            currentUser!.length_sample = Int32(saveLengthOption[saveLengthCell.numberIndex] * 1000 * 60)
            currentUser!.bpmthreshold = Int32(bpmThresOption[bpmThresCell.numberIndex])
            
            self.asyncAlert(title: "Save successfully!", alertMsg: "Save settings temporarily!", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
        }
        
    }
    
    func toggleBluetooth(sender: UISwitch) {
        println("Bluetooth: \(sender.on)")
    }
    
    func toggleWifi(sender: UISwitch) {
        println("WiFi: \(sender.on)")
    }

    func locationServiceSetting(sender: UIButton) {
        println("location service")
    }
    
    func toggleCompressiveMode(sender: UISwitch) {
        println("Compressive Sensing Mode: \(sender.on)")
    }
    
    
    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }

}

