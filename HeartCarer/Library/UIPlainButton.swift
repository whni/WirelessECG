//
//  UIPlainButton.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-18.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit


// A button class with plain-style
class UIPlainButton: UIButton {
    
    // lightened and darken version of backgroundColor
    var lightBackgroundColor: UIColor
    var darkBackgroundColor: UIColor {
        get {
            return UIColor.darkenUIColor(lightBackgroundColor)
        }
        set (newValue) {
            lightBackgroundColor = UIColor.lightenUIColor(newValue)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.lightBackgroundColor = UIColor.whiteColor()
        super.init(coder: aDecoder)
    }

    override init() {
        // default parameters for the plain button
        self.lightBackgroundColor = UIColorPlatte.red600
        super.init(frame: CGRectZero)
        defaultButtonSetting()
        self.backgroundColor = lightBackgroundColor
    }
    
    init(titleColor tc: UIColor, backgroundColor bgc: UIColor) {
        
        self.lightBackgroundColor = bgc
        super.init(frame: CGRectZero)
        defaultButtonSetting()
        self.titleLabel?.tintColor = tc
        self.backgroundColor = lightBackgroundColor
    }
    
    init(titleColor tc: UIColor, backgroundColor bgc: UIColor, frame fr: CGRect) {
        
        self.lightBackgroundColor = bgc
        super.init(frame: fr)
        defaultButtonSetting()
        self.titleLabel?.tintColor = tc
        self.backgroundColor = lightBackgroundColor
    }

    internal func defaultButtonSetting () {
        // variables
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 0.0
        self.titleLabel?.tintColor = UIColor.whiteColor()
        
        // methods and actions
        addTarget(self, action: "touchDown:", forControlEvents: UIControlEvents.TouchDown)
        addTarget(self, action: "touchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // darken button when it is touched
    internal func touchDown(sender: UIButton) {
        backgroundColor = darkBackgroundColor
    }
    internal func touchUpInside(sender: UIButton) {
        backgroundColor = lightBackgroundColor
    }
    
}