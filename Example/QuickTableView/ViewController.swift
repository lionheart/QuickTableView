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
    static var sections: [QuickTableViewSectionBuilder] = [
        .default([
            .rowWithHandler(.subtitle("Base Table View", "Provides more customization"), { controller in
                controller.navigationController?.pushViewController(HouseViewController(), animated: true)
            }),
            .rowWithHandler(.subtitle("Quick Table View", "Great for quick mockups"), { controller in
                controller.navigationController?.pushViewController(QuickHouseViewController(), animated: true)
            })
        ])
    ]
    static var style: UITableView.Style = .plain
    static var shouldAutoResizeCells: Bool = false
}

final class ViewController: QuickTableViewController<ViewControllerContainer> {
    required init() {
        super.init()

        title = "Quick Table View"
    }
}

