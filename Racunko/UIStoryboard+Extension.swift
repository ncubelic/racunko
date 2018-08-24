//
//  UIStoryboard+Extension.swift
//  RoomOrders
//
//  Created by Nikola on 21/08/2018.
//  Copyright © 2018 Filip Dujmusic. All rights reserved.
//
import UIKit

extension UIStoryboard {
    
    public func instantiate<T: UIViewController>(_ type: T.Type, withIdentifier identifier: String? = nil) -> T {
        let id = identifier ?? String(describing: type.self)
        guard let vc = self.instantiateViewController(withIdentifier: id) as? T else {
            fatalError("Could not instantiate view controller \(T.self)") }
        return vc
    }
}
