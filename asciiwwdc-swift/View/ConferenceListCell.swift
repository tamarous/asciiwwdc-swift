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
        return label
    }()
    
    var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    var identifier: String?
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    var containerView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    func updateWithData(cellViewModel:ConferenceListCellViewModel) {
        self.viewModel = cellViewModel
        self.nameLabel.text = cellViewModel.conference?.name
        self.descLabel.text = cellViewModel.conference?.desc
        self.locationLabel.text = cellViewModel.conference?.location?.name
        self.identifier = cellViewModel.conference?.identifier
        self.timeLabel.text = cellViewModel.conference?.time

        self.nameLabel.sizeToFit()
        self.descLabel.sizeToFit()
        self.locationLabel.sizeToFit()
        self.timeLabel.sizeToFit()
    }
    
    func setupSubviews() {
        contentView.addSubview(containerView)
        
        containerView.addArrangedSubview(nameLabel)
        containerView.addArrangedSubview(descLabel)
        containerView.addArrangedSubview(locationLabel)
        containerView.addArrangedSubview(timeLabel)
        containerView.alignment = .leading
        containerView.axis = .vertical
        containerView.distribution = .equalSpacing
        
        containerView.backgroundColor = .white
        
        contentView.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalTo(self)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(12)
            make.top.equalTo(contentView).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
            make.right.equalTo(contentView).offset(-12)
        }
    }
}
