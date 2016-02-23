//
//  NotificationSettingController.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-15.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit
import MessageUI.MFMessageComposeViewController

class NotificationSettingController: UITableViewController, UITextFieldDelegate {
    
    // Table View
    var cells: NSArray = []
    
    let msgCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "Message")
    let phoneCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "Phone")
    
    var autoMsgSwitch = UISwitch()
    let autoMsgCell = RightToggleCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    var appendLocationSwitch = UISwitch()
    let appendLocationCell = RightToggleCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    
    var tableFooterView: UIView!
    let testMsgButton: UIPlainButton = UIPlainButton(titleColor: UIColor.whiteColor(), backgroundColor: UIColorPlatte.red600)
    let saveMsgButton: UIPlainButton = UIPlainButton(titleColor: UIColor.whiteColor(), backgroundColor: UIColorPlatte.red600)
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if (cell.isKindOfClass(RightToggleCell)) {
            return (cell as RightToggleCell).rowHeight
        }
        
        return tableView.estimatedRowHeight
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        switch (section) {
        case 0:
            return "Emergency Contact"
        case 1:
            return "Message Options"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row] as UITableViewCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false;
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == cells.count - 1 {
            return tableFooterView
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == cells.count - 1 {
            return 200
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
        
        msgCell.inputText.text = currentUser!.msg_emer
        phoneCell.inputText.text = currentUser!.phone_emer
        
        autoMsgSwitch.setOn(currentUser!.ifsendmsg, animated: false)
        appendLocationSwitch.setOn(currentUser!.ifappendloc, animated: false)
    }
    
    /*override func viewDidAppear(animated: Bool) {
        //msgCell.inputText.text = currentUser!.msg_emer
        //phoneCell.inputText.text = currentUser!.phone_emer
        
        //autoMsgSwitch.setOn(currentUser!.ifsendmsg, animated: false)
        //appendLocationSwitch.setOn(currentUser!.ifappendloc, animated: false)
    }*/
    
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
        titleImage.image = UIImage(named: "notification_64.png")
        
        let titleText = UILabel(frame: CGRectMake(28, 0, 200, 30))
        titleText.text = "Notification Setting"
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
        
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        msgCell.inputText.keyboardType = UIKeyboardType.Default
        msgCell.inputText.returnKeyType = UIReturnKeyType.Next
        msgCell.inputText.placeholder = "Required"
        msgCell.inputText.delegate = self
        phoneCell.inputText.keyboardType = UIKeyboardType.NumbersAndPunctuation
        phoneCell.inputText.returnKeyType = UIReturnKeyType.Done
        phoneCell.inputText.placeholder = "17781234567"
        phoneCell.inputText.delegate = self
        
        autoMsgSwitch.setOn(false, animated: false)
        autoMsgSwitch.addTarget(self, action: "toggleAutoMsg:", forControlEvents: UIControlEvents.ValueChanged)
        autoMsgCell.rightView = autoMsgSwitch
        autoMsgCell.leftText.text = "Send message automatically\nwhen in emergency"
        autoMsgCell.rowHeight = 50
        appendLocationSwitch.setOn(false, animated: false)
        appendLocationSwitch.addTarget(self, action: "toggleAppendLocation:", forControlEvents: UIControlEvents.ValueChanged)
        appendLocationCell.rightView = appendLocationSwitch
        appendLocationCell.leftText.text = "Attach current location to the\nemergency message"
        appendLocationCell.rowHeight = 50
        
        
        testMsgButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        testMsgButton.setTitle("Test", forState: UIControlState.Normal)
        testMsgButton.addTarget(self, action: "testMsg:", forControlEvents: UIControlEvents.TouchUpInside)
        saveMsgButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        saveMsgButton.setTitle("Save", forState: UIControlState.Normal)
        saveMsgButton.addTarget(self, action: "saveMsg:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // footer view for buttons
        tableFooterView = UIView()
        tableFooterView.backgroundColor = UIColor.clearColor()
        
        tableFooterView.addSubview(self.testMsgButton)
        tableFooterView.addSubview(self.saveMsgButton)
        testMsgButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        saveMsgButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: testMsgButton, toItem: tableFooterView, axisForCenter: "y", itemSize: CGPointMake(tableView.frame.width / 3, 35)))
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: testMsgButton, toItem: tableFooterView, attribute: NSLayoutAttribute.Leading, marginSize: 30))
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: saveMsgButton, toItem: tableFooterView, axisForCenter: "y", itemSize: CGPointMake(tableView.frame.width / 3, 35)))
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: saveMsgButton, toItem: tableFooterView, attribute: NSLayoutAttribute.Trailing, marginSize: 30))

        cells = [
            [msgCell, phoneCell],
            [autoMsgCell, appendLocationCell]
        ]
        //self.view.addSubview(self.tableView)
        
    }
    
    func setUILayout() {
    }

    
    // Actions for the touch events of the navigation items
    func toggleMenu(sender: UIButton) {
        sideMenuController()?.sideMenu?.toggleMenu()
    }
    
    func toggleAutoMsg(sender: UISwitch) {
        println("Auto Msg: \(sender.on)")
    }
    
    func toggleAppendLocation(sender: UISwitch) {
        println("Append Location: \(sender.on)")
    }
    
    func testMsg(sender: UIButton) {
        println("test message")

        if MFMessageComposeViewController.canSendText() {
            
            let messageVC = EmergencyMsgViewController()
            
            messageVC.body = "The Heart Rate of \(currentUser!.name_first) \(currentUser!.name_last) is less than \(currentUser!.bpmthreshold) bpm. Please contact the doctor.";
            messageVC.recipients = ["\(currentUser!.phone)"]
            
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        
    }
    
    internal func saveMsg(sender: UIButton) {
        println("save message")
        
        // end editing
        self.view.endEditing(true)
        
        // upload user information to server
        var request = HTTPTask()
        request.requestSerializer = JSONRequestSerializer()
        request.responseSerializer = nil
        
        // POST(JSON) upuserinfo
        var params: Dictionary<String, AnyObject> = ["userid":currentUser!.userid.toInt()!, "emergencynum":phoneCell.inputText.text, "emergencymes":msgCell.inputText.text, "ifSendSms":autoMsgSwitch.on, "ifAppendLoc":appendLocationSwitch.on]
        
        request.POST("http://ecg.ece.uvic.ca/rest/upsms", parameters: params,
            success: {(response: HTTPResponse) in
                println("response from: \(response.URL!)")
                if let data = response.responseObject as? NSData {
                    let result = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                    println("data: \(result)")
                
                    if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil) {
                        self.asyncAlert(title: "Save Error", alertMsg: "Error: \(result)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                        return
                    }
                    
                    currentUser!.msg_emer = self.msgCell.inputText.text
                    currentUser!.phone_emer = self.phoneCell.inputText.text
                    currentUser!.ifsendmsg = self.autoMsgSwitch.on
                    currentUser!.ifappendloc = self.appendLocationSwitch.on
                    
                    if userManager.saveUserInfo(currentUser!) == true {
                        self.asyncAlert(title: "Update Sussessfully", alertMsg: "Emergency setting has been uploaded to the ECG server.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
                    } else {
                        self.asyncAlert(title: "Database Error", alertMsg: "Can not save emergency setting locally! Please log in again.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                        // codes to log out ??
                    }
                    
                }
            },
            failure: {(error: NSError, response: HTTPResponse?) in
                //println("error: \(error)")
                self.asyncAlert(title: "Save Error", alertMsg: "Failed to upload emergency setting!", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
        })
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        // Execute additional code
        var section: Int = 0
        var row: Int = 0
        for row = 0; row < (cells[section] as [InputTextCell]).count; row++ {
            if textField.superview?.superview == cells[section][row] as InputTextCell {
                if row == (cells[section] as [InputTextCell]).count - 1 {
                    textField.resignFirstResponder()
                } else {
                    (cells[section][row + 1] as InputTextCell).inputText.becomeFirstResponder()
                }
                break
            }
        }
        
        if section == cells.count {
            println("unknown input text field")
            return false
        }
        
        return true
        
    }
    
    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}


// for sending emergency msg
class EmergencyMsgViewController: MFMessageComposeViewController, MFMessageComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageComposeDelegate = self
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        switch(result.value) {
        case MessageComposeResultCancelled.value:
            self.dismissViewControllerAnimated(true, completion: nil)
            break
        case MessageComposeResultFailed.value:
            self.asyncAlert(title: "Message Error", alertMsg: "Failed to send your message.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Cancel)
            break
        case MessageComposeResultSent.value:
            self.asyncAlert(title: "Send Message", alertMsg: "Your message has been sent successfully.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Cancel)
            self.dismissViewControllerAnimated(true, completion: nil)
            break
        default:
            println("msg send: unknown result")
        }
    }
    
    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}