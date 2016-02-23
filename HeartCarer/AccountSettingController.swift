//
//  AccountSettingController.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-15.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit

class AccountSettingController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // Table View
    var cells: NSArray = []
    var tableView: UITableView!

    var userInfoVC = UserInfoViewController()
    var doctorListVC = DoctorListViewController()
    var userLoginVC: UserLoginViewController!
    
    let accountCell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    let doctorListCell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    let logoutCell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return tableView.estimatedRowHeight
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        switch (section) {
        case 0:
            return "ACCOUNT INFO"
        case 1:
            return "LOGOUT"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if UserInfoManager.hasLoggedIn() == false {
                return cells[section].count - 1
            }
        }
        
        return cells[section].count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row] as UITableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch(indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0:
                accountCellTarget()
                break
            case 1:
                showDoctorList()
                break
            default:
                break
            }
            break
        case 1:
            logoutCellTarget()
            break
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // log in VC setting
        userLoginVC = UserLoginViewController()
        userLoginVC.parentVC = self
        
        configNavigationBar()
        
        setUIContents()
        setUILayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.updateCellStatus(UserInfoManager.hasLoggedIn())
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
        let titleImage = UIImageView(frame: CGRectMake(0, 0, 25, 25))
        titleImage.image = UIImage(named: "personal_64.png")
        
        let titleText = UILabel(frame: CGRectMake(26, 0, 200, 30))
        titleText.text = "Account Setting"
        titleText.textAlignment = NSTextAlignment.Left
        titleText.font = UIFont(name: "Helvetica", size: 16)
        titleText.adjustsFontSizeToFitWidth = true
        //titleText.textColor = UIColor.blueColor()
        
        let navTitle = UIView(frame: CGRectMake(0, 0, 200, 30))
        navTitle.addSubview(titleImage)
        navTitle.addSubview(titleText)
        self.navigationItem.titleView = navTitle
        
        // Re-define left bar items for toggleing the side menu
        let buttonToggleMenu: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonToggleMenu.frame = CGRectMake(0, 0, 25, 25)
        buttonToggleMenu.setImage(UIImage(named:"ic_drawer.png"), forState: UIControlState.Normal)
        buttonToggleMenu.addTarget(self, action: "toggleMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        var barLeftButtonToggleMenu: UIBarButtonItem = UIBarButtonItem(customView: buttonToggleMenu)
        self.navigationItem.setLeftBarButtonItem(barLeftButtonToggleMenu, animated: true)
        
        // Re-define the right bar items
        let loginButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        loginButton.frame = CGRectMake(0, 0, 30, 28)
        loginButton.setImage(UIImage(named:"sign_in.png"), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "userLoginButton:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightLoginButton: UIBarButtonItem = UIBarButtonItem(customView: loginButton)
        
        self.navigationItem.setRightBarButtonItems([barRightLoginButton], animated: true)
    }
    
    
    func setUIContents() {
        
        // UserLoginVC modal view setting
        userLoginVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        userLoginVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        
        // mode selector and data picker table cells
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        accountCell.textLabel?.text = "Account Profile"
        accountCell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        accountCell.textLabel?.textAlignment = NSTextAlignment.Center
        
        doctorListCell.textLabel?.text = "Doctor List"
        doctorListCell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        doctorListCell.textLabel?.textColor = self.view.tintColor
        doctorListCell.textLabel?.textAlignment = NSTextAlignment.Center
        
        logoutCell.textLabel?.text = "Log Out"
        logoutCell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        logoutCell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cells = [
            [accountCell, doctorListCell],
            [logoutCell]
        ]
        self.view.addSubview(self.tableView)
        
    }
    
    
    func setUILayout()
    {

    }
    
    // Actions for the touch events of the navigation items
    func toggleMenu(sender: UIButton) {
        sideMenuController()?.sideMenu?.toggleMenu()
    }
    
    func userLoginButton(sender: UIButton) {
        if UserInfoManager.hasLoggedIn() {
            var alert = UIAlertController(title: "User Has Logged In", message: "Please log out first", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.presentViewController(self.userLoginVC, animated: true, completion: nil)
            //self.userLogin("liwanbo", passwd: "123456")
        }
    }
    
    func accountCellTarget() {
        if UserInfoManager.hasLoggedIn() {
            // read local user info
            self.accountSetting()
        } else {
            // turn to log in operation
            var alert = UIAlertController(title: "No User Logged In", message: "Please log in first!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default, handler: { action in
                switch action.style{
                case .Default:
                    //self.userLogin("liwanbo", passwd: "123456")
                    self.presentViewController(self.userLoginVC, animated: true, completion: nil)
                default:
                    break
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showDoctorList () {
        self.navigationController?.pushViewController(doctorListVC, animated: true)
    }
    
    func logoutCellTarget() {
        if UserInfoManager.hasLoggedIn() {
            // log out
            self.userLogout()
        } else {
            // turn to log in operation
            var alert = UIAlertController(title: "No User Logged In", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    private func userLogin(username: String, passwd: String) {
        println("User Login")
        
        // POST(JSON) login test
        var requestLogin = HTTPTask()
        requestLogin.requestSerializer = JSONRequestSerializer()
        requestLogin.responseSerializer = JSONResponseSerializer()
        
        var params: Dictionary<String,AnyObject> = ["username": username, "password":passwd, "lastdevice":"unknown sdk", "version":"1.7", "imei":"000000000000000"]
        requestLogin.POST("http://ecg.ece.uvic.ca/rest/login", parameters: params,
            
            success: {(response: HTTPResponse) in
                println("response from: \(response.URL!)")
                if let data = response.responseObject as? NSDictionary {
                    println("log in data: \(data)")
                    
                    // deal with incorrect result from server
                    let result = data["result"] as String
                    if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil)  {
                        self.asyncAlert(title: "Login Error", alertMsg: "Error: \(result)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                        return
                    }
                    
                    // retrieve information
                    currentUser!.username = username
                    currentUser!.userid = String(data["userid"] as Int)
                    currentUser!.password = passwd

                    currentUser!.ifCSmode = data["ifcsmode"] as Bool
                    currentUser!.bpmthreshold = Int32(data["lowbpm"] as Int)
                    currentUser!.length_sample = Int32(data["savelength"] as Int)
                    
                    currentUser!.phone_emer = data["emergencynum"] as String
                    currentUser!.msg_emer = data["emergencymes"] as String
                    currentUser!.ifappendloc = data["ifappendloc"] as Bool
                    currentUser!.ifsendmsg = true
                    
                    // POST(JSON) downuserinfo (get further information)
                    var request_downuserinfo = HTTPTask()
                    request_downuserinfo.requestSerializer = JSONRequestSerializer()
                    request_downuserinfo.responseSerializer = JSONResponseSerializer()
                    
                    var params = ["userid":currentUser!.userid]
                    request_downuserinfo.POST("http://ecg.ece.uvic.ca/rest/downuserinfo", parameters: params,
                        
                        success: {(response: HTTPResponse) in
                            println("response from: \(response.URL!)")
                            if let data = response.responseObject as? NSDictionary {
                                println("user data: \(data)") //prints the HTML of the page
                                
                                // deal with incorrect result from server
                                let result = data["result"] as String
                                if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil)  {
                                    self.asyncAlert(title: "Login Error", alertMsg: "\(result)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                                    
                                    // turn back to temporary user
                                    if let user = userManager.getUserInfo("0") {
                                        tmpUser = user
                                    } else {
                                        // no remembered user info
                                        tmpUser = UserInfo()
                                    }
                                    currentUser = tmpUser
                                    
                                    return
                                }
                                
                                currentUser!.name_first = data["firstname"] as String
                                currentUser!.name_last = data["lastname"] as String
                                currentUser!.email = data["email"] as String
                                currentUser!.phone = data["phone"] as String
                                
                                // add or update local user
                                if userManager.saveUserInfo(currentUser!) == true {
                                    // successfully log in
                                    println("login success")
                                    
                                    // delete "0" user
                                    userManager.deleteUserInfo("0")
                                    
                                    // call UI update on the main thread
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.updateCellStatus(UserInfoManager.hasLoggedIn())
                                    })
                                    
                                } else {
                                    
                                    // turn back to temporary user
                                    if let user = userManager.getUserInfo("0") {
                                        tmpUser = user
                                    } else {
                                        // no remembered user info
                                        tmpUser = UserInfo()
                                    }
                                    currentUser = tmpUser
                                    
                                    self.asyncAlert(title: "CoreData Error", alertMsg: "Failed to save user information (delete user)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                                }
                                
                                
                            }
                        },
                        
                        failure: {(error: NSError, response: HTTPResponse?) in
                            println("error: \(error)")
                            self.asyncAlert(title: "Login Error", alertMsg: "Failed to fetch user information", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                            
                            // turn back to temporary user
                            if let user = userManager.getUserInfo("0") {
                                tmpUser = user
                            } else {
                                // no remembered user info
                                tmpUser = UserInfo()
                            }
                            currentUser = tmpUser
                    
                        }
                    )
                }
            },
            
            failure: {(error: NSError, response: HTTPResponse?) in
                self.asyncAlert(title: "Log in Error", alertMsg: "Failed to log in", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
            }
        )
    }
    
    private func accountSetting() {
        println("account setting")
        self.navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    private func userLogout() {
        // logout but remember user info
        userManager.deleteUserInfo(currentUser!.userid)
        currentUser!.userid = "0"
        userManager.saveUserInfo(currentUser!)
        /*userManager.deleteAllUserInfo()
        // currentUser points to a tmpUser with "0" userid
        tmpUser = UserInfo()
        currentUser = tmpUser*/
        self.updateCellStatus(UserInfoManager.hasLoggedIn())
    }
    
    private func updateCellStatus(logStatus: Bool) {
        if logStatus == true {
            self.accountCell.textLabel?.text = "Account Profile:\t\(currentUser!.username)"
            self.accountCell.textLabel?.textColor = self.view.tintColor
            self.logoutCell.textLabel?.textColor = self.view.tintColor
        } else {
            self.accountCell.textLabel?.text = "Account Profile"
            self.accountCell.textLabel?.textColor = UIColor.grayColor()
            self.logoutCell.textLabel?.textColor = UIColor.grayColor()
        }
        self.tableView.reloadData()
    }
    
    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
}


class UserLoginViewController: UITableViewController, UITextFieldDelegate {
    
    var parentVC: AccountSettingController?
    
    let userLoginNavigationBar = UINavigationBar()
    var tableFooterView: UIView!
    let clearUserInfoButton: UIButton = UIButton(frame: CGRectZero)
    
    var cells: NSArray = []
    //var tableView: UITableView!
    
    let usernameCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "Username")
    let passwdCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "Password")
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if (cell.isKindOfClass(InputTextCell)) {
            return (cell as InputTextCell).rowHeight
        }
        
        return tableView.estimatedRowHeight
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        switch (section) {
        case 0:
            return "LOGIN"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    
    override  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row] as UITableViewCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return tableFooterView
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else {
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        configNavigationBar()
        
        setUIContents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if parentVC == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if userManager.getUserInfo("0") == nil {
            // clear input
            usernameCell.inputText.text = ""
            passwdCell.inputText.text = ""
        } else {
            usernameCell.inputText.text = currentUser?.username
            passwdCell.inputText.text = currentUser?.password
        }
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutNavigationBar()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.layoutNavigationBar()
    }
    
    // configurations for the navigation bar
    func configNavigationBar() {
        
        // Re-define the navigation title and buttons
        self.navigationItem.title = "User Login"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "dismissLoginVC:")
        self.navigationItem.setLeftBarButtonItem(cancelButton, animated: false)
        
        let scanButton = UIBarButtonItem(title: "Login", style: .Plain, target: self, action: "loginTarget:")
        self.navigationItem.setRightBarButtonItem(scanButton, animated: false)
        
        self.userLoginNavigationBar.pushNavigationItem(self.navigationItem, animated: false)
        self.view.addSubview(self.userLoginNavigationBar)
    }
    
    func layoutNavigationBar() {
        self.userLoginNavigationBar.frame = CGRectMake(0, self.tableView.contentOffset.y, self.tableView.frame.size.width, self.topLayoutGuide.length + 44)
        self.tableView.contentInset = UIEdgeInsetsMake(self.userLoginNavigationBar.frame.size.height, 0, 0, 0)
        self.view.bringSubviewToFront(self.userLoginNavigationBar)
    }
    
    func setUIContents() {
        
        // cells
        usernameCell.inputText.placeholder = "Required"
        
        usernameCell.inputText.returnKeyType = UIReturnKeyType.Next
        usernameCell.inputText.delegate = self
        
        passwdCell.inputText.secureTextEntry = true
        passwdCell.inputText.returnKeyType = UIReturnKeyType.Done
        passwdCell.inputText.placeholder = "Your password"
        passwdCell.inputText.delegate = self
        
        clearUserInfoButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        clearUserInfoButton.setTitle("Clear Cache", forState: UIControlState.Normal)
        clearUserInfoButton.setTitleColor(self.view.tintColor, forState: UIControlState.Normal)
        clearUserInfoButton.backgroundColor = UIColor.clearColor()
        clearUserInfoButton.addTarget(self, action: "clearUserInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        
        tableFooterView = UIView()
        tableFooterView.backgroundColor = UIColor.clearColor()
        tableFooterView.addSubview(clearUserInfoButton)
        clearUserInfoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: clearUserInfoButton, toItem: tableFooterView, attribute: NSLayoutAttribute.Trailing, marginSize: 10))
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: clearUserInfoButton, toItem: tableFooterView, axisForCenter: "y", itemSize: CGPointMake(80, 20)))

        
        cells = [
            usernameCell, passwdCell
        ]
        
    }
    
    func dismissLoginVC(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginTarget(sender: UIButton) {
        
        if (usernameCell.inputText.text == "" || passwdCell.inputText.text == "") {
            self.asyncAlert(title: "Input Text Error", alertMsg: "Invalid username or password.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Cancel)
            return
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.parentVC?.userLogin(usernameCell.inputText.text, passwd: passwdCell.inputText.text)
    }
    
    func clearUserInfo(sender: UIButton) {
        // delete cached user information
        userManager.deleteAllUserInfo()
        tmpUser = UserInfo()
        currentUser = tmpUser
        
        // clear input
        usernameCell.inputText.text = ""
        passwdCell.inputText.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Execute additional code
        var row: Int = 0
        for row = 0; row < cells.count; row++ {
            if textField.superview?.superview == cells[row] as InputTextCell {
                if row == cells.count - 1 {
                    textField.resignFirstResponder()
                } else {
                    (cells[row + 1] as InputTextCell).inputText.becomeFirstResponder()
                }
                break
            }
        }
        
        if row == cells.count {
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


// viewcontroller for updating user infomation (UITableViewController can automatically scroll when inputting text)
class UserInfoViewController: UITableViewController, UITextFieldDelegate {
    
    // Table View
    var cells: NSArray = []
    //var tableView: UITableView!
    
    let firstNameCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "First Name")
    let lastNameCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "Last Name")
    
    let emailCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "E-mail")
    let phoneCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "Phone")
    
    let oldPasswdCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "Old Password", textLength: 160)
    let newPasswdCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "New Password", textLength: 160)
    let checkPasswdCell = InputTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil, labelText: "Confirm", textLength: 160)
    
    var tableFooterView: UIView!
    let updateProfileButton: UIPlainButton = UIPlainButton(titleColor: UIColor.whiteColor(), backgroundColor: UIColorPlatte.red600)
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if (cell.isKindOfClass(InputTextCell)) {
            return (cell as InputTextCell).rowHeight
        }
        
        if (cell.isKindOfClass(ButtonCell)) {
            return (cell as ButtonCell).rowHeight
        }
        
        return tableView.estimatedRowHeight
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        switch (section) {
        case 0:
            return "Name & Contact"
        case 1:
            return "Security"
        default:
            return ""
        }
    }
    
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    
   override  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row] as UITableViewCell
    }
    
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        firstNameCell.inputText.text = currentUser?.name_first
        lastNameCell.inputText.text = currentUser?.name_last
        
        emailCell.inputText.text = currentUser?.email
        phoneCell.inputText.text = currentUser?.phone
        
        oldPasswdCell.inputText.text = ""
        newPasswdCell.inputText.text = ""
        checkPasswdCell.inputText.text = ""
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
        let titleImage = UIImageView(frame: CGRectMake(0, 0, 25, 25))
        titleImage.image = UIImage(named: "personal_64.png")
        
        let titleText = UILabel(frame: CGRectMake(26, 0, 200, 30))
        titleText.text = "Profile Setting"
        titleText.textAlignment = NSTextAlignment.Left
        titleText.font = UIFont(name: "Helvetica", size: 16)
        titleText.adjustsFontSizeToFitWidth = true
        //titleText.textColor = UIColor.blueColor()
        
        let navTitle = UIView(frame: CGRectMake(0, 0, 200, 30))
        navTitle.addSubview(titleImage)
        navTitle.addSubview(titleText)
        self.navigationItem.titleView = navTitle
        
        // Re-define left bar items for toggleing the side menu
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonBack.frame = CGRectMake(0, 0, 25, 25)
        buttonBack.setImage(UIImage(named:"ic_action_previous_item.png"), forState: UIControlState.Normal)
        buttonBack.addTarget(self, action: "backToAccountSetting:", forControlEvents: UIControlEvents.TouchUpInside)
        var barLeftButtonToggleMenu: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(barLeftButtonToggleMenu, animated: true)
        
        // Re-define the right bar items
        let buttonRefresh: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonRefresh.frame = CGRectMake(0, 0, 28, 28)
        buttonRefresh.setImage(UIImage(named:"ic_action_refresh.png"), forState: UIControlState.Normal)
        buttonRefresh.addTarget(self, action: "refreshProfile:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightButtonRefresh: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        
        self.navigationItem.setRightBarButtonItems([barRightButtonRefresh], animated: true)
    }
    
    
    func setUIContents() {
        
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        // cells
        firstNameCell.inputText.placeholder = "Required"
        firstNameCell.inputText.returnKeyType = UIReturnKeyType.Next
        firstNameCell.inputText.delegate = self
        lastNameCell.inputText.placeholder = "Required"
        lastNameCell.inputText.returnKeyType = UIReturnKeyType.Next
        lastNameCell.inputText.delegate = self
        
        emailCell.inputText.keyboardType = UIKeyboardType.EmailAddress
        emailCell.inputText.returnKeyType = UIReturnKeyType.Next
        emailCell.inputText.placeholder = "example@gmail.com"
        emailCell.inputText.delegate = self
        phoneCell.inputText.keyboardType = UIKeyboardType.NumbersAndPunctuation
        phoneCell.inputText.placeholder = "17781234567"
        phoneCell.inputText.delegate = self
        
        oldPasswdCell.inputText.secureTextEntry = true
        oldPasswdCell.inputText.returnKeyType = UIReturnKeyType.Next
        oldPasswdCell.inputText.placeholder = "Your current password"
        oldPasswdCell.inputText.delegate = self
        newPasswdCell.inputText.secureTextEntry = true
        newPasswdCell.inputText.returnKeyType = UIReturnKeyType.Next
        newPasswdCell.inputText.placeholder = "Your new password"
        newPasswdCell.inputText.delegate = self
        checkPasswdCell.inputText.secureTextEntry = true
        checkPasswdCell.inputText.returnKeyType = UIReturnKeyType.Done
        checkPasswdCell.inputText.placeholder = "New password again"
        checkPasswdCell.inputText.delegate = self
        
        updateProfileButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        updateProfileButton.setTitle("Update Profile", forState: UIControlState.Normal)
        updateProfileButton.addTarget(self, action: "updateProfile:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // footer view for button
        tableFooterView = UIView()
        tableFooterView.backgroundColor = UIColor.clearColor()
        tableFooterView.addSubview(updateProfileButton)
        updateProfileButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: updateProfileButton, toItem: tableFooterView, axisForCenter: "x", itemSize: CGPointMake(self.tableView.frame.width * 0.6, 40)))
        tableFooterView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: updateProfileButton, toItem: tableFooterView, axisForCenter: "y", itemSize: nil))

        cells = [
            [firstNameCell, lastNameCell, emailCell, phoneCell],
            [oldPasswdCell, newPasswdCell, checkPasswdCell],
        ]
  
    }
    
    
    // Actions for the touch events of the navigation items
    func backToAccountSetting(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateProfile(sender: UIButton) {
        //println("Update Profle")
        
        // end editing
        self.view.endEditing(true)
    
        if (oldPasswdCell.inputText.text != "") {
            
            if (oldPasswdCell.inputText.text != currentUser!.password) {
                asyncAlert(title: "Password Error", alertMsg: "The old password is incorrect!", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                return
            }
            
            if (newPasswdCell.inputText.text == "") {
                asyncAlert(title: "Password Error", alertMsg: "The new password can not be blank!", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                return
            }
            
            if (newPasswdCell.inputText.text != checkPasswdCell.inputText.text) {
                asyncAlert(title: "Password Error", alertMsg: "The new passwords do not match!", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                return
            }

        }
        // not update passwork
        newPasswdCell.inputText.text = ""
        checkPasswdCell.inputText.text = ""
        
        // upload user information to server
        var request = HTTPTask()
        request.requestSerializer = JSONRequestSerializer()
        request.responseSerializer = nil
        
        // POST(JSON) upuserinfo
        var params: Dictionary<String, AnyObject> = ["userid":currentUser!.userid.toInt()!, "phone":phoneCell.inputText.text, "email":emailCell.inputText.text, "firstname":firstNameCell.inputText.text, "lastname":lastNameCell.inputText.text, "originalPW":oldPasswdCell.inputText.text, "newPW":newPasswdCell.inputText.text]
        
        request.POST("http://ecg.ece.uvic.ca/rest/upuserinfo", parameters: params,
            success: {(response: HTTPResponse) in
                println("response from: \(response.URL!)")
                if let data = response.responseObject as? NSData {
                    
                    let result = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                    //println("data: \(result)")
                    
                    if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil) {
                        self.asyncAlert(title: "Update Error", alertMsg: "Error: \(result)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                        //self.asyncAlert(title: "Update Error", alertMsg: "Failed to upload user information!", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                        return
                    }
                    
                    
                    currentUser!.name_first = self.firstNameCell.inputText.text
                    currentUser!.name_last = self.lastNameCell.inputText.text
                    currentUser!.email = self.emailCell.inputText.text
                    currentUser!.phone = self.phoneCell.inputText.text
                    
                    if (self.oldPasswdCell.inputText.text != "" && self.newPasswdCell.inputText.text != "") {
                        currentUser!.password = self.newPasswdCell.inputText.text
                    }
                    
                    if userManager.saveUserInfo(currentUser!) == true {
                        
                        self.asyncAlert(title: "Update Sussessfully", alertMsg: "User information has been uploaded to the ECG server.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
                        
                    } else {
                        
                        self.asyncAlert(title: "Database Error", alertMsg: "Can not save user information locally! Please log in again.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                        // codes to log out ??
                    }
                    
                }
            },
            failure: {(error: NSError, response: HTTPResponse?) in
                //println("error: \(error)")
                self.asyncAlert(title: "Update Error", alertMsg: "Failed to upload user information!", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
        })
    }
    
    func refreshProfile(sender: UIButton) {
        //println("refreshProfile")
        
        // POST(JSON) downuserinfo (get further information)
        var request_downuserinfo = HTTPTask()
        request_downuserinfo.requestSerializer = JSONRequestSerializer()
        request_downuserinfo.responseSerializer = JSONResponseSerializer()
        
        var params = ["userid":currentUser!.userid]
        request_downuserinfo.POST("http://ecg.ece.uvic.ca/rest/downuserinfo", parameters: params,
            
            success: {(response: HTTPResponse) in
                println("response from: \(response.URL!)")
                if let data = response.responseObject as? NSDictionary {
                    println("user data: \(data)")
                    
                    let result = data["result"] as String
                    if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil) {
                        self.asyncAlert(title: "Refresh Error", alertMsg: "Error: \(result)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                        return
                    }
                    
                    currentUser!.name_first = data["firstname"] as String
                    currentUser!.name_last = data["lastname"] as String
                    currentUser!.email = data["email"] as String
                    currentUser!.phone = data["phone"] as String
                    
                    // add or update local user
                    if userManager.saveUserInfo(currentUser!) == true {
                        // successfully log in
                        println("refresh profile successfully")
                        
                        // update page
                        dispatch_async(dispatch_get_main_queue(), {
                            self.firstNameCell.inputText.text = currentUser!.name_first
                            self.lastNameCell.inputText.text = currentUser!.name_last
                            self.emailCell.inputText.text = currentUser!.email
                            self.phoneCell.inputText.text = currentUser!.phone
                            
                            self.asyncAlert(title: "Refresh profile successfully", alertMsg: "User profile has been synchronized.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
                        })
                        
                    } else {
                        self.asyncAlert(title: "Database Error", alertMsg: "Failed to save user information! Please log in again.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                        // code to log out ??
                    }
                }
            },
            
            failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
                self.asyncAlert(title: "Refresh Error", alertMsg: "Failed to download user information", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
            }
        )
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        // Execute additional code
        var section: Int = 0
        var row: Int = 0
        loop: for section = 0; section < cells.count; section++ {
            for row = 0; row < (cells[section] as [InputTextCell]).count; row++ {
                if textField.superview?.superview == cells[section][row] as InputTextCell {
                    if row == (cells[section] as [InputTextCell]).count - 1 {
                        textField.resignFirstResponder()
                    } else {
                        (cells[section][row + 1] as InputTextCell).inputText.becomeFirstResponder()
                    }
                    break loop
                }
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


class DoctorListViewController: UITableViewController {

    var doctorList: [String] = []
    var doctorReq: [String] = []
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return tableView.estimatedRowHeight
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if doctorReq.count == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        if doctorReq.count == 0 {
            switch (section) {
            case 0:
                return "Doctor List"
            default:
                return ""
            }

        } else {
            switch (section) {
            case 0:
                return "Pending Doctor Requests"
            case 1:
                return "Doctor List"
            default:
                return ""
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if doctorReq.count == 0 {
            switch (section) {
            case 0:
                return doctorList.count
            default:
                return 0
            }
        } else {
            switch (section) {
            case 0:
                return doctorReq.count
            case 1:
                return doctorList.count
            default:
                return 0
            }
        }
    }
    
    
    override  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell =  UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        if doctorReq.count == 0 {
            cell.textLabel?.text = "Doctor: \(doctorList[indexPath.row])"
        } else {
            switch (indexPath.section) {
            case 0:
                cell.textLabel?.text = "Doctor request from \(doctorReq[indexPath.row])"
                break
            case 1:
                cell.textLabel?.text = "Doctor: \(doctorList[indexPath.row])"
                break
            default:
                break
            }
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var isDoctorReq: Bool = false
        if doctorReq.count > 0 && indexPath.section == 0 {
            isDoctorReq = true
        }
        
        if isDoctorReq {
            var reqInfo: String = doctorReq[indexPath.row]
            
            // action list for doctor request
            var doctorReqAlert = UIAlertController(title: "Action on the request:", message: "\(doctorReq[indexPath.row])", preferredStyle: UIAlertControllerStyle.ActionSheet)
            doctorReqAlert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default, handler: {UIAlertAction in
                self.comfirmRequest(reqInfo, decision: 1)
            }))
            doctorReqAlert.addAction(UIAlertAction(title: "Decline", style: UIAlertActionStyle.Default, handler: {UIAlertAction in
                self.comfirmRequest(reqInfo, decision: 0)
            }))
            doctorReqAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(doctorReqAlert, animated: true, completion: nil)

        }
        else {
            // action list for doctor record
            var doctorAlert = UIAlertController(title: "Action on the doctor:", message: "\(doctorList[indexPath.row])", preferredStyle: UIAlertControllerStyle.ActionSheet)
            doctorAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: {UIAlertAction in
                // do nothing
            }))
            doctorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(doctorAlert, animated: true, completion: nil)

        }
    }
    
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.estimatedRowHeight = 40
        
        
        configNavigationBar()
        
        setUIContents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        let titleImage = UIImageView(frame: CGRectMake(0, 0, 25, 25))
        titleImage.image = UIImage(named: "personal_64.png")
        
        let titleText = UILabel(frame: CGRectMake(26, 0, 200, 30))
        titleText.text = "Doctor List"
        titleText.textAlignment = NSTextAlignment.Left
        titleText.font = UIFont(name: "Helvetica", size: 16)
        titleText.adjustsFontSizeToFitWidth = true
        
        let navTitle = UIView(frame: CGRectMake(0, 0, 200, 30))
        navTitle.addSubview(titleImage)
        navTitle.addSubview(titleText)
        self.navigationItem.titleView = navTitle
        
        // Re-define left bar items for toggleing the side menu
        let buttonToggleMenu: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonToggleMenu.frame = CGRectMake(0, 0, 25, 25)
        buttonToggleMenu.setImage(UIImage(named:"ic_action_previous_item.png"), forState: UIControlState.Normal)
        buttonToggleMenu.addTarget(self, action: "backToAccountSetting:", forControlEvents: UIControlEvents.TouchUpInside)
        var barLeftButtonToggleMenu: UIBarButtonItem = UIBarButtonItem(customView: buttonToggleMenu)
        self.navigationItem.setLeftBarButtonItem(barLeftButtonToggleMenu, animated: true)
        
        // Re-define the right bar items
        let buttonRefresh: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonRefresh.frame = CGRectMake(0, 0, 28, 28)
        buttonRefresh.setImage(UIImage(named:"ic_action_refresh.png"), forState: UIControlState.Normal)
        buttonRefresh.addTarget(self, action: "refreshDoctorList:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightButtonRefresh: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        
        self.navigationItem.setRightBarButtonItems([barRightButtonRefresh], animated: true)


    }
    
    
    func setUIContents() {
        
    }
    
    // Actions for the touch events of the navigation items
    func backToAccountSetting(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func refreshDoctorList(sender: UIButton) {
        println("refreshDoctorList")
        getDoctorList()
    }
    
    private func getDoctorList() {

        // POST(JSON) getdatalist
        var request = HTTPTask()
        request.requestSerializer = JSONRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        
        var params: Dictionary<String,AnyObject> = ["username":currentUser!.username]
        request.POST("http://ecg.ece.uvic.ca/rest/get_doclist", parameters: params, success: {(response: HTTPResponse) in
            println("response from: \(response.URL!)")
            if let data = response.responseObject as? NSDictionary {
                println("data list: \(data)")
                
                let result = data["result"] as String
                if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil) {
                    self.asyncAlert(title: "No doctor or qequest found", alertMsg: "", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                } else {
                    
                    self.saveDoctorList(data)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
                
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                //println("error: \(error)")
                self.asyncAlert(title: "Failed to get doctor list", alertMsg: "\(error)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
        })
    }
    
    
    private func saveDoctorList(listData: NSDictionary) {
        doctorList.removeAll()
        doctorReq.removeAll()
        
        var doctorNum = listData["doctor_num"] as Int
        var reqNum = listData["access_request"] as Int
        
        for var index = 0; index < doctorNum; index++ {
            doctorList.append(listData["doctor\(index + 1)"] as String)
        }
        for var index = 0; index < reqNum; index++ {
            doctorReq.append(listData["doctor_request\(index + 1)"] as String)
        }
    }
    
    private func comfirmRequest(reqInfo: String, decision: Int) {
        
        if decision != 0 && decision != 1 {
            println("Incorrect decision value")
            return
        }
        
        // POST(JSON) getdatalist
        var request = HTTPTask()
        request.requestSerializer = JSONRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        
        var params: Dictionary<String,AnyObject> = ["username":currentUser!.username, "doctor_username":reqInfo, "decision": decision]
        request.POST("http://ecg.ece.uvic.ca/rest/confirm_request", parameters: params, success: {(response: HTTPResponse) in
            println("response from: \(response.URL!)")
            if let data = response.responseObject as? NSDictionary {
                //println("data list: \(data)")
                
                let result = data["result"] as String
                if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil) {
                    self.asyncAlert(title: "Failed to deal with request", alertMsg: "", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                } else {
                    
                    // delete local request
                    for var index = 0; index < self.doctorReq.count; index++ {
                        if self.doctorReq[index] == reqInfo {
                            self.doctorReq.removeAtIndex(index)
                            break
                        }
                    }
                    
                    // add doctor to the list if decision == 1
                    if decision == 1 {
                        self.doctorList.append(reqInfo)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                    
                }
                
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                //println("error: \(error)")
                self.asyncAlert(title: "Failed to deal with request", alertMsg: "\(error)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
        })
    }
    
    
    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}
