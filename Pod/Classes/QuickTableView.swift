//
//  QuickTableView.swift
//
//  Created by Daniel Loewenherz on 3/26/16.
//  Copyright © 2016 Lionheart Software LLC. All rights reserved.
//

import UIKit
import KeyboardAdjuster
import LionheartTableViewCells

public enum QuickTableViewRow<T: UIContentContainer> {
    public typealias QuickTableViewHandler = T -> Void

    case Default(String?, QuickTableViewHandler?)
    case Subtitle(String?, String?, QuickTableViewHandler?)
    case Value1(String?, String?, QuickTableViewHandler?)
    case Value2(String?, String?, QuickTableViewHandler?)
    case Custom(LionheartTableViewCell.Type, (UITableViewCell) -> UITableViewCell, QuickTableViewHandler?)

    indirect case RowWithHandler(QuickTableViewRow<T>, QuickTableViewHandler)

    public func with(handler: QuickTableViewHandler) -> QuickTableViewRow<T> {
        if case .RowWithHandler(let row, _) = self {
            return .RowWithHandler(row, handler)
        }
        else {
            return .RowWithHandler(self, handler)
        }
    }
}

public enum QuickTableViewSection<T: UIContentContainer> {
    case Default(String?, [QuickTableViewRow<T>])

    var count: Int {
        switch self {
        case .Default(_, let rows):
            return rows.count
        }
    }

    var rows: [QuickTableViewRow<T>] {
        if case .Default(_, let rows) = self {
            return rows
        }
        else {
            return []
        }
    }

    subscript(index: Int) -> QuickTableViewRow<T>? {
        if case .Default(_, let rows) = self {
            return rows[index]
        }
        else {
            return nil
        }
    }

    var TableViewCellClasses: [LionheartTableViewCell.Type] {
        var types: [LionheartTableViewCell.Type] = []
        for row in rows {
            switch row {
            case .Default, .Custom:
                types.append(TableViewCellDefault.self)

            case .Subtitle:
                types.append(TableViewCellSubtitle.self)

            case .Value1:
                types.append(TableViewCellValue1.self)

            case .Value2:
                types.append(TableViewCellValue2.self)
            }
        }
        return types
    }
}

public protocol QuickTableViewContainer {
    associatedtype T: UIContentContainer
    static var sections: [QuickTableViewSection<T>] { get }
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

public class QuickTableViewController<SectionType: QuickTableViewContainer>: BaseTableViewController, UITableViewDataSource, UITableViewDelegate {
    required public init() {
        super.init(style: SectionType.style)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        var registeredClassIdentifiers: Set<String> = Set()
        for section in SectionType.sections {
            for type in section.TableViewCellClasses {
                if !registeredClassIdentifiers.contains(type.identifier) {
                    tableView.registerClass(type as! UITableViewCell.Type, forCellReuseIdentifier: type.identifier)
                    registeredClassIdentifiers.insert(type.identifier)
                }
            }
        }
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SectionType.sections.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SectionType.sections[section].count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = SectionType.sections[indexPath.section]
        if let row = section[indexPath.row] {
            switch row {
            case .Default(let title, _):
                let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellDefault.identifier, forIndexPath: indexPath)
                cell.textLabel?.text = title
                return cell

            case .Subtitle(let title, let detail, _):
                let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellSubtitle.identifier, forIndexPath: indexPath)
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = detail
                return cell

            case .Value1(let title, let detail, _):
                let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellValue1.identifier, forIndexPath: indexPath)
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = detail
                return cell

            case .Value2(let title, let detail, _):
                let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellValue2.identifier, forIndexPath: indexPath)
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = detail
                return cell

            case .Custom(let CellType, let callback, _):
                let cell = tableView.dequeueReusableCellWithIdentifier(CellType.identifier, forIndexPath: indexPath)
                return callback(cell)
            }
        }
        else {
            return tableView.dequeueReusableCellWithIdentifier(TableViewCellDefault.identifier, forIndexPath: indexPath)
        }
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = SectionType.sections[indexPath.section]
        if let row = section[indexPath.row] {
            switch row {
            case .Default(_, let handler?):
                handler(self as! SectionType.T)

            case .Subtitle(_, _, let handler?):
                handler(self as! SectionType.T)

            case .Value1(_, _, let handler?):
                handler(self as! SectionType.T)
                
            case .Value2(_, _, let handler?):
                handler(self as! SectionType.T)
                
            case .Custom(_, _, let handler?):
                handler(self as! SectionType.T)
                
            default:
                break
            }
        }
    }
}