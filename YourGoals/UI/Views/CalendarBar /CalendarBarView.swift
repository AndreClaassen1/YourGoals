//
//  CalendarBarView.swift
//  YourGoals
//
//  Created by André Claaßen on 25.07.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import UIKit

protocol CalendarBarViewDelegate {
    func activeDayChanged(newDate: Date)
}

/// calendar bar view
class CalendarBarView: NibLoadingView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var dayOfWeekTextView: UILabel!
    @IBOutlet weak var weekDaysView: UICollectionView!
    
    let spacingBetweenViewCells:CGFloat = 0.0
    var delegate:CalendarBarViewDelegate!
    var referenceDate = Date().day()
    var numberOfDays = 360
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupControl()
    }
    
    func setupControl() {
        weekDaysView.register(CalendarBarCell.self, forCellWithReuseIdentifier: CalendarBarCell.reuseIdentifier)
        weekDaysView.delegate = self
        weekDaysView.dataSource = self
        weekDaysView.allowsSelection = true
        weekDaysView.isPagingEnabled = true
        weekDaysView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        weekDaysView.reloadData()
    }
    
    /// configure this view from the containing view controller
    ///
    /// - Parameters:
    ///   - delegate: a delegate for events of this view
    ///   - activeDate: the initial date
    func configure(delegate: CalendarBarViewDelegate, activeDate: Date) {
        self.delegate = delegate
        selectCalendarCell(forDate: activeDate)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDays
    }
    
    /// calc a date from a reference and the row in the index path
    func calcDateForPath(referenceDate: Date, path: IndexPath) -> Date {
        let startOfWeek = referenceDate.startOfWeek
        let date = startOfWeek.addDaysToDate(path.row)
        return date
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let calendarBarCell = CalendarBarCell.dequeue(fromCollectionView: self.weekDaysView, atIndexPath: indexPath)
        let date = calcDateForPath(referenceDate: self.referenceDate, path: indexPath)
        let progress = 0.75
        
        let value = CalendarBarCellValue(date: date, progress: progress)
            
        calendarBarCell.configure(value: value)
        return calendarBarCell
    }
    
    /// calculate the indexpath in the range between 0 and self.number of days
    ///
    /// - Parameter date: the date
    /// - Returns: a indexpath for the date
    func calcIndexPath(forDate date:Date) -> IndexPath? {
        let days = min(0, max(date.numberOfDays(since: self.referenceDate), numberOfDays))
        return IndexPath(row: days, section: 0)
    }
    
    func selectCalendarCell(forDate date:Date) {
        let indexPath = calcIndexPath(forDate: date)
        weekDaysView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
    }
    
    
    // Mark: UICollectionViewDelegateFlowLayout
    
    
    /// calculate the size of a cell in the flow layout so that 7 cells for seven days are horizontally arranged
    ///
    /// - Parameters:
    ///   - collectionView: the collecton view
    ///   - collectionViewLayout: the layout
    ///   - indexPath: the item (ignored)
    /// - Returns: a reasonayble size for a calendar view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 7.0 - 1.0
        let size = CGSize(width: width, height: 45.0)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}
