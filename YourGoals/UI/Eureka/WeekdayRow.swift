//
//  WeekdayRow.swift
//  YourGoals
//
//  Created by André Claaßen on 31.12.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import Eureka

public enum WeekDay {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

public class WeekDayCell : Cell<Set<WeekDay>>, CellType {
    
    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    
    open override func setup() {
        height = { 60 }
        row.title = nil
        super.setup()
        selectionStyle = .none
        for subview in contentView.subviews {
            if let button = subview as? UIButton {
                button.setImage(UIImage(named: "checkedDay"), for: .selected)
                button.setImage(UIImage(named: "uncheckedDay"), for: .normal)
                button.adjustsImageWhenHighlighted = false
                imageTopTitleBottom(button)
            }
        }
    }
    
    open override func update() {
        row.title = nil
        super.update()
        let value = row.value
        mondayButton.isSelected = value?.contains(.monday) ?? false
        tuesdayButton.isSelected = value?.contains(.tuesday) ?? false
        wednesdayButton.isSelected = value?.contains(.wednesday) ?? false
        thursdayButton.isSelected = value?.contains(.thursday) ?? false
        fridayButton.isSelected = value?.contains(.friday) ?? false
        saturdayButton.isSelected = value?.contains(.saturday) ?? false
        sundayButton.isSelected = value?.contains(.sunday) ?? false
        
        mondayButton.alpha = row.isDisabled ? 0.6 : 1.0
        tuesdayButton.alpha = mondayButton.alpha
        wednesdayButton.alpha = mondayButton.alpha
        thursdayButton.alpha = mondayButton.alpha
        fridayButton.alpha = mondayButton.alpha
        saturdayButton.alpha = mondayButton.alpha
        sundayButton.alpha = mondayButton.alpha
    }
    
    @IBAction func dayTapped(_ sender: UIButton) {
        dayTapped(sender, day: getDayFromButton(sender))
    }
    
    private func getDayFromButton(_ button: UIButton) -> WeekDay{
        switch button{
        case sundayButton:
            return .sunday
        case mondayButton:
            return .monday
        case tuesdayButton:
            return .tuesday
        case wednesdayButton:
            return .wednesday
        case thursdayButton:
            return .thursday
        case fridayButton:
            return .friday
        default:
            return .saturday
        }
    }
    
    private func dayTapped(_ button: UIButton, day: WeekDay){
        button.isSelected = !button.isSelected
        if button.isSelected{
            row.value?.insert(day)
        }
        else{
            _ = row.value?.remove(day)
        }
    }
    
    private func imageTopTitleBottom(_ button : UIButton){
        
        guard let imageSize = button.imageView?.image?.size else { return }
        let spacing : CGFloat = 3.0
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        guard let titleLabel = button.titleLabel, let title = titleLabel.text else { return }
        let titleSize = title.size(withAttributes: [NSAttributedStringKey.font: titleLabel.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
    }
}

//MARK: WeekDayRow

public final class WeekDayRow: Row<WeekDayCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<WeekDayCell>(nibName: "WeekDaysCell")
    }
}
