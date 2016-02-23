//
//  SimpleUILayout.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2014-12-17.
//  Copyright (c) 2014 UVic. All rights reserved.
//

import UIKit

// The class for simplifying the layout constraints
class SimpleUILayout {
    
    // Generate the layout constraints for centering one view in the superview
    class func genLayoutConstraintCenter(item view1: AnyObject, toItem view2: AnyObject, axisForCenter axisCenter: String, itemSize itsize: CGPoint?) -> NSArray {
        var consArray: NSMutableArray = []
        
        switch (axisCenter) {
        case "y":
            consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal , toItem: view2, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
            break
            
        default:
            consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal , toItem: view2, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
            
        }
        
        if (itsize != nil) {
            if (itsize!.x > 0.0) {
                consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal , toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0.0, constant: itsize!.x))
            }
            if (itsize!.y > 0.0) {
                consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal , toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0.0, constant: itsize!.y))
            }
        }
        
        return consArray
    }
    
    // Generate the layout constraints for characterizing the margin of a view to its superview
    class func genLayoutConstraintMarginToSuperView(item view1: AnyObject, toItem view2: AnyObject, attribute attr: NSLayoutAttribute, marginSize msize: CGFloat) -> NSArray {
        var consArray: NSMutableArray = []
        
        switch (attr)
        {
        case NSLayoutAttribute.Leading, NSLayoutAttribute.Top:
            consArray.addObject(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: NSLayoutRelation.Equal , toItem: view2, attribute: attr, multiplier: 0.0, constant: msize))
            break
        case NSLayoutAttribute.Trailing, NSLayoutAttribute.Bottom:
            consArray.addObject(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: NSLayoutRelation.Equal , toItem: view2, attribute: attr, multiplier: 1.0, constant: 0.0 - msize))
            break
        default:
            break
        }
        return consArray
    }
    
    // Generate the layout constraints to set view1 next to view2 with dsize distance
    class func genLayoutConstraintNextToView(item view1: AnyObject, toItem view2: AnyObject, attribute attr: NSLayoutAttribute, distance dsize: CGFloat) -> NSArray {
        var consArray: NSMutableArray = []
        
        switch (attr)
        {
        case NSLayoutAttribute.Leading:
            consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal , toItem: view2, attribute: attr, multiplier: 1.0, constant: -dsize))
            break
        case NSLayoutAttribute.Trailing:
            consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal , toItem: view2, attribute: attr, multiplier: 1.0, constant: dsize))
            break
        case NSLayoutAttribute.Top:
            consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: attr, multiplier: 1.0, constant: -dsize))
            break
        case NSLayoutAttribute.Bottom:
            consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: attr, multiplier: 1.0, constant: dsize))
        default:
            break
        }
        return consArray
    }
    
    // Generate the layout constraints to set view1 next to view2 with dsize distance
    class func genLayoutConstraintAlignToView(item view1: AnyObject, toItem view2: AnyObject, attribute attr: NSLayoutAttribute) -> NSArray {
        var consArray: NSMutableArray = []
        
        consArray.addObject(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: attr, multiplier: 1.0, constant: 0.0))
        
        return consArray
    }
    
    // Generate the layout constraints to set a dimension of one view
    class func genLayoutConstraintDimensionSizeToNum(item view1: AnyObject, attribute attr: NSLayoutAttribute, dimSize dsize: CGFloat) -> NSArray {
        var consArray: NSMutableArray = []
        
        consArray.addObject(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: dsize))
        
        return consArray
    }
    
    // Generate the layout constraints to set an attribute of one view (equal to that of another view)
    class func genLayoutConstraintSameAttrToView(item view1: AnyObject, toItem view2: AnyObject, attribute attr: NSLayoutAttribute) -> NSArray {
        var consArray: NSMutableArray = []
        
        consArray.addObject(NSLayoutConstraint(item: view1, attribute: attr, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: attr, multiplier: 1.0, constant: 0.0))
        
        return consArray
    }
    
    // Generate the layout constraints to set the size of one view 
    class func genLayoutConstraintSetSizeOfView(item view1: AnyObject, size sz: CGSize) -> NSArray {
        var consArray: NSMutableArray = []
        
        consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0.0, constant: sz.width))
        
        consArray.addObject(NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0.0, constant: sz.height))
        
        return consArray
    }

    
    // Enable the constraint-based layout for the view items
    class func enableConstraintForViewItems(itemArray arr: [AnyObject]) {
        for viewItem in arr as [UIView] {
            viewItem.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
    }
    
}