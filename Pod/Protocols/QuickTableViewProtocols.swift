//
//  QuickTableViewContainer.swift
//  Pods
//
//  Created by Daniel Loewenherz on 4/12/16.
//
//

public protocol QuickTableViewCellIdentifiable {
    static var identifier: String { get }
}

public protocol QuickTableViewContainer {
    static var sections: [QuickTableViewSection] { get }
    static var style: UITableViewStyle { get }
    static var shouldAutoResizeCells: Bool { get }
}