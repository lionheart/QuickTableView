//
//  LionheartTableViewCells.swift
//  Pods
//
//  Created by Daniel Loewenherz on 3/1/16.
//
//

public protocol UITableViewCellIdentifiable {
    static var identifier: String { get }
}

public protocol LionheartTableViewCell {
    static var identifier: String { get }
}

public extension UITableView {
    func registerClass(cellClass: UITableViewCellIdentifiable.Type) {
        let identifier = cellClass.identifier

        if let cellClass = cellClass as? AnyClass {
            registerClass(cellClass, forCellReuseIdentifier: identifier)
        }
    }

    func dequeueReusableCellWithIndexPath<T where T: UITableViewCellIdentifiable>(indexPath: NSIndexPath) -> T? {
        return dequeueReusableCellWithIdentifier(T.identifier, forIndexPath: indexPath) as? T
    }
}