//
//  DataManageController.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-15.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit

class DataManageController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // Table View
    var cells: NSArray = []
    var tableView: UITableView!
    var dataListVC = ECGDataListViewController()
    
    let modeSelectCell = ModeSelectCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    
    let fromDateCell = DVDatePickerTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    let toDateCell = DVDatePickerTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    
    let searchButtonCell = TwoButtonCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
    let searchButton: UIPlainButton = UIPlainButton(titleColor: UIColor.whiteColor(), backgroundColor: UIColorPlatte.red600)
    let searchAllButton: UIPlainButton = UIPlainButton(titleColor: UIColor.whiteColor(), backgroundColor: UIColorPlatte.red600)
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(DVDatePickerTableViewCell)) {
            return (cell as DVDatePickerTableViewCell).datePickerHeight()
        }
        
        if (cell.isKindOfClass(ModeSelectCell)) {
            return (cell as ModeSelectCell).pickerHeight()
        }
        
        if (cell.isKindOfClass(TwoButtonCell)) {
            return (cell as TwoButtonCell).rowHeight
        }
        
        return tableView.estimatedRowHeight
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        switch (section) {
        case 0:
            return ""
        case 1:
            return "Date Range"
        case 2:
            return "Ready to Search"
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
        if (cell.isKindOfClass(DVDatePickerTableViewCell)) {
            var datePickerTableViewCell = cell as DVDatePickerTableViewCell
            datePickerTableViewCell.selectedInTableView(tableView)
        }
        if (cell.isKindOfClass(ModeSelectCell)) {
            var datePickerTableViewCell = cell as ModeSelectCell
            datePickerTableViewCell.selectedInTableView(tableView)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 2 {
            return false
        }
        return true
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

        // Re-defined navigation title
        let titleImage = UIImageView(frame: CGRectMake(0, 0, 25, 25))
        titleImage.image = UIImage(named: "clouddata_64.png")
        
        let titleText = UILabel(frame: CGRectMake(26, 0, 200, 30))
        titleText.text = "Data Management"
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
        self.navigationItem.setLeftBarButtonItems([barLeftButtonToggleMenu], animated: true)
        
        // Re-define the right bar items
        let buttonUpload: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonUpload.frame = CGRectMake(0, 0, 28, 28)
        buttonUpload.setImage(UIImage(named:"ic_action_upload.png"), forState: UIControlState.Normal)
        buttonUpload.addTarget(self, action: "uploadData:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightButtonUpload: UIBarButtonItem = UIBarButtonItem(customView: buttonUpload)
        self.navigationItem.setRightBarButtonItems([barRightButtonUpload], animated: true)
        
    }
    
    func setUIContents() {
        
        // mode selector and data picker table cells
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 48
        
        modeSelectCell.leftLabel.text = "Mode"
        
        fromDateCell.leftLabel.text = "From"
        toDateCell.leftLabel.text = "To"
        
        searchButton.setTitle("Search", forState: UIControlState.Normal)
        searchButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        searchButton.addTarget(self, action: "searchData:", forControlEvents: UIControlEvents.TouchUpInside)
        searchAllButton.setTitle("Search\nAll", forState: UIControlState.Normal)
        searchAllButton.titleLabel?.numberOfLines = 0
        searchAllButton.titleLabel?.textAlignment = NSTextAlignment.Center
        searchAllButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        searchAllButton.addTarget(self, action: "searchAllData:", forControlEvents: UIControlEvents.TouchUpInside)
        searchButtonCell.button1 = searchButton
        searchButtonCell.button2 = searchAllButton
        
        cells = [
            [modeSelectCell],
            [fromDateCell, toDateCell],
            [searchButtonCell]
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
    
    func uploadData(sender: UIButton) {
        println("uploadData")
    }
    
    func searchData(sender: UIButton) {
        // println("Search Button")
        
        var timeInterval: NSTimeInterval = toDateCell.date.timeIntervalSinceDate(fromDateCell.date)
        
        if timeInterval <= 0.0 {
            self.asyncAlert(title: "Date Error", alertMsg: "The end date is before the start date!", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
        } else {
            dataListVC.setSearchParams(startdate: fromDateCell.date, enddate: toDateCell.date, mode: modeSelectCell.compressedMode, ifSearchAll: false)
            self.navigationController?.pushViewController(dataListVC, animated: true)
        }
    }
    
    func searchAllData(sender: UIButton) {
        // println("Search All Data")
        dataListVC.setSearchParams(startdate: fromDateCell.date, enddate: toDateCell.date, mode: modeSelectCell.compressedMode, ifSearchAll: true)
        self.navigationController?.pushViewController(dataListVC, animated: true)
    }
    
    
    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
}



struct ECGListRecord {
    var date: String    // e.g. "2014-03-19 16:04:46"
    var length: Int
}

// view controller for the ECG data list on server
class ECGDataListViewController: UITableViewController {
    
    var mode: DataCompressedMode = DataCompressedMode.Normal
    var startdate: NSDate = NSDate()
    var enddate: NSDate = NSDate()
    var ifSearchAll: Bool = false
    
    var ECGDataList: [ECGListRecord] = []
    var ECGDataCount: [Int] = []
    
    let ECGPlotVC = ECGRecordPlotController()
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return tableView.estimatedRowHeight
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if ECGDataCount.count == 0 {
            return 1
        } else {
            return ECGDataCount.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        if ECGDataList.count == 0 || ECGDataCount.count == 0 {
            return "No ECG Data"
        } else {
            // the first record of this section
            var recordPos = ECGDataCount[0...section].reduce(0, combine: +) - ECGDataCount[section]
            var firstRecord: String = ECGDataList[recordPos].date
            // parse the date from the record
            var sectionTitle: String = (firstRecord.componentsSeparatedByString(" "))[0]
            sectionTitle += " (\(ECGDataCount[section]) items)"
            return sectionTitle
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ECGDataCount.count == 0 {
            return 1
        } else {
            return ECGDataCount[section]
        }
    }
    
    
    override  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        
        if ECGDataList.count > 0 && ECGDataCount.count > 0 {
            var dataRecord = ECGDataList[ECGDataCount[0...indexPath.section].reduce(0, combine: +) - ECGDataCount[indexPath.section] + indexPath.row]
            var recordTime = (dataRecord.date.componentsSeparatedByString(" "))[1]
            var recordLength = dataRecord.length
            
            cell.textLabel?.text = recordTime
            cell.detailTextLabel?.text = "\(recordLength)s"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var recordLabel = ECGDataList[ECGDataCount[0...indexPath.section].reduce(0, combine: +) - ECGDataCount[indexPath.section] + indexPath.row].date
        recordLabel = recordLabel.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        recordLabel = recordLabel.stringByReplacingOccurrencesOfString(":", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        
        // action list
        var alert = UIAlertController(title: "Action on the record:", message: "\(recordLabel)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "View Plot", style: UIAlertActionStyle.Default, handler: {UIAlertAction in

            self.ECGPlotVC.recordLabel = recordLabel
            self.navigationController?.pushViewController(self.ECGPlotVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: {UIAlertAction in
            self.deleteECGRecord(recordLabel)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func setSearchParams(startdate sdate: NSDate, enddate: NSDate, mode: DataCompressedMode, ifSearchAll: Bool) {
        
        // search parameters
        self.startdate = sdate
        self.enddate = enddate
        self.mode = mode
        self.ifSearchAll = ifSearchAll
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configNavigationBar()
        
        setUIContents()
        setUILayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ECGDataList.removeAll()
        ECGDataCount.removeAll()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.getECGDataList()
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
        titleImage.image = UIImage(named: "clouddata_64.png")
        
        let titleText = UILabel(frame: CGRectMake(26, 0, 200, 30))
        titleText.text = "ECG Data List"
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
        buttonToggleMenu.setImage(UIImage(named:"ic_action_previous_item.png"), forState: UIControlState.Normal)
        buttonToggleMenu.addTarget(self, action: "backToDataManagement:", forControlEvents: UIControlEvents.TouchUpInside)
        var barLeftButtonToggleMenu: UIBarButtonItem = UIBarButtonItem(customView: buttonToggleMenu)
        self.navigationItem.setLeftBarButtonItem(barLeftButtonToggleMenu, animated: true)
        
        // Re-define the right bar items
        let buttonRefresh: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonRefresh.frame = CGRectMake(0, 0, 28, 28)
        buttonRefresh.setImage(UIImage(named:"ic_action_refresh.png"), forState: UIControlState.Normal)
        buttonRefresh.addTarget(self, action: "refreshDataList:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightButtonRefresh: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        
        self.navigationItem.setRightBarButtonItems([barRightButtonRefresh], animated: true)
    }
    
    
    func setUIContents() {
        
        //tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        //tableView.dataSource = self
        //tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    func setUILayout()
    {
        
    }
    
    
    // get data list from ECG server
    func getECGDataList() {
        
        // set parameter
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        var sdate: String = dateFormater.stringFromDate(self.startdate)
        sdate += "_00-00-00"
        var edate: String = dateFormater.stringFromDate(self.enddate)
        edate += "_23_59_59"
        var dataMode: String = (self.mode == DataCompressedMode.Compressed) ? "Compressed" : "Normal"
        
        
        // POST(JSON) getdatalist
        var request = HTTPTask()
        request.requestSerializer = JSONRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        
        var params: Dictionary<String,AnyObject> = ["userid":currentUser!.userid.toInt()!, "startdate":sdate, "enddate":edate, "ifSearchAll":self.ifSearchAll, "datamode":dataMode]
        request.POST("http://ecg.ece.uvic.ca/rest/getdatalist", parameters: params, success: {(response: HTTPResponse) in
            println("response from: \(response.URL!)")
            if let data = response.responseObject as? NSArray {
                //println("data list: \(data)")
                if self.saveECGDataList(data) <= 0 {
                    self.asyncAlert(title: "No Record Found", alertMsg: "", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                } else {
                
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
                
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                //println("error: \(error)")
                self.asyncAlert(title: "Search Error", alertMsg: "\(error)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
        })
        
    }
    
    // save ECG data to the array for displaying the tableview
    // return the record number
    func saveECGDataList(dataArray: NSArray) -> Int {
        // delete all data records
        ECGDataList.removeAll()
        ECGDataCount.removeAll()
        
        if dataArray.count <= 1 {
            return 0
        }
        
        // save records in the list and count the numbers
        var preDate: String = "0000-00-00"
        var curDate: String = "0000-00-01"
        
        for var index = 1; index < dataArray.count; index += 2 {
            var recordTime = dataArray[index] as String
            var recordLength = dataArray[index + 1] as Int
            var dataRecord = ECGListRecord(date: recordTime, length: recordLength)
            ECGDataList.append(dataRecord)
            
            // get the date of current record
            curDate = (recordTime.componentsSeparatedByString(" "))[0]
            if curDate == preDate {
                ECGDataCount[ECGDataCount.count - 1]++
            } else {
                ECGDataCount.append(1)      // new date
            }
            preDate = curDate
        }
        
        return (dataArray.count - 1) / 2
    }
    
    
    func deleteECGRecord(recordLabel: String) {
        
        // POST(JSON) delete record
        var request = HTTPTask()
        request.requestSerializer = JSONRequestSerializer()
        
        var params: Dictionary<String,AnyObject> = ["userid": currentUser!.userid.toInt()!, "starttime": recordLabel]
        request.POST("http://ecg.ece.uvic.ca/rest/deletedata", parameters: params, success: {(response: HTTPResponse) in
            println("response from: \(response.URL!)")
            if let data = response.responseObject as? NSData {
                let result = NSString(data: data, encoding: NSUTF8StringEncoding)!.description
                
                if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil) {
                    self.asyncAlert(title: "Failed to delete record", alertMsg: "Cannot delete record (\(recordLabel)).", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
                
                } else {
                    self.asyncAlert(title: "Delete record successfully", alertMsg: "Record (\(recordLabel)) has been deleted.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
                    var recordCount = self.ECGDataCount.reduce(0, combine: +)
                    var recordSection = 0
                    var recordIndex = 0
                    for ; recordIndex < recordCount; recordIndex++ {
                        // goto next section
                        if recordIndex >= self.ECGDataCount[0...recordSection].reduce(0, combine: +) {
                            recordSection++
                        }
                        var recordDate = self.ECGDataList[recordIndex].date
                        recordDate = recordDate.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        recordDate = recordDate.stringByReplacingOccurrencesOfString(":", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        if recordDate == recordLabel {
                            self.ECGDataList.removeAtIndex(recordIndex)
                            self.ECGDataCount[recordSection]--
                            if self.ECGDataCount[recordSection] == 0 {
                                self.ECGDataCount.removeAtIndex(recordSection)
                            }
                            break
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                self.asyncAlert(title: "Failed to delete record", alertMsg: "Cannot delete record (\(recordLabel)).", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Done", actionStyle: UIAlertActionStyle.Default)
        })
    }
    
    
    // Actions for the touch events of the navigation items
    func backToDataManagement(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func refreshDataList(sender: UIButton) {
        println("refreshProfile")
        self.getECGDataList()
    }
    
    
    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
}



class ECGRecordPlotController: UIViewController, LineChartDelegate {
    
    let ECGPlotView: LineChart = LineChart()  // ECG line chart
    let ECGRecordLabel: UILabel = UILabel()
    var recordLabel: String = ""

    var needUpdateCons: Bool = true
    var viewCons: NSMutableArray = []
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Reset plot view
        self.ECGViewSettingForDataRecord()
        ECGPlotView.clearData()
        ECGPlotView.setNeedsDisplay()
        
        needUpdateCons = true
        self.updateViewConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ECGPlotView.setNeedsDisplay()
        needUpdateCons = false
    }
    
    // reload UI components when rotating screen
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        needUpdateCons = true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)

        // update side menu table
        self.navigationController?.sideMenuController()?.sideMenu?.updateMenuTableInset()
        
        // update ECG signal view
        self.ECGPlotView.setNeedsDisplay()
        
        needUpdateCons = false
    }

    
    
    // configurations for the navigation bar
    func configNavigationBar() {
        
        // Re-define the navigation title
        let titleImage = UIImageView(frame: CGRectMake(0, 0, 25, 25))
        titleImage.image = UIImage(named: "clouddata_64.png")
        
        let titleText = UILabel(frame: CGRectMake(26, 0, 200, 30))
        titleText.text = "ECG Data Record"
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
        buttonBack.addTarget(self, action: "backToDataManagement:", forControlEvents: UIControlEvents.TouchUpInside)
        var barLeftButtonToggleMenu: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.setLeftBarButtonItem(barLeftButtonToggleMenu, animated: true)
        
        
        // Re-define the right bar items
        let buttonRefresh: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonRefresh.frame = CGRectMake(0, 0, 28, 28)
        buttonRefresh.setImage(UIImage(named:"ic_action_refresh.png"), forState: UIControlState.Normal)
        buttonRefresh.addTarget(self, action: "refreshECGPlot:", forControlEvents: UIControlEvents.TouchUpInside)
        var barRightButtonRefresh: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        
        self.navigationItem.setRightBarButtonItems([barRightButtonRefresh], animated: true)
        
    }
    
    
    // UI contents configuration
    func setUIContents() {
        self.view.backgroundColor = UIColorPlatte.redecg
        
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
        
        ECGPlotView.dotsVisible = false
        ECGPlotView.lineWidth = 0.5
        ECGPlotView.animationEnabled = false
        
        ECGPlotView.dataFollowMode = false
        self.ECGViewSettingForDataRecord()
        
        ECGPlotView.delegate = self
        self.view.addSubview(ECGPlotView)
        
        ECGRecordLabel.text = "Date: \(recordLabel)"
        ECGRecordLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        ECGRecordLabel.textAlignment = NSTextAlignment.Left
        self.view.addSubview(ECGRecordLabel)
        
    }
    
    func setUILayout() {
        
        var viewDict: [String: AnyObject] = [:]
        viewDict["ECGPlotView"] = ECGPlotView
        viewDict["ECGRecordLabel"] = ECGRecordLabel

        SimpleUILayout.enableConstraintForViewItems(itemArray: Array(viewDict.values))
        
        self.updateViewConstraints()
    }
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if needUpdateCons {
            self.view.removeConstraints(self.viewCons)
            self.viewCons.removeAllObjects()
            
            // new constraints
            // layout for ECGPlotView
            var ECGPlotViewHeight: CGFloat = self.view.frame.height * 0.5
            if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                ECGPlotViewHeight = self.view.frame.height * 0.6
            }
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintCenter(item: ECGPlotView, toItem: self.view, axisForCenter: "x", itemSize: CGPointMake(self.view.frame.width - 10, ECGPlotViewHeight)))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintCenter(item: ECGPlotView, toItem: self.view, axisForCenter: "y", itemSize: CGPointMake(0.0, 0.0)))
            
            viewCons.addObjectsFromArray( SimpleUILayout.genLayoutConstraintMarginToSuperView(item: ECGRecordLabel, toItem: self.view, attribute: NSLayoutAttribute.Leading, marginSize: 20))
            viewCons.addObjectsFromArray(SimpleUILayout.genLayoutConstraintNextToView(item: ECGRecordLabel, toItem: ECGPlotView, attribute: NSLayoutAttribute.Top, distance: 0))
            
            self.view.addConstraints(self.viewCons)
        }
    }

    
    private func ECGViewSettingForDataRecord() {
        
        ECGPlotView.dataFollowMode = false
        ECGPlotView.dataOrigin.y = 0.0
        ECGPlotView.dataOrigin.x = 0.0
        ECGPlotView.xDataLength = 300
        ECGPlotView.yDataLength = 4
        ECGPlotView.maxDrawPointInterval = 2
        ECGPlotView.drawPointInterval = 1
        
    }
    
    func getDataRecord(recordDate: String) {
        
        if recordLabel == "" {
            self.asyncAlert(title: "No record showed", alertMsg: "Record time is not provided.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
            return
        }
        
        var dataArray: Array<CFloat> = []
        
        var request = HTTPTask()
        request.requestSerializer = JSONRequestSerializer()
        request.responseSerializer = JSONResponseSerializer()
        
        var params: Dictionary<String, AnyObject> = ["userid":currentUser!.userid, "starttime":recordDate]
        request.POST("http://ecg.ece.uvic.ca/rest/downdata", parameters: params,
            success: {(response: HTTPResponse) in
                println("response from: \(response.URL)")
                if let data = response.responseObject as? NSDictionary {
                    //println("data: \(data)")
                    
                    let result = data["result"] as String
                    if (result.rangeOfString("Success") == nil) && (result.rangeOfString("success") == nil) {
                        self.asyncAlert(title: "Download Data Error", alertMsg: "Error: \(result)", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
                        return
                    }
                    
                    let base64Str: String = data["content"] as String
                    let decodeData = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                    
                    let dataLength = decodeData.length > 60 * 1000 ? 60 * 1000 : decodeData.length
                    
                    var dataArray: Array<Byte> = [Byte](count: dataLength, repeatedValue: 0)
                    decodeData.getBytes(&dataArray, length: dataLength)
                    
                    //println(dataArray)
                    self.ECGPlotView.clearData()
                    for var index = 0; index < dataLength; index += plotSampleLen {
                        self.ECGPlotView.addData(CGFloat(dataArray[index]) * 3.3 / 256)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.ECGPlotView.setNeedsDisplay()
                    })
                    
                }
            },
            failure: {
                (error: NSError, response: HTTPResponse?) in
                //println("error: \(error)")
                self.asyncAlert(title: "Download Data Error", alertMsg: "Failed to download data record.", alertStyle: UIAlertControllerStyle.Alert, actionTitle: "Cancel", actionStyle: UIAlertActionStyle.Cancel)
            }
        )

    }
    
    
    // Actions for the touch events of the navigation items
    func backToDataManagement(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func refreshECGPlot(sender: UIButton) {
        self.ECGPlotView.clearData()
        self.ECGViewSettingForDataRecord()
        ECGPlotView.setNeedsDisplay()
        
        self.getDataRecord(recordLabel)
    }
    

    
    // line chart delegate function (to stop data follow mode when ECGPlotView touched)
    func didSelectDataPoint(point: CGPoint) {
        
    }

    private func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}





