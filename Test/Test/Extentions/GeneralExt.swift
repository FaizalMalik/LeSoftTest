//
//  NSErrorExt.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import Foundation
import UIKit

extension NSError {

    convenience init(domain: String? = nil, status: HTTPStatus, message: String? = nil) {
        let domain = domain ?? Bundle.main.bundleIdentifier ?? ""
        let userInfo: [String: String] = [NSLocalizedDescriptionKey: message ?? status.description]
        self.init(domain: domain, code: status.code, userInfo: userInfo)
    }

    convenience init(domain: String? = nil, code: Int = -999, message: String) {
        let domain = domain ?? Bundle.main.bundleIdentifier ?? ""
        let userInfo: [String: String] = [NSLocalizedDescriptionKey: message]
        self.init(domain: domain, code: code, userInfo: userInfo)
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}




//MARK: Class Name Extension
public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
     static var className: String {
        return String(describing: self)
    }

     var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

//MARK: UITableView Extension

public extension UITableView {
     func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

     func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

     func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}
