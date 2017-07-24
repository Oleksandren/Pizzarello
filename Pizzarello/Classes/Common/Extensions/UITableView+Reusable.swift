//
//  UITableView+Reusable.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import UIKit

protocol Reusable: class
{
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable
{
    static var reuseIdentifier: String { return String(describing: Self.self) }
    static var nib: UINib? { return nil }
}

extension UITableView
{
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable
    {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable
    {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
