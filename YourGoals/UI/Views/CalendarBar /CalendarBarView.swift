//
//  CalendarBarView.swift
//  YourGoals
//
//  Created by André Claaßen on 25.07.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import UIKit

/// calendar bar view 
class CalendarBarView: NibLoadingView, UICollectionViewDelegate, UICollectionViewDataSource{
    

    @IBOutlet weak var dayOfWeekTextView: UILabel!

    @IBOutlet weak var weekDaysView: UICollectionView!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupControl()
    }
    
    func setupControl() {
        weekDaysView.delegate = self
        weekDaysView.dataSource = self
        weekDaysView.register(CalendarBarCell.self, forCellWithReuseIdentifier: CalendarBarCell.reuseIdentifier)
    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 360
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let calendarBarCell = CalendarBarCell.dequeue(fromCollectionView: self.weekDaysView, atIndexPath: indexPath)
//        let goal = self.goalForIndexPath(path: indexPath)
//        try goalCell.show(goal: goal, forDate: date, goalIsActive: goal.isActive(forDate: date), backburnedGoals: goal.backburnedGoals, manager: self.manager)
        return calendarBarCell
    }
    
}
