//
//  WorkloadView.swift
//  YourGoals
//
//  Created by André Claaßen on 08.01.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit

class WorkloadView: UIView {
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var tasksLeftLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let xibView = Bundle.main.loadNibNamed("WorkloadView", owner: self, options: nil)!.first as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    func configure(manager: GoalsStorageManager, forDate date: Date) throws {
        let workloadCalculator = TodayWorkloadCalculator(manager: manager)
        let info = try workloadCalculator.calcWorkload(forDate: date)
        totalTimeLabel.text = info.totalRemainingTime.formattedAsString()
        tasksLeftLabel.text = "\(info.totalTasksLeft)"
        endTimeLabel.text  = info.endTime.formattedTime()
    }
}
