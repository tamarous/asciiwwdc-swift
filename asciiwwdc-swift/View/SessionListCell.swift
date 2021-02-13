//
//  SessionListCell.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/13.
//

import Foundation
import UIKit

class SessionListCell: UICollectionViewCell {
    
    var session:Session?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    func updateWithData(session:Session) {
        self.session = session
        self.nameLabel.text = session.name
        self.nameLabel.sizeToFit()
    }
    
    func setupSubviews() {
        contentView.addSubview(nameLabel)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(12)
            make.right.bottom.equalTo(contentView).offset(-12)
        }
    }
}
