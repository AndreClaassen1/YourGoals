//
//  GoalMiniCell.swift
//  
//
//  Created by André Claaßen on 03.11.17.
//

import UIKit

class GoalMiniCell: NibLoadingView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressIndicatorView: ProgressIndicatorView!
    @IBOutlet weak var motivationImage: UIImageView!
    /// Shadow View
    private weak var shadowView: UIView?
    private let innerMargin: CGFloat = 8.0
    private let cornerRadius: CGFloat = 4.0
    private var goalIsActive = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        motivationImage.layer.cornerRadius = cornerRadius
        motivationImage.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    // MARK: - Shadow
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: innerMargin,
                                              y: innerMargin,
                                              width: bounds.width - (2 * innerMargin),
                                              height: bounds.height - (2 * innerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        applyShadow(width: innerMargin / 2.0, height: innerMargin / 2.0)
    }
    
    internal func shadowColorAndOpacity() -> (color:UIColor, opacicty:Float) {
        return self.goalIsActive ?
            (UIColor(red: 0.0, green: 0.3, blue: 0.0, alpha: 1.0), 0.5) :
            (UIColor.black, 0.35)
    }
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let colorAndOpacity = shadowColorAndOpacity()
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cornerRadius)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = cornerRadius
            shadowView.layer.shadowColor = colorAndOpacity.color.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = colorAndOpacity.opacicty
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
    // MARK: - Content
    
    /// show a small goal cell
    ///
    /// - Parameters:
    ///   - goal: show this goal
    ///   - date: show the progress of the goal for the given date
    ///   - goalIsActive: true, if this goal is active
    ///   - backburned: true, if this goal is backburned
    ///   - manager: a sorage manager we need to show the progress indicator
    /// - Throws: core data exception
    func show(goal: Goal, forDate date: Date, goalIsActive:Bool, backburned: Bool, manager: GoalsStorageManager) throws {
        guard let data = goal.imageData?.data else {
            fatalError ("could not extract data: \(String(describing: goal.imageData))")
        }
        
        guard let image = UIImage(data: data) else {
            fatalError ("could not create Image from data: \(data)")
        }
        
        if backburned {
            motivationImage.image = image.convertToGrayScale()
        } else {
            motivationImage.image = image
        }
        
        titleLabel.text = goal.name
        titleLabel.tintColor = UIColor.white
        titleLabel.sizeToFit()
        progressIndicatorView.viewMode = .mini
        self.goalIsActive = goalIsActive
        try progressIndicatorView.setProgress(forGoal: goal, forDate: date, withBackburned: backburned, manager: manager)
    }
}

// MARK: - TransitionAnimationSourceMetrics

extension GoalMiniCell: TransitionAnimationSourceMetrics {
    /// retrieve the metrics of the selected image relative to the given controller view
    ///
    /// - Parameter view: controller view
    /// - Returns: the transition animation metrics
    func animationMetrics(relativeTo controllerView: UIView) -> TransitionAnimationMetrics {
        let frame = self.motivationImage.convert(self.motivationImage.frame, to: controllerView)
        let metrics = TransitionAnimationMetrics(selectedFrame: frame, cornerRadius: self.cornerRadius)
        return metrics
    }
}

