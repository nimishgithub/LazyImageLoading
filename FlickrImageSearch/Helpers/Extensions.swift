//
//  Extensions.swift
//
//  Created by Nimish Sharma on 23/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

//MARK: UICollectionView Extension
extension UICollectionView {
    ///Register Collection View Cell Nib
    func registerCell(with identifier: UICollectionViewCell.Type)  {
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil), forCellWithReuseIdentifier: "\(identifier.self)")
    }
    
    ///Dequeue Collection View Cell
    func dequeueCell <T: UICollectionViewCell> (with identifier: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: "\(identifier.self)", for: indexPath) as! T
    }
}

//MARK: NSError Extension
extension NSError {
    public convenience init(_ description: String) {
        self.init(domain: "FlickrSearch",
                  code: 0,
                  userInfo: [NSLocalizedFailureReasonErrorKey: description])
    }
}
