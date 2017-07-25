//
//  UITableView+Reusable.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//
// This code is inspired by Olivier Halligon's article and fixed for Swift 3.
// See http://alisoftware.github.io/swift/generics/2016/01/06/generic-tableviewcells/ for original article
// and https://github.com/AliSoftware/Reusable for code examples and CocoaPod/Carthage modules.



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
            register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        }
        else {
            register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable
    {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable
    {
        if let nib = T.nib {
            register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
        else {
            register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: Reusable
    {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
}
