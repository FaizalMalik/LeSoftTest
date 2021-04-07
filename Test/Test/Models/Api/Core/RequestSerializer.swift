//
//  RequestSerializer.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import Alamofire
import Foundation

extension ApiManager {
    @discardableResult
    func request(method: HTTPMethod,
                 urlString: URLStringConvertible,
                 parameters: [String: Any]? = nil,
                 headers: [String: String]? = nil,
                 completion: Completion?) -> Request? {
        guard Network.shared.isReachable else {
            completion?(.failure(Api.Error.network))
            return nil
        }

        let encoding: ParameterEncoding
        if method == .post {
            encoding = JSONEncoding.default
        } else {
            encoding = URLEncoding.default
        }

        let newHeaders =  headers

        let request = Alamofire.request(urlString.urlString,
                                        method: method,
                                        parameters: parameters,
                                        encoding: encoding,
                                        headers: newHeaders
        ).responseJSON(completion: { (response) in
            completion?(response.result)
        })

        return request
    }
}
