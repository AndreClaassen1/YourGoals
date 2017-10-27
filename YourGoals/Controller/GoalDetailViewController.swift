//
//  GoalDetailViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 24.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

/// show a goal and all of its tasks in detail
class GoalDetailViewController: UITableViewController {

    @IBOutlet weak var tasksTableView: UITableView!
    /// Container
    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerBottomConstraint: NSLayoutConstraint!
    
    /// Header Image Height
    @IBOutlet private weak var headerImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var progressIndicatorView: ProgressIndicatorView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    var goal:Goal!
    let manager = GoalsStorageManager.defaultStorageManager 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configure(goal: goal)
        configure(tableView: tasksTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    internal func positionContainer(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        containerLeadingConstraint.constant = left
        containerTrailingConstraint.constant = right
        containerTopConstraint.constant = top
        containerBottomConstraint.constant = bottom
        view.layoutIfNeeded()
    }
    
    internal func setHeaderHeight(_ height: CGFloat) {
        headerImageHeightConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    internal func configureRoundedCorners(shouldRound: Bool) {
        headerImageView.layer.cornerRadius = shouldRound ? 14.0 : 0.0
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
