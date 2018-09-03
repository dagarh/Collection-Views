//
//  CollectionViewSectionHeader.swift
//  CollectionView
//
//  Created by Himanshu Dagar on 14/08/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

class CollectionViewSectionHeader: UICollectionReusableView {
    
    @IBOutlet weak var sectionImageView: UIImageView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionCountLabel: UILabel!
    
    var sectionInfo : Section? {
        didSet {
            if let section = sectionInfo {
                sectionImageView.image = UIImage(named: section.sectionImageName)
                sectionTitleLabel.text = section.sectionTitle
                sectionCountLabel.text = String(section.sectionCount)
            }
        }
    }
}
