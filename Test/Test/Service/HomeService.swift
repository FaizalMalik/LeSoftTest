//
//  HomeService.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol HomeServiceProtocol : class {
    //Api call for fetching users list
   func getUsersList(withParams params: [String : Any], onCompletion: @escaping ((ResultResponse<[User], Error>) -> Void))
  
}

class HomeService:HomeServiceProtocol {
   
    static let shared = HomeService()

    func getUsersList(withParams params: [String : Any], onCompletion: @escaping ((ResultResponse<[User], Error>) -> Void)) {
        
         let url  = Api().baseURL + ApiCalls.getUserList
        ApiManager().request(method: .get, urlString:url, parameters: [:], headers: nil) { (result) in

                    switch result {

                    case .failure(let error):

                        onCompletion(.failure(error))

                    case .success(let data):
                     
                          let json = JSON(data)
                        let response = json.map{  User(fromJson: $0.1) }
                          onCompletion(.success(response))
                    }
                }
       }
    
}

