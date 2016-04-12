//
//  ExampleBaseTableViewController.swift
//  QuickTableView
//
//  Created by Daniel Loewenherz on 4/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import QuickTableView

enum SettingsSection: Int {
    case Main
    case Accounts
    case Support

    var title: String? {
        switch self {
        case .Main:
            return "Main"

        case .Accounts:
            return "Accounts"

        case .Support:
            return nil
        }
    }

    static var count: Int { return Support.rawValue }
}

final class SettingsViewController: BaseTableViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: -

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SettingsSection.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: QuickTableViewCellDefault = tableView.dequeueReusableCellWithIndexPath(indexPath)!
        return cell
    }
}
