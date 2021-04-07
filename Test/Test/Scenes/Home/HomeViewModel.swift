//
//  HomeViewModel.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import Foundation
import CoreData


protocol HomeViewModelDelegate {
    
}

class HomeViewModel: HomeViewModelDelegate{
    //MARK: Properties
    var usersdatasourceModels = DynamicValue.init([User]())
    var service :HomeServiceProtocol
    var showLoadingStatus = DynamicValue<(Bool,String)>.init((false,"Loading.."))
  
    init(service:HomeServiceProtocol = HomeService.shared) {
    
        self.service = service
    }
    
    
    //MARK: Api Calls
    /**Api call to get all  Users list  */
    func fetchUsersList(){

        showLoadingStatus.value = (true,"Loading..")
        service.getUsersList(withParams: [:]) { (result) in
            
            switch result {
            case .success(let respose):
                self.showLoadingStatus.value = (false,"")
                
                guard  respose.count > 0 else {
                    
                        self.showLoadingStatus.value = (false,"No items found")

             
                    return
                }
                //here we are getting the all userslist
                self.usersdatasourceModels.value =  respose
                self.saveUsers(users: respose)
                

                break
                
            case .failure( _):
            
                        self.showLoadingStatus.value = (false,"Something went wrong")
                break
            }
        }
        
    }
    
    
   /*? Core Data Methods */
    func saveUsers(users: [User]) {

        for user in users {
            
            guard !self.userExists(id: user.id) else {
                return
            }
            
            let managedContext = AppDelegate.shared.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "UserDB", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
              person.setValue(user.name, forKeyPath: "name")
              person.setValue(user.email, forKeyPath: "email")
              person.setValue(user.id, forKeyPath: "id")
              person.setValue(user.website, forKeyPath: "website")
            let entityAddress = NSEntityDescription.entity(forEntityName: "AddressDB", in: managedContext)!
            let personAddress = NSManagedObject(entity: entityAddress, insertInto: managedContext)
            personAddress.setValue(user.address.city, forKeyPath: "city")
            personAddress.setValue(user.address.suite, forKeyPath: "suite")
            personAddress.setValue(user.address.zipcode, forKeyPath: "zipcode")
            personAddress.setValue(user.address.street, forKeyPath: "street")
            person.setValue(personAddress, forKeyPath: "address")



            do {
              try managedContext.save()

            } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
      
    }
    
       func getSavedUsersList(){
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
          
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDB")

          do {
            let usersListSaved = try managedContext.fetch(fetchRequest)
            var usersList = [User]()
            for userDB in usersListSaved{
                
                let userObj = User(fromJson: [:])
                userObj.name =  userDB.value(forKeyPath: "name") as? String
                userObj.email =  userDB.value(forKeyPath: "email") as? String
                usersList.append(userObj)
            }
            self.usersdatasourceModels.value = usersList
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
    }
    func userExists(id: Int) -> Bool {
        let managedObjectContext = AppDelegate.shared.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDB")
            fetchRequest.predicate = NSPredicate(format: "id = %d", id)

            var results: [NSManagedObject] = []

            do {
                results = try managedObjectContext.fetch(fetchRequest)
            }
            catch {
                print("error executing fetch request: \(error)")
            }

            return results.count > 0
    }
    
}
