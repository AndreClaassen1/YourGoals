//
//  ViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 22.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        configure(collectionView: collectionView)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
