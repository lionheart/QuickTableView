//
//  ExampleBaseTableViewController.swift
//  QuickTableView
//
//  Created by Daniel Loewenherz on 4/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import QuickTableView

enum HouseSection: Int {
    case Bedroom
    case LivingRoom
    case Kitchen

    var title: String? {
        switch self {
        case .Bedroom:
            return "Bedroom"

        case .LivingRoom:
            return "Living Room"

        case .Kitchen:
            return "Kitchen"
        }
    }

    var count: Int {
        switch self {
        case .Bedroom:
            return HouseBedroomRow.count

        case .Kitchen:
            return HouseKitchenRow.count

        case .LivingRoom:
            return HouseLivingRoomRow.count
        }
    }

    static var count: Int { return Kitchen.rawValue + 1 }
}

enum HouseBedroomRow: Int {
    case Bed
    case SideTable
    case Dresser

    var text: String? {
        switch self {
        case .Bed:
            return "Bed"

        case .SideTable:
            return "Side Table"

        case .Dresser:
            return "Dresser"
        }
    }

    static var count: Int { return Dresser.rawValue + 1 }
}

enum HouseLivingRoomRow: Int {
    case Rug
    case Couch
    case CoffeeTable

    var text: String? {
        switch self {
        case .Rug:
            return "Rug"

        case .Couch:
            return "Couch"

        case .CoffeeTable:
            return "Coffee Table"
        }
    }

    static var count: Int { return CoffeeTable.rawValue + 1 }
}

enum HouseKitchenRow: Int {
    case Island
    case CoffeeMachine
    case Sink

    var text: String? {
        switch self {
        case .Island:
            return "Island"

        case .CoffeeMachine:
            return "Coffee Machine"

        case .Sink:
            return "Sink"
        }
    }

    static var count: Int { return Sink.rawValue + 1 }
}

final class HouseViewController: BaseTableViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Base Table"
        tableView.registerClass(QuickTableViewCellDefault.self)
    }

    // MARK: -

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return HouseSection(rawValue: section)!.title
    }

    func numberOfSections(in: UITableView) -> Int {
        return HouseSection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HouseSection(rawValue: section)!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = HouseSection(rawValue: indexPath.section)!
        let cell: QuickTableViewCellDefault = tableView.dequeueReusableCellWithIndexPath(indexPath)!

        switch section {
        case .Bedroom:
            let row = HouseBedroomRow(rawValue: indexPath.row)!
            cell.textLabel?.text = row.text

        case .LivingRoom:
            let row = HouseLivingRoomRow(rawValue: indexPath.row)!
            cell.textLabel?.text = row.text

        case .Kitchen:
            let row = HouseKitchenRow(rawValue: indexPath.row)!
            cell.textLabel?.text = row.text
        }

        return cell
    }
}
