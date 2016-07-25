//
//  Copyright 2016 Lionheart Software LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

import KeyboardAdjuster
import UIKit

public class BaseTableViewController: UIViewController, KeyboardAdjuster, HasTableView {
    /**
     A base table view with built-in support for keyboard display and same initialization defaults.

     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: April 12, 2016
     */
    public var keyboardAdjusterConstraint: NSLayoutConstraint?
    public var tableViewTopConstraint: NSLayoutConstraint!
    public var tableViewLeftConstraint: NSLayoutConstraint!
    public var tableViewRightConstraint: NSLayoutConstraint!

    public var keyboardAdjusterAnimated: Bool? = false
    public var tableView: UITableView!

    public init(style: UITableViewStyle = .Grouped) {
        super.init(nibName: nil, bundle: nil)

        edgesForExtendedLayout = .None
        definesPresentationContext = true

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

        tableViewLeftConstraint = tableView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        tableViewRightConstraint = tableView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        tableViewTopConstraint = tableView.topAnchor.constraintEqualToAnchor(view.topAnchor)

        tableViewLeftConstraint.active = true
        tableViewTopConstraint.active = true
        tableViewRightConstraint.active = true
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