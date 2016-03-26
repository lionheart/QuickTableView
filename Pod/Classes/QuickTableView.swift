//
//  QuickTableView.swift
//
//  Created by Daniel Loewenherz on 3/26/16.
//  Copyright © 2016 Lionheart Software LLC. All rights reserved.
//

import UIKit
import KeyboardAdjuster
import LionheartTableViewCells

public enum QuickTableViewRow {
    public typealias QuickTableViewHandler = UIViewController -> Void

    case Default(String?)
    case Subtitle(String?, String?)
    case Value1(String?, String?)
    case Value2(String?, String?)
    case Custom(LionheartTableViewCell.Type, (UITableViewCell) -> UITableViewCell)

    indirect case RowWithHandler(QuickTableViewRow, QuickTableViewHandler)

    public func onSelection(handler: QuickTableViewHandler) -> QuickTableViewRow {
        if case .RowWithHandler(let row, _) = self {
            return .RowWithHandler(row, handler)
        }
        else {
            return .RowWithHandler(self, handler)
        }
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

        case .RowWithHandler(let row, _):
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
        }
    }

    public var type: LionheartTableViewCell.Type {
        switch self {
        case .Default, .Custom:
            return TableViewCellDefault.self

        case .Subtitle:
            return TableViewCellSubtitle.self

        case .Value1:
            return TableViewCellValue1.self

        case .Value2:
            return TableViewCellValue2.self

        case .RowWithHandler(let row, _):
            return row.type
        }
    }
}

public struct QuickTableViewSection: ArrayLiteralConvertible {
    public typealias Element = QuickTableViewRow
    var name: String?
    var rows: [QuickTableViewRow]

    var count: Int { return rows.count }

    public init(name theName: String, rows theRows: [QuickTableViewRow]) {
        name = theName
        rows = theRows
    }

    public init(_ rows: [QuickTableViewRow]) {
        self.rows = rows
    }

    public init(arrayLiteral elements: Element...) {
        rows = elements
    }

    subscript(index: Int) -> QuickTableViewRow {
        return rows[index]
    }

    var TableViewCellClasses: [LionheartTableViewCell.Type] {
        return rows.map { $0.type }
    }
}

public protocol QuickTableViewContainer {
    static var sections: [QuickTableViewSection] { get }
    static var style: UITableViewStyle { get }
}

public class BaseTableViewController: UIViewController, KeyboardAdjuster {
    public var keyboardAdjusterConstraint: NSLayoutConstraint?
    public var keyboardAdjusterAnimated: Bool? = false
    public var tableView: UITableView!

    public init(style: UITableViewStyle = .Grouped) {
        super.init(nibName: nil, bundle: nil)

        tableView = UITableView(frame: CGRect.zero, style: style)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activateKeyboardAdjuster()
    }

    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deactivateKeyboardAdjuster()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        tableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        tableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        tableView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        keyboardAdjusterConstraint = view.bottomAnchor.constraintEqualToAnchor(tableView.bottomAnchor)
    }
}

public class QuickTableViewController<Container: QuickTableViewContainer>: BaseTableViewController, UITableViewDataSource, UITableViewDelegate {
    required public init() {
        super.init(style: Container.style)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        var registeredClassIdentifiers: Set<String> = Set()
        for section in Container.sections {
            for type in section.TableViewCellClasses {
                if !registeredClassIdentifiers.contains(type.identifier) {
                    tableView.registerClass(type as! UITableViewCell.Type, forCellReuseIdentifier: type.identifier)
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

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = Container.sections[indexPath.section]
        let row = section[indexPath.row]
        switch row {
        case .Custom(let CellType, let callback):
            let cell = tableView.dequeueReusableCellWithIdentifier(CellType.identifier, forIndexPath: indexPath)
            return callback(cell)

        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(row.type.identifier, forIndexPath: indexPath)
            cell.textLabel?.text = row.title
            cell.detailTextLabel?.text = row.detail
            return cell
        }
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = Container.sections[indexPath.section]
        if case .RowWithHandler(_, let handler) = section[indexPath.row] {
            handler(self)
        }
    }
}