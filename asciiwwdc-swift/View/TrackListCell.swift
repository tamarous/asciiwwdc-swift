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
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
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
        containerView.addSubview(nameLabel)
        contentView.addSubview(containerView)
    
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(8)
            make.right.bottom.equalTo(contentView).offset(-8)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(containerView).offset(12)
            make.right.bottom.equalTo(containerView).offset(-12)
            make.centerX.equalTo(containerView)
            make.centerY.equalTo(containerView)
        }
    }
}
