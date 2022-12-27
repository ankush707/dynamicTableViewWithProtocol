//
//  DBManager.swift
//  DemoProject
//
//  Created by Ankush Sharma on 27/03/22.
//

import Foundation
import UIKit
import CoreData


public enum UserKeys : String {
    case login = "login"
    case id = "id"
    case node_id = "node_id"
    case avatar_url = "avatar_url"
    case gravatar_id = "gravatar_id"
    case url = "url"
    case html_url = "html_url"
    case followers_url = "followers_url"
    case following_url = "following_url"
    case gists_url = "gists_url"
    case starred_url = "starred_url"
    case subscriptions_url = "subscriptions_url"
    case organizations_url = "organizations_url"
    case repos_url = "repos_url"
    case events_url = "events_url"
    case received_events_url = "received_events_url"
    case type = "type"
    case site_admin = "site_admin"
    case notes = "notes"
}



enum CoreDataEntity : String {
    case Users = "Users"
}

typealias UsersCompletionBlock = ([UserCore]?) -> ()

open class DBManager : NSObject  {
    public let coreDataStackObj = CoreDataStack()
    
    public var coreDataStack : CoreDataStack{
        get{
            return coreDataStackObj
        }
    }
    
    static var sharedUserManager = DBManager()
    
    
    func getUsersFromDatabase(result : @escaping UsersCompletionBlock){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Users.rawValue)
        
