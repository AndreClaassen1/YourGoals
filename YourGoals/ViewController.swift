//
//  ViewController.swift
//  YourGoals
//
//  Created by André Claaßen on 22.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationBar.topItem?.title = "Hello"
//        self.navigationItem.largeTitleDisplayMode = .always
//        UINavigationBar.appearance().largeTitleTextAttributes = [
//            NSAttributedStringKey.foregroundColor: UIColor.black
//        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

