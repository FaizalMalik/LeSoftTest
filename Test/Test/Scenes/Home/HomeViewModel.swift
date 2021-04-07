//
//  HomeViewModel.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import Foundation



protocol HomeViewModelDelegate {
    
}

class HomeViewModel: HomeViewModelDelegate{
    //MARK: Properties
    var usersdatasourceModels = DynamicValue.init([User]())
    var service :HomeServiceProtocol
    var showLoadingStatus = DynamicValue<(Bool,String)>.init((false,"Loading"))
  
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
                //here we are sorting the all userslist
                
                self.usersdatasourceModels.value =  respose

                break
                
            case .failure( _):
            
                        self.showLoadingStatus.value = (false,"Something went wrong")
                break
            }
        }
        
    }
    
    
       
    
}