        coreDataStack.managedObjectContext.perform {
            
            do {
                weak var weakSelf = self
                guard let results = try weakSelf?.coreDataStack.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject], let cartArray = weakSelf?.convertManagedObjectArrayToUserArray(arrManagedObject: results) else { return }
                
                result(cartArray)
            }catch let error {
                UtilityFunctions.printToConsole(message: error)
            }
        }
    }
    
    func isExist(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Users.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id = %d", argumentArray: [id])
        
        let res = try! coreDataStack.managedObjectContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    func convertManagedObjectArrayToUserArray(arrManagedObject : [NSManagedObject]) -> [UserCore]{
        
        var arrUsers : [UserCore] = []
        for mc in arrManagedObject {
            let user = UserCore()
            user.login = mc.value(forKey: UserKeys.login.rawValue) as? String
            user.id = mc.value(forKey: UserKeys.id.rawValue) as? Int
            user.node_id = mc.value(forKey: UserKeys.node_id.rawValue) as? String
            user.avatar_url = mc.value(forKey: UserKeys.avatar_url.rawValue) as? String
            user.gravatar_id = mc.value(forKey: UserKeys.gravatar_id.rawValue) as? String
            user.url = mc.value(forKey: UserKeys.url.rawValue) as? String
            user.html_url = mc.value(forKey: UserKeys.html_url.rawValue) as? String
            user.followers_url = mc.value(forKey: UserKeys.followers_url.rawValue) as? String
            user.following_url = mc.value(forKey: UserKeys.following_url.rawValue) as? String
            user.gists_url = mc.value(forKey: UserKeys.gists_url.rawValue) as? String
            user.starred_url = mc.value(forKey: UserKeys.starred_url.rawValue) as? String
            user.subscriptions_url = mc.value(forKey: UserKeys.subscriptions_url.rawValue) as? String
            user.organizations_url = mc.value(forKey: UserKeys.organizations_url.rawValue) as? String
            user.repos_url = mc.value(forKey: UserKeys.repos_url.rawValue) as? String
            user.events_url = mc.value(forKey: UserKeys.events_url.rawValue) as? String
            user.received_events_url = mc.value(forKey: UserKeys.received_events_url.rawValue) as? String
            user.type = mc.value(forKey: UserKeys.type.rawValue) as? String
            user.site_admin = mc.value(forKey: UserKeys.site_admin.rawValue) as? Bool
            user._notes = mc.value(forKey: UserKeys.notes.rawValue) as? String
            arrUsers.append(user)
            
        }
        
        return arrUsers
    }
    
    
    func saveUsersToCoreData(users : [UserCore]?) {
        
        guard let arrusers = users else { return }
        
        for user in arrusers {
            if !self.isExist(id: user.id!) {
                self.saveUserToDB(entityName: CoreDataEntity.Users.rawValue, user: user)
            }
            
        }
    }
    
    func saveUserToDB(entityName : String,user : UserCore?){
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: (coreDataStack.managedObjectContext)),let tempMessage = user else {
            fatalError("Could not find entity descriptions!")
        }
        
        coreDataStack.managedObjectContext.mergePolicy = NSErrorMergePolicy
        let currentMessage = NSManagedObject(entity: entity, insertInto: coreDataStack.managedObjectContext)
        currentMessage.setValue(tempMessage.login, forKey: UserKeys.login.rawValue)
        currentMessage.setValue(tempMessage.id, forKey: UserKeys.id.rawValue)
        currentMessage.setValue(tempMessage.node_id, forKey: UserKeys.node_id.rawValue)
        currentMessage.setValue(tempMessage.avatar_url, forKey: UserKeys.avatar_url.rawValue)
        currentMessage.setValue(tempMessage.gravatar_id, forKey: UserKeys.gravatar_id.rawValue)
        
        currentMessage.setValue(tempMessage.url, forKey: UserKeys.url.rawValue)
        currentMessage.setValue(tempMessage.html_url, forKey: UserKeys.html_url.rawValue)
        currentMessage.setValue(tempMessage.followers_url, forKey: UserKeys.followers_url.rawValue)
        currentMessage.setValue(tempMessage.following_url, forKey: UserKeys.following_url.rawValue)
        currentMessage.setValue(tempMessage.gists_url, forKey: UserKeys.gists_url.rawValue)
        currentMessage.setValue(tempMessage.starred_url, forKey: UserKeys.starred_url.rawValue)
        currentMessage.setValue(tempMessage.subscriptions_url, forKey: UserKeys.subscriptions_url.rawValue)
        currentMessage.setValue(tempMessage.organizations_url, forKey: UserKeys.organizations_url.rawValue)
        currentMessage.setValue(tempMessage.repos_url, forKey: UserKeys.repos_url.rawValue)
        currentMessage.setValue(tempMessage.events_url, forKey: UserKeys.events_url.rawValue)
        currentMessage.setValue(tempMessage.received_events_url, forKey: UserKeys.received_events_url.rawValue)
        currentMessage.setValue(tempMessage.type, forKey: UserKeys.type.rawValue)
        currentMessage.setValue(tempMessage.site_admin, forKey: UserKeys.site_admin.rawValue)
        currentMessage.setValue(tempMessage.notes, forKey: UserKeys.notes.rawValue)
        
        coreDataStack.saveMainContext()
    }
    
    func cleanCart() {
        
        let dbNames = [CoreDataEntity.Users.rawValue]
        dbNames.forEach { (dBName) in
            self.removeDataFromTable(tableName: dBName)
        }
    }
    
    func removeDataFromTable(tableName : String) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            self.coreDataStack.saveMainContext()
            
        } catch let error as NSError {
            UtilityFunctions.printToConsole(message: "delete failed-- \(error)")
        }
    }
    
    func updateAddons(user : UserCore? ,id: Int?,notes: String?) {
        
        let managedContext = coreDataStack.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Users.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id = %d", argumentArray: [id])
        
        do {
            let results =
            try managedContext.fetch(fetchRequest)
            let objectUpdate = results[0] as! NSManagedObject
            
            guard let currentProduct = user else {
                return
            }
            
            objectUpdate.setValue(currentProduct.login, forKey: UserKeys.login.rawValue)
            objectUpdate.setValue(currentProduct.id, forKey: UserKeys.id.rawValue)
            objectUpdate.setValue(currentProduct.node_id, forKey: UserKeys.node_id.rawValue)
            objectUpdate.setValue(currentProduct.avatar_url, forKey: UserKeys.avatar_url.rawValue)
            objectUpdate.setValue(currentProduct.gravatar_id, forKey: UserKeys.gravatar_id.rawValue)
            
            objectUpdate.setValue(currentProduct.url, forKey: UserKeys.url.rawValue)
            objectUpdate.setValue(currentProduct.html_url, forKey: UserKeys.html_url.rawValue)
            objectUpdate.setValue(currentProduct.followers_url, forKey: UserKeys.followers_url.rawValue)
            objectUpdate.setValue(currentProduct.following_url, forKey: UserKeys.following_url.rawValue)
            objectUpdate.setValue(currentProduct.gists_url, forKey: UserKeys.gists_url.rawValue)
            objectUpdate.setValue(currentProduct.starred_url, forKey: UserKeys.starred_url.rawValue)
            objectUpdate.setValue(currentProduct.subscriptions_url, forKey: UserKeys.subscriptions_url.rawValue)
            objectUpdate.setValue(currentProduct.organizations_url, forKey: UserKeys.organizations_url.rawValue)
            objectUpdate.setValue(currentProduct.repos_url, forKey: UserKeys.repos_url.rawValue)
            objectUpdate.setValue(currentProduct.events_url, forKey: UserKeys.events_url.rawValue)
            objectUpdate.setValue(currentProduct.received_events_url, forKey: UserKeys.received_events_url.rawValue)
            objectUpdate.setValue(currentProduct.type, forKey: UserKeys.type.rawValue)
            objectUpdate.setValue(currentProduct.site_admin, forKey: UserKeys.site_admin.rawValue)
            objectUpdate.setValue(notes, forKey: UserKeys.notes.rawValue)
            
            do {
                self.coreDataStack.saveMainContext()
                
                UtilityFunctions.printToConsole(message: "updated")
                UtilityFunctions.showAlert(message: "Notes updated successfully")
            }catch let error as NSError {
                print(error.localizedFailureReason ?? "")
            }
        }
        catch let error as NSError {
            print(error.localizedFailureReason ?? "")
        }
        
    }
}



