//
//  CustomTableViewCells.swift
//  HeartCarer
//
//  Created by Weiheng on 2015-01-04.
//  Copyright (c) 2015 UVic. All rights reserved.
//

import UIKit


//-------------------Data Picker Cell------------------
//
//  by Dylan Vann on 2014-10-21.
//  Copyright (c) 2014 Dylan Vann. All rights reserved.
//

// DVColorLockView ovverides the backgroundColor setter for UIView so that highlighting a UITableViewCell won't change the color of its DVColorLockView subviews (Highlighting a UITableViewCell changes the background color of all subviews, it's annoying.)
class DVColorLockView: UIView {
    
    var lockedBackgroundColor:UIColor {
        set {
            super.backgroundColor = newValue
        }
        get {
            return super.backgroundColor!
        }
    }
    
    override var backgroundColor:UIColor? {
        set {
        }
        get {
            return super.backgroundColor
        }
    }
    
}


class DVDatePickerTableViewCell: UITableViewCell {
    
    // Class variable workaround.
    struct Stored {
        static var dateFormatter = NSDateFormatter()
    }
    
    var date:NSDate = NSDate() {
        didSet {
            datePicker.date = date
            
            DVDatePickerTableViewCell.Stored.dateFormatter.dateFormat = "yyyy-MM-dd"
            rightLabel.text = DVDatePickerTableViewCell.Stored.dateFormatter.stringFromDate(date)
        }
    }
    var timeStyle = NSDateFormatterStyle.ShortStyle, dateStyle = NSDateFormatterStyle.ShortStyle
    
    var leftLabel = UILabel(), rightLabel = UILabel()
    var rightLabelTextColor = UIColor(hue: 0.639, saturation: 0.041, brightness: 0.576, alpha: 1.0) //Color of normal detail label.
    
    var seperator = DVColorLockView()
    
    var datePickerContainer = UIView()
    var datePicker: UIDatePicker = UIDatePicker()
    
    var expanded = false
    var unexpandedHeight = CGFloat(44)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // The datePicker overhangs the view slightly to avoid invalid constraints.
        self.clipsToBounds = true
        
