//
//  QuickHouseViewController.swift
//  QuickTableView
//
//  Created by Daniel Loewenherz on 4/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import QuickTableView

struct HouseContainer: QuickTableViewContainer {
    static var sections: [QuickTableViewSectionBuilder] = [
        .title("Bedroom", [
            .default("Bed"),
            .default("Side Table"),
            .default("Dresser"),
        ]),
        .title("Living Room", [
            .default("Rug"),
            .default("Couch"),
            .default("Coffee Table"),
        ]),
        .title("Kitchen", [
            .default("Island"),
            .default("Coffee Machine"),
            .default("Sink"),
        ]),
    ]
    static var style: UITableView.Style = .plain
    static var shouldAutoResizeCells: Bool = true
}

final class QuickHouseViewController: QuickTableViewController<HouseContainer> {
    required init() {
        super.init()

        title = "Quick Table"
    }
}
