//
//  General.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import Foundation
import UIKit

protocol Router {
   func route(
      to routeID: String,
      from context: UIViewController,
      parameters: [String:Any]?
   )
}
enum ResultResponse<T, E: Error> {
    case success(T)
    case failure(E)
}

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}


typealias completionHanlder = ((Bool)->Void)
typealias errorHanlder = ((String)->Void)
