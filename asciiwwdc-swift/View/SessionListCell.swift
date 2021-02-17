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
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    func updateWithData(session:Session) {
        self.session = session
        self.nameLabel.text = "\(session.index!) - \(session.name!)"
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
