//
//  CommitDateFormController.swift
//  YourGoals
//
//  Created by André Claaßen on 23.11.18.
//  Copyright © 2018 André Claaßen. All rights reserved.
//

import UIKit
import Eureka

protocol CommitDateFormControllerDelegate {
    func saveCommitDate(commitDate: Date?)
}

class CommitDateFormController: FormViewController {
    
    var delegate:CommitDateFormControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            Section("Select your explicit commit date")
            <<< DateRow("commitDateRow") {
                $0.value = Date();
                $0.title = "Commit Date"
            }
            <<< ButtonRow() {
                $0.title = "Save"
                }.onCellSelection({ _ , _ in
                    self.saveCommitDate()
                })
            <<< ButtonRow() {
                $0.title = "Cancel"
                }.onCellSelection({ _, _ in
                    self.delegate?.saveCommitDate(commitDate: nil)
                    self.dismiss(animated: true)
                })
    }
    
    func saveCommitDate() {
        let date = self.form.values()["commitDateRow"] as? Date
        self.delegate?.saveCommitDate(commitDate: date)
        self.dismiss(animated: true)
    }
}
