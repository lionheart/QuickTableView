//
//  UITableView.swift
//  Pods
//
//  Created by Daniel Loewenherz on 4/12/16.
//
//

public extension UITableView {
    func registerClass(cellClass: QuickTableViewCellIdentifiable.Type) {
        let identifier = cellClass.identifier

        if let cellClass = cellClass as? AnyClass {
            registerClass(cellClass, forCellReuseIdentifier: identifier)
        }
    }

    func dequeueReusableCellWithIndexPath<T where T: QuickTableViewCellIdentifiable>(indexPath: NSIndexPath) -> T? {
        return dequeueReusableCellWithIdentifier(T.identifier, forIndexPath: indexPath) as? T
    }
}