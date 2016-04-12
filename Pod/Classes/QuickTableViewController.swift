//
//  QuickTableView.swift
//
//  Created by Daniel Loewenherz on 3/26/16.
//  Copyright © 2016 Lionheart Software LLC. All rights reserved.
//

import UIKit
import KeyboardAdjuster

public enum QuickTableViewRow {
    public typealias C = UITableViewCell
    public typealias QuickTableViewHandler = UIViewController -> Void

    case Default(String?)
    case Subtitle(String?, String?)
    case Value1(String?, String?)
    case Value2(String?, String?)
    case Custom(QuickTableViewCellIdentifiable.Type, (C) -> C)

    indirect case RowWithSetup(QuickTableViewRow, (C) -> C)
    indirect case RowWithHandler(QuickTableViewRow, QuickTableViewHandler)
    indirect case RowWithHandler2(QuickTableViewRow, (UIViewController, CGPoint) -> Void)

    public func onSelection(handler: QuickTableViewHandler) -> QuickTableViewRow {
        if case .RowWithHandler(let row, _) = self {
            return .RowWithHandler(row, handler)
        }
        else {
            return .RowWithHandler(self, handler)
        }
    }

    public func dequeueReusableCellWithIdentifier(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> C {
        return prepareCell(tableView.dequeueReusableCellWithIdentifier(type.identifier, forIndexPath: indexPath))
    }

    public func prepareCell(cell: C) -> C {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail

        switch self {
        case .Custom(_, let callback):
            return callback(cell)

        case .RowWithHandler(let row, _):
            return row.prepareCell(cell)

        case .RowWithHandler2(let row, _):
            return row.prepareCell(cell)

        case .RowWithSetup(let row, let callback):
            return row.prepareCell(callback(cell))

        default:
            break
        }
        return cell
    }

    public var title: String? {
        switch self {
        case .Default(let title):
            return title

        case .Subtitle(let title, _):
            return title

        case .Value1(let title, _):
            return title

        case .Value2(let title, _):
            return title

        case .Custom:
            return nil

        case .RowWithSetup(let row, _):
            return nil

        case .RowWithHandler(let row, _):
            return row.title

        case .RowWithHandler2(let row, _):
            return row.title
        }
    }

    public var detail: String? {
        switch self {
        case .Default:
            return nil

        case .Subtitle(_, let detail):
            return detail

        case .Value1(_, let detail):
            return detail

        case .Value2(_, let detail):
            return detail

        case .Custom:
            return nil

        case .RowWithHandler(let row, _):
            return row.detail

        case .RowWithSetup(let row, _):
            return nil

        case .RowWithHandler2(let row, _):
            return row.detail
        }
    }

    public var type: QuickTableViewCellIdentifiable.Type {
        switch self {
        case .Default:
            return QuickTableViewCellDefault.self

        case .Subtitle:
            return QuickTableViewCellSubtitle.self

        case .Value1:
            return QuickTableViewCellValue1.self

        case .Value2:
            return QuickTableViewCellValue2.self

        case .Custom(let type, _):
            return type

        case .RowWithHandler(let row, _):
            return row.type

        case .RowWithSetup(let row, _):
            return row.type

        case .RowWithHandler2(let row, _):
            return row.type
        }
    }
}

public enum QuickTableViewSection: ArrayLiteralConvertible {
    public typealias Row = QuickTableViewRow
    public typealias Element = Row
    var count: Int { return rows.count }

    case Default([Row])
    case Title(String, [Row])

    public init(name theName: String, rows theRows: [Row]) {
        self = .Title(theName, theRows)
    }

    public init(_ rows: [Row]) {
        self = .Default(rows)
    }

    public init(arrayLiteral elements: Element...) {
        self = .Default(elements)
    }

    subscript(index: Int) -> Row {
        return rows[index]
    }

    var name: String? {
        if case .Title(let title, _) = self {
            return title
        }
        else {
            return nil
        }
    }

    var rows: [QuickTableViewRow] {
        switch self {
        case .Default(let rows):
            return rows

        case .Title(_, let rows):
            return rows
        }
    }

    var TableViewCellClasses: [QuickTableViewCellIdentifiable.Type] {
        return rows.map { $0.type }
    }
}

public class QuickTableViewController<Container: QuickTableViewContainer>: BaseTableViewController, UITableViewDataSource, UITableViewDelegate {
    required public init() {
        super.init(style: Container.style)

        if Container.shouldAutoResizeCells {
            tableView.estimatedRowHeight = 44
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        var registeredClassIdentifiers: Set<String> = Set()
        for section in Container.sections {
            for type in section.TableViewCellClasses {
                if !registeredClassIdentifiers.contains(type.identifier) {
                    tableView.registerClass(type)
                    registeredClassIdentifiers.insert(type.identifier)
                }
            }
        }
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Container.sections.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Container.sections[section].count
    }

    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Container.sections[section].name
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = Container.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(row.type.identifier, forIndexPath: indexPath)
        return row.prepareCell(cell)
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let section = Container.sections[indexPath.section]
        if case .RowWithHandler(_, let handler) = section[indexPath.row] {
            handler(self)
        }
        else if case .RowWithHandler2(_, let handler) = section[indexPath.row] {
            let rect = tableView.rectForRowAtIndexPath(indexPath)
            let newRect = view.convertRect(rect, toView: view)
            let maxX = CGRectGetMaxX(newRect)
            let midY = CGRectGetMidY(newRect)
            handler(self, CGPoint(x: maxX - 70, y: midY - tableView.contentOffset.y))
        }
    }

    public override func rightBarButtonItemDidTouchUpInside(sender: AnyObject?) {
        super.rightBarButtonItemDidTouchUpInside(sender)
    }

    public override func leftBarButtonItemDidTouchUpInside(sender: AnyObject?) {
        super.leftBarButtonItemDidTouchUpInside(sender)
    }
}