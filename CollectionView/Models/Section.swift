//
//  Section.swift
//  CollectionView
//
//  Created by Himanshu Dagar on 14/08/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation

class Section {
    
    var sectionTitle : String
    var sectionCount : Int
    var sectionImageName : String
    
    init(sectionTitle: String, sectionCount: Int, sectionImageName: String) {
        self.sectionTitle = sectionTitle
        self.sectionCount = sectionCount
        self.sectionImageName = sectionImageName
    }
    
}


