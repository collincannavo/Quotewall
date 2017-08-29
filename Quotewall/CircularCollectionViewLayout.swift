//
//  CircularCollectionViewLayout.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/28/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class CircularCollectionViewLayout: UICollectionViewLayout {
    
    let itemSize = CGSize(width: 133, height: 173)
    
    var radius: CGFloat = 500 {
        didSet{
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }

   override var collectionViewContentSize: CGSize {
    
     guard let collectionView = collectionView else { return CGSize() }
    
    return CGSize(width: CGFloat(collectionView.numberOfItems(inSection: 0)) * itemSize.width, height: collectionView.bounds.height)
}
    override class var layoutAttributesClass: AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }

    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let centerX = collectionView.contentOffset.x + (collectionView.bounds.width/2.0)
        let anchorPointY = ((itemSize.height/2.0) + radius)/itemSize.height
        
        
    }
    
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()
    
}



