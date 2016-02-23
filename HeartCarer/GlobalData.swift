//
//  GlobalData.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-21.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit
import CoreData

// Data for HeartRateViewController

// instantiate view controller objects
let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)

let heartRateMonitorVC = HeartRateMonitorController()
let dataManageVC = DataManageController()
let accountSettingVC = AccountSettingController()
let notificationSettingVC = NotificationSettingController()
let generalSettingVC = GeneralSettingController()
let aboutInfoVC = AboutInfoController()

var viewControllerSet: [UIViewController] = [heartRateMonitorVC, dataManageVC, accountSettingVC, notificationSettingVC, generalSettingVC, aboutInfoVC]


enum DataCompressedMode : Int {
    case Normal = 0
    case Compressed
}


let plotSampleLen = 5
var ECGFileData: [UInt8] = []   // a queue for uploading ECG data


let saveLengthOption: [Int] = [1, 2, 3, 5, 10, 20, 30, 60]
let bpmThresOption: [Int] = [40, 45, 50, 55, 60, 65, 70, 75, 80]

// for current user
var tmpUser = UserInfo()
var currentUser: UserInfo?
var userManager: UserInfoManager = UserInfoManager()
