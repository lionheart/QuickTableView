//
//  ViewController.swift
//  QuickTableView
//
//  Created by Dan Loewenherz on 03/25/2016.
//  Copyright (c) 2016 Dan Loewenherz. All rights reserved.
//

import UIKit
import QuickTableView

struct ViewControllerContainer: QuickTableViewContainer {
    static var sections: [QuickTableViewSection] = [
        .Default([
            .RowWithHandler(.Subtitle("Base Table View", "Provides more customization"), { controller in
                controller.navigationController?.pushViewController(ViewController(), animated: true)
            }),
            .RowWithHandler(.Subtitle("Quick Table View", "Great for quick mockups"), { controller in
                controller.navigationController?.pushViewController(ViewController(), animated: true)
            })
        ])
    ]
    static var style: UITableViewStyle = .Plain
    static var shouldAutoResizeCells: Bool = false
}

final class ViewController: QuickTableViewController<ViewControllerContainer> {
    required init() {
        super.init()

        title = "Quick Table View"
    }
}

