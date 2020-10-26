//
//  EpisodeCell.swift
//
//  Created by Nimish Sharma on 07/03/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    //    MARK: IBOutlets
    @IBOutlet weak var titleIV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    //    MARK: View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUIComponents()
    }

    override func layoutSubviews() {
        titleIV.layer.cornerRadius = 8
    }
    
    private func setupUIComponents() {
        titleIV.clipsToBounds = true
        titleIV.contentMode = .scaleAspectFill
    }
    
    func populateData(_ model: Photo) {
        titleLbl.text = model.title
        titleIV.image = #imageLiteral(resourceName: "PlaceHolder")
    }
}
