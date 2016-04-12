//
//  BaseTableView.swift
//  Pods
//
//  Created by Daniel Loewenherz on 4/12/16.
//
//

import KeyboardAdjuster

public class BaseTableViewController: UIViewController, KeyboardAdjuster {
    /**
     A base table view with built-in support for keyboard display and same initialization defaults.

     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: April 12, 2016
     */
    public var keyboardAdjusterConstraint: NSLayoutConstraint?
    public var keyboardAdjusterAnimated: Bool? = false
    public var tableView: UITableView!

    public init(style: UITableViewStyle = .Grouped) {
        super.init(nibName: nil, bundle: nil)

        edgesForExtendedLayout = .None

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

    // MARK: -
    public func leftBarButtonItemDidTouchUpInside(sender: AnyObject?) {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    public func rightBarButtonItemDidTouchUpInside(sender: AnyObject?) {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}