        var views = [leftLabel, rightLabel, seperator, datePickerContainer, datePicker]
        for view in views {
            self.contentView .addSubview(view)
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        datePickerContainer.clipsToBounds = true
        datePickerContainer.addSubview(datePicker)
        
        // Add a seperator between the date text display, and the datePicker. Lighter grey than a normal seperator.
        seperator.lockedBackgroundColor = UIColor(white: 0, alpha: 0.1)
        datePickerContainer.addSubview(seperator)
        datePickerContainer.addConstraints([
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 0.5
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
        
        rightLabel.textColor = rightLabelTextColor
        
        //Left label.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 44
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            ])
        
        //Right label
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 44
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            ),
            ])
        
        // Container.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: leftLabel,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePickerContainer,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 1
            ),
            ])
        
        // Picker constraints.
        datePickerContainer.addConstraints([
            NSLayoutConstraint(
                item: datePicker,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePicker,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: datePicker,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: datePickerContainer,
                attribute: NSLayoutAttribute.CenterY,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
        datePicker.addTarget(self, action: "datePicked", forControlEvents: UIControlEvents.ValueChanged)
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        self.date = NSDate()
        datePicker.date = date
        DVDatePickerTableViewCell.Stored.dateFormatter.dateFormat = "yyyy-MM-dd"
        rightLabel.text = DVDatePickerTableViewCell.Stored.dateFormatter.stringFromDate(date)
        //setDate(NSDate())
        leftLabel.text = "Date Picker"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func datePickerHeight() -> CGFloat {
        var expandedHeight = unexpandedHeight + CGFloat(datePicker.frame.size.height)
        return expanded ? expandedHeight : unexpandedHeight
    }
    
    func selectedInTableView(tableView: UITableView) {
        expanded = !expanded
        
        UIView.transitionWithView(rightLabel, duration: 0.25, options:UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in self.rightLabel.textColor = self.expanded ? self.tintColor : self.rightLabelTextColor }, completion: nil)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func datePicked() {
        date = datePicker.date
    }
}



//-----------------Mode Select Cell-----------------
// by Weiheng Ni

class ModeSelectCell: UITableViewCell, UIPickerViewDataSource,UIPickerViewDelegate {
    
    let rowHeight: CGFloat = 32.0
    let rows = ["Normal", "Compressed"]
    var compressedMode: DataCompressedMode = DataCompressedMode.Normal {
        didSet {
            modePicker.selectRow(compressedMode.rawValue, inComponent: 0, animated: false)
            rightLabel.text = rows[compressedMode.rawValue]
        }
    }
    
    //MARK: - Delegates and datasources
    //MARK: Data Sources
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rows.count
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.contentView.frame.width
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            
            //color  and center the label's background
            pickerLabel.backgroundColor = UIColor.clearColor()
            pickerLabel.textAlignment = .Center
            
        }
        let titleData = rows[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 20.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        compressedMode = DataCompressedMode(rawValue: row)!
    }
    
    
    
    var leftLabel = UILabel(), rightLabel = UILabel()
    var rightLabelTextColor = UIColor(hue: 0.639, saturation: 0.041, brightness: 0.576, alpha: 1.0) //Color of normal detail label.
    
    var seperator = DVColorLockView()
    
    var pickerContainer = UIView()
    var modePicker: UIPickerView = UIPickerView()
    
    var expanded = false
    var unexpandedHeight = CGFloat(44)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // bind data source and delegate
        self.modePicker.dataSource = self
        self.modePicker.delegate = self
        
        // The datePicker overhangs the view slightly to avoid invalid constraints.
        self.clipsToBounds = true
        
        var views = [leftLabel, rightLabel, seperator, pickerContainer, modePicker]
        for view in views {
            self.contentView.addSubview(view)
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        pickerContainer.clipsToBounds = true
        pickerContainer.addSubview(modePicker)
        
        // Add a seperator between the date text display, and the datePicker. Lighter grey than a normal seperator.
        seperator.lockedBackgroundColor = UIColor(white: 0, alpha: 0.1)
        pickerContainer.addSubview(seperator)
        pickerContainer.addConstraints([
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 0.5
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
        
        rightLabel.textColor = rightLabelTextColor
        
        //Left label.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 44
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            ])
        
        //Right label
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 44
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            ),
            ])
        
        // Container.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: pickerContainer,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: pickerContainer,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: pickerContainer,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: leftLabel,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: pickerContainer,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: 1
            ),
            ])
        
        // Picker constraints.
        pickerContainer.addConstraints([
            NSLayoutConstraint(
                item: modePicker,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: modePicker,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 0
            ),
            /*NSLayoutConstraint(
                item: modePicker,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.CenterY,
                multiplier: 1.0,
                constant: 0
            ),*/
            NSLayoutConstraint(
                item: modePicker,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: modePicker,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
        compressedMode = DataCompressedMode.Normal
        modePicker.selectRow(compressedMode.rawValue, inComponent: 0, animated: false)
        rightLabel.text = rows[compressedMode.rawValue]
        leftLabel.text = "Mode"
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pickerHeight() -> CGFloat {
        var expandedHeight = unexpandedHeight + CGFloat(modePicker.frame.size.height)
        return expanded ? expandedHeight : unexpandedHeight
    }
    
    func selectedInTableView(tableView: UITableView) {
        expanded = !expanded
        
        UIView.transitionWithView(rightLabel, duration: 0.25, options:UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in self.rightLabel.textColor = self.expanded ? self.tintColor : self.rightLabelTextColor }, completion: nil)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}


//-----------------Number Select Cell-----------------
// by Weiheng Ni

class NumberSelectCell: UITableViewCell, UIPickerViewDataSource,UIPickerViewDelegate {
    
    let rowHeight: CGFloat = 32.0
    var rows: Array<Int> = []
    var leftLabelStr: String?
    var rightLabelStr: String?
    
    var numberIndex: Int = 0 {
        didSet {
            modePicker.selectRow(numberIndex, inComponent: 0, animated: false)
            rightLabel.text = "\(rows[numberIndex]) \(rightLabelStr!)"
        }
    }
    
    //MARK: - Delegates and datasources
    //MARK: Data Sources
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rows.count
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.contentView.frame.width
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            
            //color  and center the label's background
            pickerLabel.backgroundColor = UIColor.clearColor()
            pickerLabel.textAlignment = .Center
            
        }
        let titleData = "\(rows[row]) \(rightLabelStr!)"
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 20.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberIndex = row
    }
    
    var leftLabel = UILabel(), rightLabel = UILabel()
    var rightLabelTextColor = UIColor(hue: 0.639, saturation: 0.041, brightness: 0.576, alpha: 1.0) //Color of normal detail label.
    
    var seperator = DVColorLockView()
    
    var pickerContainer = UIView()
    var modePicker: UIPickerView = UIPickerView()
    
    var expanded = false
    var unexpandedHeight = CGFloat(44)
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, numArray: NSMutableArray, leftStr: String, rightStr: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add rows data
        if numArray.count == 0 {
            numArray.addObject(NSNumber(integer: 0))
        }
        for var index = 0; index < numArray.count; index++ {
            rows.append(numArray[index].integerValue)
        }
        
        leftLabelStr = leftStr
        rightLabelStr = rightStr
        
        // bind data source and delegate
        self.modePicker.dataSource = self
        self.modePicker.delegate = self
        
        // The datePicker overhangs the view slightly to avoid invalid constraints.
        self.clipsToBounds = true
        
        var views = [leftLabel, rightLabel, seperator, pickerContainer, modePicker]
        for view in views {
            self.contentView.addSubview(view)
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        pickerContainer.clipsToBounds = true
        pickerContainer.addSubview(modePicker)
        
        // Add a seperator between the date text display, and the datePicker. Lighter grey than a normal seperator.
        seperator.lockedBackgroundColor = UIColor(white: 0, alpha: 0.1)
        pickerContainer.addSubview(seperator)
        pickerContainer.addConstraints([
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 0.5
            ),
            NSLayoutConstraint(
                item: seperator,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
        
        rightLabel.textColor = rightLabelTextColor
        
        //Left label.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 44
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: leftLabel,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: self.separatorInset.left
            ),
            ])
        
        //Right label
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 44
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: rightLabel,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: -self.separatorInset.left
            ),
            ])
        
        // Container.
        self.contentView.addConstraints([
            NSLayoutConstraint(
                item: pickerContainer,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: pickerContainer,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: pickerContainer,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: leftLabel,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: pickerContainer,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.contentView,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: 1
            ),
            ])
        
        // Picker constraints.
        pickerContainer.addConstraints([
            NSLayoutConstraint(
                item: modePicker,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: modePicker,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 0
            ),

            NSLayoutConstraint(
                item: modePicker,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: modePicker,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: pickerContainer,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 0
            ),
            ])
        
        numberIndex = 0
        modePicker.selectRow(numberIndex, inComponent: 0, animated: false)
        rightLabel.text = "\(rows[numberIndex]) \(rightLabelStr!)"
        rightLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        leftLabel.text = "\(leftLabelStr!)"
        leftLabel.font = UIFont(name: "Helvetica Neue", size: 14)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func pickerHeight() -> CGFloat {
        var expandedHeight = unexpandedHeight + CGFloat(modePicker.frame.size.height)
        return expanded ? expandedHeight : unexpandedHeight
    }
    
    func selectedInTableView(tableView: UITableView) {
        expanded = !expanded
        
        UIView.transitionWithView(rightLabel, duration: 0.25, options:UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in self.rightLabel.textColor = self.expanded ? self.tintColor : self.rightLabelTextColor }, completion: nil)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}


