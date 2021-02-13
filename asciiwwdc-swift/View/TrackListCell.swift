//
//  TrackListCell.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/13.
//

import Foundation
import UIKit
import IGListKit
import SnapKit

class TrackListCell: UICollectionViewCell {
    var track:Track!
    
    var nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateWithData(track: Track) {
        self.track = track
        self.nameLabel.text = track.name
        self.nameLabel.sizeToFit()
    }
    
    func setupSubviews() {
        contentView.addSubview(nameLabel)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
