//
//  ConferenceListCell.swift
//  asciiwwdc-swift
//
//  Created by 汪泽伟 on 2021/2/4.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit

class ConferenceListCell: UICollectionViewCell {
    var viewModel:ConferenceListCellViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    var identifier: String?
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    var containerView:UIView = {
        let view = UIView()
        
        return view
    }()
    
    func updateWithData(cellViewModel:ConferenceListCellViewModel) {
        self.viewModel = cellViewModel
        self.nameLabel.text = cellViewModel.conference?.name
        self.descLabel.text = cellViewModel.conference?.desc
        self.identifier = cellViewModel.conference?.identifier
        
        self.nameLabel.sizeToFit()
        self.descLabel.sizeToFit()
    }
    
    func setupSubviews() {
        contentView.addSubview(containerView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descLabel)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        containerView.addSubview(stackView)
        containerView.layer.cornerRadius = 12.0
        containerView.backgroundColor = .white

        contentView.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalTo(self)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(8)
            make.left.equalTo(self.contentView).offset(8)
            make.bottom.equalTo(self.contentView).offset(-8)
            make.right.equalTo(self.contentView).offset(-8)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(8)
            make.top.equalTo(containerView).offset(8)
            make.bottom.equalTo(containerView).offset(-8)
            make.right.equalTo(containerView).offset(-8)
        }
    }
}
