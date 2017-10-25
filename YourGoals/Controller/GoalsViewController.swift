//
//  ViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 22.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {

    // data properties
    var manager:GoalsStorageManager!
    var strategy:Goal?
    internal let presentStoryAnimationController = PresentStoryViewAnimationController()
    internal let dismissStoryAnimationController = DismissStoryViewAnimationController()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.manager = GoalsStorageManager.defaultStorageManager
        self.strategy = try! StrategyRetriever(manager: self.manager).activeStrategy()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        destinationViewController.transitioningDelegate = self
    }
}


