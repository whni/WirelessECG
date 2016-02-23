//
//  ECGAlert.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2015-01-19.
//  Copyright (c) 2015 UVic. All rights reserved.
//

import UIKit

class ECGAlert {
    class func asyncAlert(title tt: String, alertMsg: String, alertStyle:UIAlertControllerStyle, actionTitle: String, actionStyle: UIAlertActionStyle) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: tt, message: alertMsg, preferredStyle: alertStyle)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}
