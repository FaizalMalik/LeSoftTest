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
    let reachability = try! Reachability()
    
    init(service:HomeServiceProtocol = HomeService.shared) {
    
        self.service = service
    }
    
    
    //MARK: Api Calls
    /**Api call to get all  Users list  */
    func fetchUsersList(){

        guard reachability.connection != .unavailable else {
            //When no internet connection fetch saved users list
            self.getSavedUsersList()
            return
            
        }
        
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
                
                //This method is to update the saved users list
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
        DispatchQueue.main.async {
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
                person.setValue(user.username, forKeyPath: "username")
                person.setValue(user.phone, forKeyPath: "phone")

                let entityAddress = NSEntityDescription.entity(forEntityName: "AddressDB", in: managedContext)!
                let personAddress = NSManagedObject(entity: entityAddress, insertInto: managedContext)
                personAddress.setValue(user.address.city, forKeyPath: "city")
                personAddress.setValue(user.address.suite, forKeyPath: "suite")
                personAddress.setValue(user.address.zipcode, forKeyPath: "zipcode")
                personAddress.setValue(user.address.street, forKeyPath: "street")
                person.setValue(personAddress, forKeyPath: "address")

                let entityCompany = NSEntityDescription.entity(forEntityName: "CompanyDB", in: managedContext)!
                let personCompany = NSManagedObject(entity: entityCompany, insertInto: managedContext)
                personCompany.setValue(user.company.name, forKeyPath: "name")
                personCompany.setValue(user.company.bs, forKeyPath: "bs")
                personCompany.setValue(user.company.catchPhrase, forKeyPath: "catchPhrase")
                person.setValue(personCompany, forKeyPath: "company")


                do {
                  try managedContext.save()

                } catch let error as NSError {
                  print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
        
        
      
    }
    
       func getSavedUsersList(){
        DispatchQueue.main.async {

        let managedContext = AppDelegate.shared.persistentContainer.viewContext
          
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDB")

          do {
            let usersListSaved = try managedContext.fetch(fetchRequest)
            var usersList = [User]()
            for userDB in usersListSaved{
                
                let userObj = User(fromJson: [:])
                userObj.name =  userDB.value(forKeyPath: "name") as? String
                userObj.email =  userDB.value(forKeyPath: "email") as? String
                userObj.username =  userDB.value(forKeyPath: "username") as? String
                userObj.phone =  userDB.value(forKeyPath: "phone") as? String

                let addressObj = Addres(fromJson: [:])

                let address =  userDB.value(forKeyPath: "address") as? NSManagedObject
                addressObj.city =  address?.value(forKeyPath: "city") as? String
                addressObj.suite =  address?.value(forKeyPath: "suite") as? String
                addressObj.street =  address?.value(forKeyPath: "street") as? String
                addressObj.zipcode =  address?.value(forKeyPath: "zipcode") as? String

                userObj.address = addressObj
                
                let companyObj = Company(fromJson: [:])

                let company =  userDB.value(forKeyPath: "company") as? NSManagedObject
                companyObj.name =  company?.value(forKeyPath: "name") as? String
                companyObj.bs =  company?.value(forKeyPath: "bs") as? String
                companyObj.catchPhrase =  company?.value(forKeyPath: "catchPhrase") as? String

                userObj.company = companyObj

                usersList.append(userObj)
            }
            self.usersdatasourceModels.value = usersList
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            self.usersdatasourceModels.value = []
          }
        }
    }
    func userExists(id: Int) -> Bool {
        //This method is to remove the duplicate saving from the array
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
