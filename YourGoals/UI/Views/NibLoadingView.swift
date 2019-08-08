//
//  NibLoadingView.swift
//  YourGoals
//
//  Created by André Claaßen on 30.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

// Usage: Subclass your UIView from NibLoadView to automatically load a xib with the same name as your class

@IBDesignable


/// this base class makes Custom Controlls based on XIB files work.
/// to make you happy, do the following things
///
/// 1. Create a XIB-File
/// 2. Create a swift UIView class file with the same name as the xib
/// 3. The class file should be dependend of NibLoadingFiew
/// 4. in the xib the files owner placeholder (only) should set
///    to the swift class
/// 5. Now you can make other outlets for your controls
class NibLoadingView: UIView {
    
    @IBOutlet weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
        awakeFromNib()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
}
