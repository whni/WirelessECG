//
//  HeartRateMonitorController.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-15.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit
import CoreBluetooth

class HeartRateMonitorController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, LineChartDelegate {

    
    // about BLE device
    var BLEListVC: BLEListViewController!
    var myCBCentralManager: CBCentralManager!
    var myCBPeripheral: CBPeripheral? = nil
    var myCBCharacteristic: CBCharacteristic? = nil
    let ECG_BLE_DEVICE_NAME = "Heart Carer"
    let ECG_BLE_SERVICE_UUID = "180D"               // just part of the whole UUID
    let ECG_BLE_CHARACTERISTIC_UUID = "2A37"
    
    
    let ECGPlotView: LineChart = LineChart()  // ECG line chart
    
    let heartRateLabel: UILabel = UILabel()
    let heartRateLogo: UIImageView = UIImageView()
    
    let senseLabel: UILabel = UILabel()
    let senseSwitch: UISwitch = UISwitch()
    let dataUploadButton: UIPlainButton = UIPlainButton(titleColor: UIColor.whiteColor(), backgroundColor: UIColor.lightGrayColor())
    let disconnectButton: UIPlainButton = UIPlainButton(titleColor: UIColor.whiteColor(), backgroundColor: UIColor.lightGrayColor())
    
    var needUpdateCons: Bool = true
    var viewCons: NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
        
        // BLE config
        BLEListVC = BLEListViewController()
        BLEListVC.parentVC = self
        myCBCentralManager = CBCentralManager(delegate: self, queue: nil)
        
        configNavigationBar()
        
