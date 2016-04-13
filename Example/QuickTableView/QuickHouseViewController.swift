//
//  QuickHouseViewController.swift
//  QuickTableView
//
//  Created by Daniel Loewenherz on 4/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import QuickTableView

struct HouseContainer: QuickTableViewContainer {
    static var sections: [QuickTableViewSection] = [
        .Title("Bedroom", [
            .Default("Bed"),
            .Default("Side Table"),
            .Default("Dresser"),
        ]),
        .Title("Living Room", [
            .Default("Rug"),
            .Default("Couch"),
            .Default("Coffee Table"),
        ]),
        .Title("Kitchen", [
            .Default("Island"),
            .Default("Coffee Machine"),
            .Default("Sink"),
        ]),
    ]
    static var style: UITableViewStyle = .Plain
    static var shouldAutoResizeCells: Bool = true
}

final class QuickHouseViewController: QuickTableViewController<HouseContainer> {
    required init() {
        super.init()

        title = "Quick Table"
    }
}