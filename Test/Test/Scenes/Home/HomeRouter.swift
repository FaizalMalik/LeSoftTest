//
//  HomeRouter.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import Foundation
import UIKit

class HomeRouter:Router{
    
    unowned var viewModel:HomeViewModel
    
    init(viewModel : HomeViewModel) {
        self.viewModel = viewModel
        
    }
    
    func route(to routeID: String, from context: UIViewController, parameters: [String : Any]?) {
        
        DispatchQueue.main.async {
            switch routeID {
                    case HomeVC.Routes.userDetail.rawValue:
                        
                     //Passing the model
                        if let user = parameters?["user"] as? User{
                            let userDetailVC = UserDetailVC.instantiate()
                            userDetailVC.user = user
                            context.navigationController?.pushViewController(userDetailVC, animated: true)

                        }else{
                            print("No parametes found ")
                        }
                            
                        
                        break
                  
                //Write other Routers
                     
                    default:
                       break
                    
        }
        
     
    }
    
    }
}