//-----------------Search Button Cell---------------
// Re-define the table view cell for search button
// By Weiheng Ni

class TwoButtonCell: UITableViewCell {
    
    var button1: UIPlainButton?
    var button2: UIPlainButton?
    
    var rowHeight: CGFloat = 120
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, button1: UIPlainButton, button2: UIPlainButton) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.button1 = button1
        self.button2 = button2
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonRadius = rowHeight * 1.25 / 4
        
        if (button1 != nil) {
            
            button1!.layer.cornerRadius = buttonRadius
            self.contentView .addSubview(button1!)
            button1!.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: button1!, toItem: self.contentView, axisForCenter: "y", itemSize: CGPointMake(buttonRadius * 2, buttonRadius * 2)))
            self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: button1!, toItem: self.contentView, attribute: NSLayoutAttribute.Leading, marginSize: rowHeight / 2))
        }
        
        if (button2 != nil) {
            
            button2!.layer.cornerRadius = buttonRadius
            self.contentView .addSubview(button2!)
            button2!.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: button2!, toItem: self.contentView, axisForCenter: "y", itemSize: CGPointMake(buttonRadius * 2, buttonRadius * 2)))
            self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: button2!, toItem: self.contentView, attribute: NSLayoutAttribute.Trailing, marginSize: rowHeight / 2))
        }
        
    }
    
}

