//
//  UserManagedInfo.swift
//  HeartCarer
//
//  Created by Weiheng Ni on 2015-01-14.
//  Copyright (c) 2015 UVic. All rights reserved.
//

// add, read, write, delete user records

import UIKit
import CoreData

// mapped to UserManagedInfo entity
class UserManagedInfo: NSManagedObject {

    @NSManaged var bpmthreshold: NSNumber
    @NSManaged var length_sample: NSNumber
    @NSManaged var email: String
    @NSManaged var msg_emer: String
    @NSManaged var name_first: String
    @NSManaged var name_last: String
    @NSManaged var password: String
    @NSManaged var phone: String
    @NSManaged var phone_emer: String
    @NSManaged var userid: String
    @NSManaged var ifappendloc: NSNumber
    @NSManaged var ifCSmode: NSNumber
    @NSManaged var ifsendmsg: NSNumber
    @NSManaged var username: String
}


class UserInfo {
    
    var username: String = "nonuser"
    var name_first: String = "noname"
    var name_last: String = ""
    var email: String = "example@gmail.com"
    var password: String = ""
    var phone: String = "2501112222"
    var userid: String = "0"
    
    var ifCSmode: Bool = false
    var bpmthreshold: Int32 = 50
    var length_sample: Int32 = 120000
    
    var phone_emer: String = "2501112222"
    var msg_emer: String = "Emergency!!!"
    var ifappendloc: Bool = false
    var ifsendmsg: Bool = false
    
}

class UserInfoManager {
    
