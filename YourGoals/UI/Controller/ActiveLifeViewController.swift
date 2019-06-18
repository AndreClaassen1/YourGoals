//
//  ActiveLifeViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 17.06.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import UIKit

class ActiveLifeViewController: UIViewController {

    @IBOutlet weak var todayTableView: ActionableTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Active Life"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
