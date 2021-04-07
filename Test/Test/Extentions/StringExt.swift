//
//  String.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import Foundation

enum Process {
    case encode
    case decode
}

extension String {
    var isNumber: Bool {
           return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
       }
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func base64(_ method: Process) -> String? {
        switch method {
        case .encode:
            guard let data = data(using: .utf8) else { return nil }
            return data.base64EncodedString()
        case .decode:
            guard let data = Data(base64Encoded: self) else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
 
        var floatValue: Float {
            return (self as NSString).floatValue
        }
    
}

extension String {

    /// Initializes an NSURL object with a provided URL string. (read-only)
    var url: URL? {
        return URL(string: self)
    }

    /// The host, conforming to RFC 1808. (read-only)
    var host: String {
        if let url = url, let host = url.host {
            return host
        }
        return ""
    }
    
    func localise() -> String{
        
        return NSLocalizedString(self, comment: "")
    }
   
   
}
