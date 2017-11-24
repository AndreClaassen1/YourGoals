//
//  GoalMiniCell.swift
//  
//
//  Created by André Claaßen on 03.11.17.
//

import UIKit
import CoreMotion

class GoalMiniCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressIndicatorView: ProgressIndicatorView!
    @IBOutlet weak var motivationImage: UIImageView!
    /// Shadow View
    private weak var shadowView: UIView?
    private let kInnerMargin: CGFloat = 20.0
    /// Core Motion Manager
    private let motionManager = CMMotionManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        motivationImage.layer.cornerRadius = 5.0
        motivationImage.clipsToBounds = true
    }

    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> GoalMiniCell {
        guard let cell: GoalMiniCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue GetStartedListCell ***")
        }
        return cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }
    
    // MARK: - Shadow
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: kInnerMargin,
                                              y: kInnerMargin,
                                              width: bounds.width - (2 * kInnerMargin),
                                              height: bounds.height - (2 * kInnerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        // Roll/Pitch Dynamic Shadow
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
                if let motion = motion {
                    let pitch = motion.attitude.pitch * 10 // x-axis
                    let roll = motion.attitude.roll * 10 // y-axis
                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
                }
            })
        }
    }
    
    internal func shadowColorAndOpacity() -> (color:UIColor, opacicty:Float) {
        return (UIColor.black, 0.35)
    }
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let colorAndOpacity = shadowColorAndOpacity()
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
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
    ///   - goalIsActive: true, if this goal is active
    func show(goal: Goal, forDate date: Date, goalIsActive:Bool, manager: GoalsStorageManager) throws {
        guard let data = goal.imageData?.data else {
            fatalError ("could not extract data: \(String(describing: goal.imageData))")
        }
        
        guard let image = UIImage(data: data) else {
            fatalError ("could not create Image from data: \(data)")
        }
        
        titleLabel.text = goal.name
        titleLabel.tintColor = UIColor.white
        motivationImage.image = image
        titleLabel.sizeToFit()
        progressIndicatorView.viewMode = .mini
        try progressIndicatorView.setProgress(forGoal: goal, forDate: date, manager: manager)
    }
}
