//
//  CalendarBarCell.swift
//  YourGoals
//
//  Created by André Claaßen on 26.07.19.
//  Copyright © 2019 André Claaßen. All rights reserved.
//

import UIKit
import Foundation

struct CalendarBarCellValue {
    let date:Date
    let progress:CGFloat
    
    init(date: Date, progress: Double) {
        self.date = date
        assert(progress >= 0.0 && progress <= 1.0)
        self.progress = CGFloat(progress)
    }
}

/// a cell representing a day in week for a date
class CalendarBarCell: UICollectionViewCell {

    let dayNumberLabel = UILabel()
    let dayNameLabel = UILabel()
    let dayProgressRing = CircleProgressView(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupControls()
    }
    
    fileprivate func createControls() {
        self.addSubview(dayProgressRing)
        self.dayProgressRing.addSubview(dayNumberLabel)
        self.addSubview(dayNameLabel)
    }
    
    fileprivate func formatLabel(label: UILabel, textAlignment: NSTextAlignment, fontSize: CGFloat) {
        label.textAlignment = textAlignment
        label.font = label.font.withSize(fontSize)
    }
    
    fileprivate func createConstraints() {
        let views: [String: Any] = [
            "dayNumberLabel": dayNumberLabel,
            "dayProgressRing": dayProgressRing,
            "dayNameLabel": dayNameLabel
        ]
        
        // disable autoresizing in all views
        views.values.forEach { ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false }
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[dayProgressRing]-2-[dayNameLabel(10)]-2-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[dayProgressRing]-2-|", options: [ .alignAllCenterX ], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[dayNumberLabel]-0-|", options: [ .alignAllCenterY ], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[dayNumberLabel]-0-|", options: [], metrics: nil, views: views)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[dayNameLabel]-2-|", options: [.alignAllCenterX], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func setupControls() {
        createControls()
        formatLabel(label: dayNameLabel, textAlignment: .center, fontSize: 12.0)
        formatLabel(label: dayNumberLabel, textAlignment: .center, fontSize: 14.0)
        createConstraints()
    }
    
    /// configure the view with a date
    ///
    /// - Parameter date: the date
    func configure(value: CalendarBarCellValue) {
        dayNumberLabel.text = String(value.date.dayNumberOfMonth)
        dayNameLabel.text = value.date.weekdayChar
        dayProgressRing.progress = value.progress
    }
    
    // MARK: - Factory Method
    
    /// get a resuable cell from the collection view.
    ///
    /// - Preconditions
    ///     You must register the cell first
    ///
    /// - Parameters:
    ///   - collectionView: a ui collecition view
    ///   - indexPath: the index path
    /// - Returns: a calendar bar cell
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> CalendarBarCell {
        guard let cell: CalendarBarCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue CalendarBarCell ***")
        }
        return cell
    }
    
    override var isSelected: Bool {
        didSet {
            self.dayNumberLabel.textColor = self.isSelected ? UIColor.blue : UIColor.black
        }
    }
    
}
