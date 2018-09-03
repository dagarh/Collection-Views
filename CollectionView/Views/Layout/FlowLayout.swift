//
//  FlowLayout.swift
//  CollectionView
//
//  Created by Himanshu Dagar on 15/08/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

/* Go to the documentation of UICollectionViewFlowLayout and read about properties and also see UICollectionViewDelegateFlowLayout protocol. */
class FlowLayout: UICollectionViewFlowLayout {
    
    /* This would get set in "addItem" method in MainNationalParksViewController. */
    var addedItem : IndexPath?
    var deletedItems : [IndexPath]?
    
    override func prepare() {
        super.prepare()
        /*
         We did this with the help of delegate method in "MainNationalParksViewController.swift". So no need to do this here. But you should know that you can handle cell positioning, size, spacing, and lot of other things using properties from super class directly and then set them here. OR other way is to use UICollectionViewDelegateFlowLayout protocol and then return properties values from those methods OR third way is to get access to the object of this "FlowLayout" class in MainNationalParksViewController and then set properties of items there, which we did in "viewDidLoad" method.
         
         So you should be aware about all these 3 ways of accessing properties of items. Layout object(it could be flow layout or custom layout) associated with collection view is responsible for all this. Collection View does not directly deal with the positioning, size....etc of cells/items.
         
         let width = collectionView!.frame.size.width / 3
         itemSize = CGSize(width:width, height:width)
         
         sectionHeadersPinToVisibleBounds = true
         */
        
    }
    
    /* Implement -layoutAttributesForElementsInRect: to return layout attributes for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion. Go to the documentation and read. */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var result = [UICollectionViewLayoutAttributes]()
        
        /* To get the default layout attribute info about elements in rectangle i.e inside collectionview. Elements could be section views or decorator views or cells. So we want to proceed only when there are default layout attributes for elements. */
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for item in attributes {
                /* Since .copy() returns Any, hence we need to downcast. We don't want to change attributes of the same object, hence creating copy. Even if you did not create copy then it would have been fine. */
                let cellAttribute = item.copy() as! UICollectionViewLayoutAttributes
                
                /* This "representedElementKind" would be nil for the cell. */
                if item.representedElementKind == nil {
                    let frame = cellAttribute.frame
                    cellAttribute.frame = frame.insetBy(dx: 2, dy: 2)
                }
                result.append(cellAttribute)
            }
        }
        
        return result
    }
    
    /* This method is used for the animation only. Read about this here: https://developer.apple.com/documentation/appkit/nscollectionviewlayout/1533598-initiallayoutattributesforappear
     
     This would be called just before the item get added in collectionView so that we can have some kind of animation.
     */
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        /* Here you are getting the item's default attributes or properties which would be added into collectionView. And by taking these default properties you are changing them so that item can be shown at some place at the starting of animation, but this would not change the actual properties of final appearing item. */
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath),
            let added = addedItem,
            added == itemIndexPath else {
                return nil
        }
        
        /* You can read about all layout attributes here at the end : https://developer.apple.com/documentation/uikit/uicollectionviewlayoutattributes/1617768-zindex */
        
        /* Set new attributes of an item/cell. Order of these don't matter because we are just setting few properties. And always remember that these are the properties of the item which would be shown at the starting of animation. These properties would not effect the properties of item which would be shown at the final position. */
        
        /* This is the location near to + button. */
        attributes.center = CGPoint(x: collectionView!.frame.width - 23.5, y: -24.5)
        
        /* Fully visible */
        attributes.alpha = 1
        
        /* This should be high because we want it to be above than anyone else so that we can see it. You can read about this here: https://developer.apple.com/documentation/uikit/uicollectionviewlayoutattributes/1617768-zindex */
        attributes.zIndex = 5
        
        /* we are applying the transformation over item. We are scaling down the item size in both x and y direction. */
        attributes.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
        
        return attributes
    }
    
    /* You can read about this here: https://developer.apple.com/documentation/appkit/nscollectionviewlayout/1533317-finallayoutattributesfordisappea */
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath),
            let deleted = deletedItems,
            deleted.contains(itemIndexPath) else {
                return nil
        }
        
        attributes.alpha = 1
        attributes.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        attributes.zIndex = -1
        
        return attributes
    }
}