        setUIContents()
        setUILayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        needUpdateCons = true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        
        // update table menu insets
        self.navigationController?.sideMenuController()?.sideMenu?.updateMenuTableInset()
        // update ECG signal view
        self.ECGPlotView.setNeedsDisplay()
        needUpdateCons = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        needUpdateCons = true
        self.updateViewConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ECGPlotView.setNeedsDisplay()
        needUpdateCons = false
    }
    

    // configurations for the navigation bar
    func configNavigationBar() {
        
        // Re-define the navigation title
        let titleImage = UIImageView(frame: CGRectMake(0, 3, 25, 25))
        titleImage.image = UIImage(named: "hrmonitor_64.png")
        
        let titleText = UILabel(frame: CGRectMake(27, 0, 200, 30))
        titleText.text = "Heart Rate Monitor"
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
        let buttonRefresh: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonRefresh.frame = CGRectMake(0, 0, 28, 28)
        buttonRefresh.setImage(UIImage(named:"ic_action_refresh.png"), forState: UIControlState.Normal)
        buttonRefresh.addTarget(self, action: "refreshECGPlot:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightButtonRefresh: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        
        let buttonSensorSelect: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonSensorSelect.frame = CGRectMake(0, 0, 28, 25)
        buttonSensorSelect.setImage(UIImage(named:"ic_action_expand.png"), forState: UIControlState.Normal)
        buttonSensorSelect.addTarget(self, action: "sensorSelect:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightButtonSensorSelect: UIBarButtonItem = UIBarButtonItem(customView: buttonSensorSelect)
        
        self.navigationItem.setRightBarButtonItems([barRightButtonSensorSelect, barRightButtonRefresh], animated: true)

    }
    
    
    // UI contents configuration
    func setUIContents() {
        
        self.view.backgroundColor = UIColorPlatte.redecg
        
        // BLEListVC modal view setting
        BLEListVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        BLEListVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        
        // ECG line chart
        ECGPlotView.backgroundColor = UIColorPlatte.redecg
        
        ECGPlotView.axesVisible = true
        ECGPlotView.axesColor = UIColorPlatte.red500
        ECGPlotView.axisWidth = 1.0
        ECGPlotView.labelsXVisible = true
        ECGPlotView.labelsYVisible = true
        
        ECGPlotView.gridVisible = true
        ECGPlotView.gridColor = UIColorPlatte.red500
        ECGPlotView.gridLineWidth = 0.5
        ECGPlotView.numberOfGridLinesX = 6
        ECGPlotView.numberOfGridLinesY = 8
        
        ECGPlotView.xDataLength = 300  // 300 * 5 length
        ECGPlotView.yDataLength = 4.0
        ECGPlotView.drawPointInterval = 1
        ECGPlotView.maxDrawPointInterval = 2

        ECGPlotView.dotsVisible = false
        ECGPlotView.lineWidth = 0.5
        
        ECGPlotView.animationEnabled = false
        ECGPlotView.delegate = self
        self.view.addSubview(ECGPlotView)

        // sense label, switch and data upload button
        senseLabel.textAlignment = NSTextAlignment.Center
        senseLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        senseLabel.textColor = UIColor.grayColor()
        senseLabel.text = "Sense"
        self.view.addSubview(senseLabel)
        
        senseSwitch.setOn(false, animated: false)
        senseSwitch.backgroundColor = UIColor.whiteColor()
        senseSwitch.layer.cornerRadius = senseSwitch.frame.height / 2
        senseSwitch.addTarget(self, action: "senseChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(senseSwitch)
        
        dataUploadButton.setTitle("Upload Data", forState: UIControlState.Normal)
        dataUploadButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        dataUploadButton.addTarget(self, action: "dataUpload:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(dataUploadButton)
        
        disconnectButton.setTitle("Disconnect", forState: UIControlState.Normal)
        disconnectButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        disconnectButton.addTarget(self, action: "disconnectBLE:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(disconnectButton)
        
        // heart rate show
        heartRateLabel.textAlignment = NSTextAlignment.Center
        heartRateLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        heartRateLabel.textColor = UIColor.grayColor()
        heartRateLabel.text = "200 bpm"
        self.view.addSubview(heartRateLabel)
        
        heartRateLogo.image = UIImage(named: "main_heart_beat_64.png")
        self.view.addSubview(heartRateLogo)
        
    }
    
    func setUILayout() {
        
        var viewDict: [String: AnyObject] = [:]
        viewDict["ECGPlotView"] = ECGPlotView
        viewDict["senseLabel"] = senseLabel
        viewDict["senseSwitch"] = senseSwitch
        viewDict["dataUploadButton"] = dataUploadButton
        viewDict["heartRateLabel"] = heartRateLabel
        viewDict["heartRateLogo"] = heartRateLogo
        viewDict["disconnectButton"] = disconnectButton
        SimpleUILayout.enableConstraintForViewItems(itemArray: Array(viewDict.values))
        
        // update constraint and set the corresponding flag
        self.updateViewConstraints()
        self.displayECGFunctions()
    }
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if needUpdateCons {
            // remove existed constraints
            view.removeConstraints(self.viewCons)
            self.viewCons.removeAllObjects()
            
            // new constraints
            // layout for ECGPlotView
            var ECGPlotViewHeight: CGFloat = self.view.frame.height * 0.5
            if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                ECGPlotViewHeight = self.view.frame.height * 0.6
            }
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintCenter(item: ECGPlotView, toItem: self.view, axisForCenter: "x", itemSize: CGPointMake(self.view.frame.width - 20, ECGPlotViewHeight)))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintCenter(item: ECGPlotView, toItem: self.view, axisForCenter: "y", itemSize: CGPointMake(0.0, 0.0)))
            
            viewCons.addObjectsFromArray( SimpleUILayout.genLayoutConstraintMarginToSuperView(item: senseLabel, toItem: self.view, attribute: NSLayoutAttribute.Leading, marginSize: 20))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintNextToView(item: senseLabel, toItem: ECGPlotView, attribute: NSLayoutAttribute.Bottom, distance: 20))
            
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintNextToView(item: senseSwitch, toItem: senseLabel, attribute: NSLayoutAttribute.Trailing, distance: 10))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintSameAttrToView(item: senseLabel, toItem: senseSwitch, attribute: NSLayoutAttribute.CenterY))
            
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintSetSizeOfView(item: dataUploadButton, size: CGSizeMake(90, 35)))
            viewCons.addObjectsFromArray( SimpleUILayout.genLayoutConstraintMarginToSuperView(item: dataUploadButton, toItem: self.view, attribute: NSLayoutAttribute.Trailing, marginSize: 20))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintSameAttrToView(item: dataUploadButton, toItem: senseLabel, attribute: NSLayoutAttribute.CenterY))
            
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintSetSizeOfView(item: heartRateLabel, size: CGSizeMake(80, 30)))
            viewCons.addObjectsFromArray( SimpleUILayout.genLayoutConstraintMarginToSuperView(item: heartRateLabel, toItem: self.view, attribute: NSLayoutAttribute.Trailing, marginSize: 20))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintNextToView(item: heartRateLabel, toItem: ECGPlotView, attribute: NSLayoutAttribute.Top, distance: 0))
            
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintNextToView(item: heartRateLogo, toItem: heartRateLabel, attribute: NSLayoutAttribute.Leading, distance: 10))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintSameAttrToView(item: heartRateLogo, toItem: heartRateLabel, attribute: NSLayoutAttribute.CenterY))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintSetSizeOfView(item: heartRateLogo, size: CGSizeMake(30, 30)))
            
            viewCons.addObjectsFromArray( SimpleUILayout.genLayoutConstraintMarginToSuperView(item: disconnectButton, toItem: self.view, attribute: NSLayoutAttribute.Leading, marginSize: 20))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintSetSizeOfView(item: disconnectButton, size: CGSizeMake(80, 30)))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintSameAttrToView(item: disconnectButton, toItem: heartRateLabel, attribute: NSLayoutAttribute.CenterY))
            
            view.addConstraints(self.viewCons)
        }
    }
    

    
    // Actions for the touch events of the navigation items
    func toggleMenu(sender: UIButton) {
        sideMenuController()?.sideMenu?.toggleMenu()
    }
    
    
    func refreshECGPlot(sender: UIButton) {
        
        ECGPlotView.dataFollowMode = false
        ECGPlotView.yDataLength = 4
        ECGPlotView.xDataLength = 300
        ECGPlotView.dataOrigin.y = -0.5
        ECGPlotView.setNeedsDisplay()
        
    }
    
    
    func sensorSelect(sender: UIButton) {
        self.presentViewController(BLEListVC, animated: true, completion: nil)
    }
    
    
    func dataUpload(sender: UIButton) {
        
        // is sensing
        if myCBCharacteristic != nil && myCBCharacteristic?.isNotifying == true {
            var alert = UIAlertController(title: "Data Saving Error", message: "Please stop sensing before saving ECG data.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // less than 1 second
        if ECGFileData.count < 1000 {
            var alert = UIAlertController(title: "Data Saving Error", message: "Data buffer is clear now.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // user has not logged in
        if UserInfoManager.hasLoggedIn() == false {
            var alert = UIAlertController(title: "Data Saving Error", message: "Please log in first.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // delete overlength part
        let fileLength: Int = Int(currentUser!.length_sample)
        if ECGFileData.count - fileLength > 0 {
            ECGFileData.removeRange(Range(start: 0, end: ECGFileData.count - fileLength))
        }
        
        let starttime: NSDate = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        let dateString = timeFormatter.stringFromDate(starttime)
        timeFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        let timeString = timeFormatter.stringFromDate(starttime)
        let starttimeString = String("\(dateString):\(timeString)").stringByReplacingOccurrencesOfString(":", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let dataToUpload: NSData = NSData(bytes: ECGFileData as [Byte], length: ECGFileData.count)
        FileManager.saveDataToTemporaryDirectory(dataToUpload, path: "\(starttimeString).bin", subdirectory: nil)
        
        // upload data by http
        var request = HTTPTask()
        var params: Dictionary<String, AnyObject> = ["userid": currentUser!.userid,  "starttime": starttimeString, "length": "\(Int(ECGFileData.count / 1000))", "ifcs": currentUser!.ifCSmode.description, "content": HTTPUpload(fileUrl: NSURL(fileURLWithPath: (FileManager.applicationTemporaryDirectory().path!)+"/\(starttimeString).bin")!)]
        
        request.POST("http://ecg.ece.uvic.ca/rest/updata", parameters: params,
            success: {(response: HTTPResponse) in
                println("response from: \(response.URL)")
                
                if let data = response.responseObject as? NSData {
                    let result = NSString(data: data, encoding: NSUTF8StringEncoding)!.description
                    
                    if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil) {
                        self.asyncAlert(title: "Upload Data Error", alertMsg: "Failed to upload data.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Cancel)
                        return
                    } else {
                        self.asyncAlert(title: "Upload Data Successfully", alertMsg: "The ECG data has been uploaded to the server.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Cancel)
                        ECGFileData.removeAll(keepCapacity: false)
                    }
                }
            }
            ,
            failure: {
                (error: NSError, response: HTTPResponse?) in
                self.asyncAlert(title: "Upload Data Error", alertMsg: "Http error code: \(error)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Cancel)
            }
        )
        
        FileManager.deleteFileFromTemporaryDirectory("\(starttimeString).bin", subdirectory: nil)
        
    }
    
    func senseChanged(sender: UISwitch) {
        
        if senseSwitch.on && myCBCharacteristic != nil {
            if myCBCharacteristic?.isNotifying == false {
                
                ECGPlotView.clearData()
                ECGPlotView.dataFollowMode = true
                ECGPlotView.yDataLength = 4
                ECGPlotView.xDataLength = 300
                ECGPlotView.dataOrigin.y = -0.5
                ECGPlotView.setNeedsDisplay()
                
                // file saving setting
                ECGFileData = [UInt8](count: 0, repeatedValue: 0)
                
                myCBPeripheral?.setNotifyValue(true, forCharacteristic: myCBCharacteristic)
                
                return
            }
        }
        
        ECGPlotView.dataFollowMode = false
        senseSwitch.setOn(false, animated: false)
        myCBPeripheral?.setNotifyValue(false, forCharacteristic: myCBCharacteristic)
    }
    
    func disconnectBLE(sender: UIButton) {
        var alert = UIAlertController(title: "Disconnect BLE Device", message: "Are you sure to disconnect the current heart carer?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { Void in
            
            ECGFileData.removeAll(keepCapacity: false)
            self.ECGPlotView.clearData()
            self.ECGPlotView.dataFollowMode = false
            self.ECGPlotView.setNeedsDisplay()
            self.cleanPeripheralConnection()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // display function UI when a periperal is connected
    func displayECGFunctions() {
        if myCBPeripheral != nil {
            if myCBPeripheral!.state == CBPeripheralState.Connected {
                heartRateLabel.hidden = false
                heartRateLogo.hidden = false
                disconnectButton.hidden = false
                senseLabel.hidden = false
                senseSwitch.hidden = false
                dataUploadButton.hidden = false
                return
            }
        }
        
        heartRateLabel.hidden = true
        heartRateLogo.hidden = true
        disconnectButton.hidden = true
        senseLabel.hidden = true
        senseSwitch.hidden = true
        dataUploadButton.hidden = true
    }
    
    // line chart delegate function (to stop data follow mode when ECGPlotView touched)
    func didSelectDataPoint(point: CGPoint) {
        println("(ECGPlotView) - Data Follow Mode: \(ECGPlotView.dataFollowMode)")
    }
    
    
    // BLE function
    // Called when the state of bluetooth has been changed
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        switch (central.state) {
        case CBCentralManagerState.PoweredOn:
            println("BLE: Power On")
            
            break
        default:
            BLEListVC.dismissViewControllerAnimated(true, completion: nil)
            println("BLE unavailable")
        }
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        // Reject any where the value is above reasonable range
        if (RSSI.integerValue > -15) {
            return
        }
        
        println("Discovered \(peripheral.name?) at \(RSSI)")
        println("UUID: \(peripheral.identifier.UUIDString)")
        
        if (peripheral.name? != "Heart Carer") {
            return
        }
        
        // add newly found device to the list
        var appendPeripheral: Bool = true
        for existPeripheral in BLEListVC.peripheralList {
            if existPeripheral.identifier.UUIDString == peripheral.identifier.UUIDString {
                appendPeripheral = false
                break
            }
        }
        
        if appendPeripheral {
            BLEListVC.peripheralList.append(peripheral)
            BLEListVC.tableView.reloadData()
        }
        
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        
        println("Connected to \(peripheral.name)")
        self.senseSwitch.setOn(false, animated: false)
        self.displayECGFunctions()
        
        // re-resign the current peripheral reference
        myCBPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: ECG_BLE_SERVICE_UUID)])
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        // failure alert
        var alert = UIAlertController(title: "Connection Error", message: "Failed to establish connection to the heart carer.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Re-Connect", style: UIAlertActionStyle.Default, handler: {UIAlertAction in
            self.presentViewController(self.BLEListVC, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        self.displayECGFunctions()
    }
    
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Disconnected from \(peripheral.name)")
        self.displayECGFunctions()
    }
    
    
    // peripheral delegate
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if error != nil || peripheral.services.count == 0 {
            self.asyncAlert(title: "Service Not Found", alertMsg: "Cannot find the ECG service.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
            
            self.cleanPeripheralConnection()
            return
        }
        
        for myCBService in peripheral.services {
            if (myCBService as CBService).UUID.isEqual(CBUUID(string: ECG_BLE_SERVICE_UUID)) {
                println("Discover service \(myCBService) from \(peripheral.name)")
                peripheral.discoverCharacteristics([CBUUID(string: ECG_BLE_CHARACTERISTIC_UUID)], forService: myCBService as CBService)
            }
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if error != nil || service.characteristics.count == 0 {
            self.asyncAlert(title: "Characteristic Not Found", alertMsg: "Cannot find the ECG characteristic.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
            
            self.cleanPeripheralConnection()
            return
        }
        
        // Again, we loop through the array, just in case.
        for characteristic in service.characteristics {
            if (characteristic as CBCharacteristic).UUID.isEqual(CBUUID(string: ECG_BLE_CHARACTERISTIC_UUID)) {
                println("Discover characteristic \(characteristic) from \(service.description)")
                myCBCharacteristic = characteristic as? CBCharacteristic
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            self.asyncAlert(title: "Failed to set notification", alertMsg: "Cannot set the notification of the ECG characteristic.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
            
            self.cleanPeripheralConnection()
            return
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            println("Error reading value: \(error)")
            return
        }
        
        let data: NSData = characteristic.value
        var byteArray: [UInt8] = [UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&byteArray, length: data.length)
        
        
        
        // file saving
        var fileLength: Int = Int(currentUser!.length_sample)
        // double-size queue buffer
        if ECGFileData.count + data.length - 1 - fileLength >= fileLength {
            ECGFileData.removeRange(Range(start: 0, end: ECGFileData.count + data.length - 1 - fileLength))
        }
        ECGFileData.extend(byteArray[1...(data.length - 1)])
        
        // 60 second display
        if ECGPlotView.dataStore.count >= 12000 {
            ECGPlotView.clearData()
        }
        
        var ECGPlotData: Array<CGFloat> = Array<CGFloat>(count: (data.length - 1) / plotSampleLen, repeatedValue: 0)
        for var index = 0; index < Int((data.length - 1) / plotSampleLen); index++ {
            
            var sumSample: CGFloat = 0.0
            for var cnt = index * plotSampleLen + 1; cnt <= index * plotSampleLen + plotSampleLen; cnt++ {
                sumSample += CGFloat(byteArray[cnt])
            }
            
            ECGPlotData[index] = (sumSample / CGFloat(plotSampleLen)) * 3.3 / 256
        }

        ECGPlotView.addData(ECGPlotData)
        ECGPlotView.setNeedsDisplay()

    }
    
    
    func cleanPeripheralConnection() {
        // Don't do anything if we're not connected
        if (self.myCBPeripheral == nil) {
            return
        }
        
        // See if we are subscribed to a characteristic on the peripheral
        if (self.myCBPeripheral!.services != nil) {
            for service in self.myCBPeripheral!.services {
                if (service as CBService).characteristics != nil {
                    for characteristic in (service as CBService).characteristics {
                        if (characteristic as CBCharacteristic).isNotifying {
                            // It is notifying, so unsubscribe
                            self.myCBPeripheral!.setNotifyValue(false, forCharacteristic: characteristic as CBCharacteristic)
                        }
                    }
                }
            }
        }
        self.myCBCentralManager.cancelPeripheralConnection(self.myCBPeripheral)
    }
    
    
    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}




class BLEListViewController: UITableViewController {
    
    var parentVC: HeartRateMonitorController?
    let BLENavigationBar: UINavigationBar = UINavigationBar()
    
    var scanTimer: NSTimer? = nil
    var connectTimer: NSTimer? = nil
    var peripheralList: Array<CBPeripheral> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configNavigationBar()
    }
    
    // state check
    override func viewWillAppear(animated: Bool) {
        if parentVC == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if parentVC?.myCBCentralManager.state != CBCentralManagerState.PoweredOn {
            
            var alert = UIAlertController(title: "BLE State Error", message: "Please turn on your bluetooth.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel, handler: {Void in
                self.dismissViewControllerAnimated(true, completion: nil)}))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if parentVC?.myCBPeripheral != nil {
            switch(parentVC!.myCBPeripheral!.state) {
            case CBPeripheralState.Connected:
                
                var alert = UIAlertController(title: "Connection State Error", message: "A BLE Device has already been connected. Do you want to disconnect it first?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: {Void in
                    self.dismissViewControllerAnimated(true, completion: nil)}))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {Void in
                    self.parentVC!.ECGPlotView.clearData()
                    self.parentVC!.ECGPlotView.dataFollowMode = false
                    self.parentVC!.ECGPlotView.setNeedsDisplay()
                    self.parentVC!.cleanPeripheralConnection()}))
                self.presentViewController(alert, animated: true, completion: nil)

                return
                
            case CBPeripheralState.Connecting:
                self.parentVC?.myCBCentralManager.cancelPeripheralConnection(self.parentVC?.myCBPeripheral)
                if self.connectTimer != nil {
                    self.connectTimer?.invalidate()
                    self.connectTimer = nil
                }
                break
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.navigationItem.title = "BLE Device List"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "dismissListVC:")
        self.navigationItem.setLeftBarButtonItem(cancelButton, animated: false)

        let scanButton = UIBarButtonItem(title: "Scan", style: .Plain, target: self, action: "refreshBLEList:")
        self.navigationItem.setRightBarButtonItem(scanButton, animated: false)

        self.BLENavigationBar.pushNavigationItem(self.navigationItem, animated: false)
        self.view.addSubview(self.BLENavigationBar)
    }
    
    func layoutNavigationBar() {
        self.BLENavigationBar.frame = CGRectMake(0, self.tableView.contentOffset.y, self.tableView.frame.size.width, self.topLayoutGuide.length + 44)
        self.tableView.contentInset = UIEdgeInsetsMake(self.BLENavigationBar.frame.size.height, 0, 0, 0)
        self.view.bringSubviewToFront(self.BLENavigationBar)
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralList.count
    }
    
    
    override  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        
        var cellImage = UIImage(named: "main_heart_beat_40.png")
        cell.imageView?.image = cellImage
        cell.textLabel?.text = peripheralList[indexPath.row].name
        cell.detailTextLabel?.text = peripheralList[indexPath.row].identifier.UUIDString
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var alert = UIAlertController(title: "Confirm to connect", message: "Device: \(peripheralList[indexPath.row].name)\nUUID: \(peripheralList[indexPath.row].identifier.UUIDString)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Connect", style: UIAlertActionStyle.Default, handler: { UIAlertAction in
            // stop scanc
            if self.scanTimer != nil {
                self.scanTimer?.invalidate()
                self.scanTimer = nil
            }
            self.parentVC?.myCBCentralManager.stopScan()
            
            if self.parentVC?.myCBPeripheral != nil {
                
                switch(self.parentVC!.myCBPeripheral!.state) {
                    // device already connected
                case CBPeripheralState.Connected, CBPeripheralState.Connecting:
                    self.asyncAlert(title: "Cannot establish connection", alertMsg: "Please disconnect the current BLE device first.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
                    return
                    
                case CBPeripheralState.Disconnected:
                    // discard the current peripheral object
                    self.parentVC?.myCBPeripheral = nil
                }
                
            }
            
            // connect to selected peripheral device
            self.parentVC?.myCBPeripheral = self.peripheralList[indexPath.row]
            self.parentVC?.myCBCentralManager.connectPeripheral(self.parentVC?.myCBPeripheral, options: nil)
            
            self.connectTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("connectTimeOut"), userInfo: nil, repeats: false)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Found BLE Device"
    }
    
    func dismissListVC(sender: UIButton) {
        if scanTimer != nil {
            scanTimer?.invalidate()
            scanTimer = nil
        }
        self.parentVC?.myCBCentralManager.stopScan()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshBLEList(sender: UIButton) {
        // delete scan timer
        if scanTimer != nil {
            scanTimer?.invalidate()
            scanTimer = nil
        }

        // clean peripheral list
        peripheralList.removeAll()
        self.tableView.reloadData()
        
        parentVC?.myCBCentralManager.scanForPeripheralsWithServices(nil, options: nil)
        
        // restart a scan timer (timeout: 15 second)
        scanTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("scanTimeOut"), userInfo: nil, repeats: false)
    }

    func scanTimeOut() {
        
        if peripheralList.isEmpty {
            self.asyncAlert(title: "Scan Time Out", alertMsg: "No peripheral device found.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Cancel)
        }
        parentVC?.myCBCentralManager.stopScan()
        
        // delete scan timer
        scanTimer = nil
    }
    
    func connectTimeOut() {
        if parentVC?.myCBPeripheral != nil && parentVC?.myCBPeripheral?.state == CBPeripheralState.Connecting {
            self.parentVC?.myCBCentralManager.cancelPeripheralConnection(self.parentVC?.myCBPeripheral)
            self.parentVC?.asyncAlert(title: "Connect Time Out", alertMsg: "Cannot connect to the heart carer.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Cancel)
        }
        
        // delete connect timer
        connectTimer = nil
    }
    
    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}