//-----------------Button Cell---------------
// Re-define the table view cell for search button
// By Weiheng Ni

class ButtonCell: UITableViewCell {
    
    var button: UIPlainButton?
    var buttonSize: CGPoint?
    
    var rowHeight: CGFloat = 44
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, button: UIPlainButton) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.button = button
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if buttonSize == nil {
            self.buttonSize = CGPointMake(self.contentView.frame.width * 0.8, self.contentView.frame.height - 4)
        }
        
        if (button != nil) {
            self.contentView .addSubview(button!)
            button!.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: button!, toItem: self.contentView, axisForCenter: "y", itemSize: buttonSize!))
            
            self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: button!, toItem: self.contentView, axisForCenter: "x", itemSize: buttonSize!))
        }
    }
}



//-----------------Input Text Cell---------------
// Re-define the table view cell for inputting text
// By Weiheng Ni

class InputTextCell: UITableViewCell {
    
    var inputLabel: UILabel = UILabel()
    var inputText: UITextField = UITextField()
    
    var inputTextLength: CGFloat = 0.0
    var rowHeight: CGFloat = 40
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, labelText: String, textLength: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        defaultSetting()
        inputTextLength = textLength
        inputLabel.text = labelText
        
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, labelText: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        defaultSetting()
        inputLabel.text = labelText
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        defaultSetting()
    }
    
    internal func defaultSetting() {
        
        inputTextLength = self.contentView.frame.width * 2.8 / 5
        
        inputLabel.text = "Test"
        inputLabel.textAlignment = NSTextAlignment.Left
        inputLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        self.contentView.addSubview(inputLabel)
        inputLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        inputText.font = UIFont(name: "Helvetica Neue", size: 14)
        inputText.adjustsFontSizeToFitWidth = true
        inputText.borderStyle = UITextBorderStyle.RoundedRect
        inputText.placeholder = ""
        inputText.keyboardType = UIKeyboardType.Default
        inputText.returnKeyType = UIReturnKeyType.Done
        inputText.backgroundColor = UIColor.whiteColor()
        inputText.autocorrectionType = UITextAutocorrectionType.No
        inputText.autocapitalizationType = UITextAutocapitalizationType.None
        inputText.textAlignment = NSTextAlignment.Left
        inputText.tag = 0
        inputText.clearButtonMode = UITextFieldViewMode.Never
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(inputText)
        inputText.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: inputLabel, toItem: self.contentView, axisForCenter: "y", itemSize: nil))
        self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: inputLabel, toItem: self.contentView, attribute: NSLayoutAttribute.Leading, marginSize: self.separatorInset.left))
        
        self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: inputText, toItem: self.contentView, axisForCenter: "y", itemSize: CGPointMake(inputTextLength, rowHeight - 10)))
        self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: inputText, toItem: self.contentView, attribute: NSLayoutAttribute.Trailing, marginSize: self.separatorInset.left * 2))
        
    }
    
}

//-----------------Right View Cell---------------
// Re-define the table view cell with a Switch on the right side
// By Weiheng Ni

class RightToggleCell: UITableViewCell {
    
    var leftText: UILabel = UILabel()
    var rightView: UIView?
    var rightViewSize: CGSize?
    
    var rowHeight: CGFloat = 44
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, text: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defaultSetting()
        leftText.text = text
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defaultSetting()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func defaultSetting() {
        
        leftText.text = "Test"
        leftText.numberOfLines = 0
        leftText.textAlignment = NSTextAlignment.Left
        leftText.font = UIFont(name: "Helvetica Neue", size: 14)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(leftText)
        leftText.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: leftText, toItem: self.contentView, axisForCenter: "y", itemSize: nil))
        self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: leftText, toItem: self.contentView, attribute: NSLayoutAttribute.Leading, marginSize: self.separatorInset.left))

        if (rightView != nil) {
            
            self.contentView .addSubview(rightView!)
            rightView!.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintCenter(item: rightView!, toItem: self.contentView, axisForCenter: "y", itemSize: nil))
            self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintMarginToSuperView(item: rightView!, toItem: self.contentView, attribute: NSLayoutAttribute.Trailing, marginSize: self.separatorInset.left))
            
            if (rightViewSize != nil) {
                self.contentView.addConstraints(SimpleUILayout.genLayoutConstraintSetSizeOfView(item: rightView!, size: rightViewSize!))
            }
        }
        
    }
    
}




