//
//  GoalsViewController+CollectionView.swift
//  YourGoals
//
//  Created by André Claaßen on 23.10.17.
//  Copyright © 2017 André Claaßen. All rights reserved.
//

import Foundation
import UIKit

extension GoalsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
        
    }
    
    
}