    // managedObjectContext for managing the CoreData entities
    var managedObjectContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    // save one entity instance to core data model
    func saveUserInfo(user: UserInfo) -> Bool {
        // check managedObjectContext
        if (self.managedObjectContext == nil) {
            println("Managed Object Context initialization failed!")
            return false
        }
        
        // fetch user list with target_userid
        let userArray = fetchUserInfo(user.userid)
        if userArray.count > 0 {
            // update user indtead of adding user
            return updateUserInfo(user)
        }
        
        // get entity description
        let entityDescroption = NSEntityDescription.entityForName("UserManagedInfo", inManagedObjectContext: self.managedObjectContext!)
        // new UserInfo object
        let newUser = UserManagedInfo(entity: entityDescroption!, insertIntoManagedObjectContext: self.managedObjectContext!)
        
        newUser.username = user.username
        newUser.name_first = user.name_first
        newUser.name_last = user.name_last
        newUser.email = user.email
        newUser.password = user.password
        newUser.phone = user.phone
        newUser.userid = user.userid
        
        newUser.ifCSmode = user.ifCSmode
        newUser.bpmthreshold = NSNumber(int: user.bpmthreshold)
        newUser.length_sample = NSNumber(int: user.length_sample)
        
        newUser.phone_emer = user.phone_emer
        newUser.msg_emer = user.msg_emer
        newUser.ifappendloc = user.ifappendloc
        newUser.ifsendmsg = user.ifsendmsg
        
        var error: NSError?
        
        managedObjectContext?.save(&error)
        
        if let err = error {
            println("\(err.localizedFailureReason)")
            return false
        }
        
        return true
    }
    
    
    // return the user list by giving userid ("any" for all users)
    private func fetchUserInfo(target_userid: String) -> [UserManagedInfo] {
        // check managedObjectContext
        if (self.managedObjectContext == nil) {
            println("Managed Object Context initialization failed!")
            return []
        }
        
        let request = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("UserManagedInfo",             inManagedObjectContext: managedObjectContext!)
        request.entity = entityDescription
        
        let sortDescriptor = NSSortDescriptor(key: "name_last", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        if (target_userid != "any") {
            let predicate = NSPredicate(format: "userid == %@", target_userid)
            request.predicate = predicate
        }
        
        var results = managedObjectContext!.executeFetchRequest(request, error: nil)
        
        return results as [UserManagedInfo]

    }
    
    // return first user with target_userid
    func getUserInfo(target_userid: String) -> UserInfo? {
        // fetch user list with target_userid
        let userArray = fetchUserInfo(target_userid)
        if userArray.isEmpty {
            println("No user found")
            return nil
        }
        
        // for debugging
        var index: Int
        println("Found \(userArray.count) users")
        for index = 0; index < userArray.count; index++ {
            println("userid \(userArray[index].userid); username \(userArray[index].name_first)")
        }
        
        // return the first found user
        var target_user: UserInfo = UserInfo()
        let target = userArray[0] as UserManagedInfo
        
        target_user.username = target.username
        target_user.name_first = target.name_first
        target_user.name_last = target.name_last
        target_user.email = target.email
        target_user.password = target.password
        target_user.phone = target.phone
        target_user.userid = target.userid
        
        target_user.ifCSmode = target.ifCSmode.boolValue
        target_user.bpmthreshold = target.bpmthreshold.intValue
        target_user.length_sample = target.length_sample.intValue
        
        target_user.phone_emer = target.phone_emer
        target_user.msg_emer = target.msg_emer
        target_user.ifappendloc = target.ifappendloc.boolValue
        target_user.ifsendmsg = target.ifsendmsg.boolValue
        
        return target_user
    }
    
    // update user info
    func updateUserInfo(user: UserInfo) -> Bool {
        // fetch user list with target_userid
        let userArray = fetchUserInfo(user.userid)
        if userArray.isEmpty {
            println("No user found")
            return false
        }
        
        let target = userArray[0] as UserManagedInfo
        
        target.username = user.username
        target.name_first = user.name_first
        target.name_last = user.name_last
        target.email = user.email
        target.password = user.password
        target.phone = user.phone
        target.userid = user.userid
        
        target.ifCSmode = user.ifCSmode
        target.bpmthreshold = NSNumber(int: user.bpmthreshold)
        target.length_sample = NSNumber(int: user.length_sample)
        
        target.phone_emer = user.phone_emer
        target.msg_emer = user.msg_emer
        target.ifappendloc = user.ifappendloc
        target.ifsendmsg = user.ifsendmsg
        
        var error: NSError?
        
        managedObjectContext?.save(&error)
        
        if let err = error {
            println("\(err.localizedFailureReason)")
            return false
        }
        
        return true
    }
    
    // delete user with target_userid
    func deleteUserInfo(target_userid: String) -> Bool {
        
        if target_userid == "any" {
            return deleteAllUserInfo()
        }
        
        // fetch user list with target_userid
        let userArray = fetchUserInfo(target_userid)
        if userArray.isEmpty {
            println("No user found")
            return false
        }

        // delete users
        var index: Int
        println("Found \(userArray.count) users")
        for index = 0; index < userArray.count; index++ {
            println("delete user: id \(userArray[index].userid); username \(userArray[index].name_first)")
            managedObjectContext!.deleteObject(userArray[index] as NSManagedObject)
        }
        
        var error: NSError?
        managedObjectContext?.save(&error)
        if let err = error {
            println("\(err.localizedFailureReason)")
            return false
        }
        
        return true
    }
    
    // delete all users
    func deleteAllUserInfo() -> Bool {
        // fetch user list with target_userid
        let userArray = fetchUserInfo("any")

        // delete users
        var index: Int
        println("Found \(userArray.count) users")
        for index = 0; index < userArray.count; index++ {
            println("delete user: id \(userArray[index].userid); username \(userArray[index].name_first)")
            managedObjectContext!.deleteObject(userArray[index] as NSManagedObject)
        }
        
        var error: NSError?
        managedObjectContext?.save(&error)
        if let err = error {
            println("\(err.localizedFailureReason)")
            return false
        }
        
        return true
    }
    
    // check if the user has logged in
    class func hasLoggedIn() -> Bool {
        if currentUser != nil {
            return (currentUser!.userid != "0")
        } else {
            return false
        }
    }

}

