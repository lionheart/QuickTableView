//
//  ExampleBaseTableViewController.swift
//  QuickTableView
//
//  Created by Daniel Loewenherz on 4/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import QuickTableView

enum HouseSection: Int, QuickTableViewSection {
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
}

enum HouseBedroomRow: Int, QuickTableViewRow {
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
}

enum HouseLivingRoomRow: Int, QuickTableViewRow {
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
}

enum HouseKitchenRow: Int, QuickTableViewRow {
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
}

final class HouseViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Base Table"
        tableView.registerClass(QuickTableViewCellDefault.self)
    }
}

// MARK: - UITableViewDelegate
extension HouseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HouseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return HouseSection(at: section).title
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return HouseSection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HouseSection(at: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuickTableViewCellDefault = tableView.dequeueReusableCell(for: indexPath)

        switch HouseSection(at: indexPath) {
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
