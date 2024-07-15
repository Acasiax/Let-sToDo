//
//  MainFolderListCell.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/16/24.
//

import UIKit

class MainFolderListCell: UICollectionViewCell, IdentifiableCell {
    static let identifier = "MainFolderListCell"
    
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        
        titleLabel.textAlignment = .center
        countLabel.textAlignment = .center
        
        contentView.backgroundColor = UIColor(red: 1.00, green: 0.76, blue: 0.82, alpha: 1.00)
        contentView.layer.cornerRadius = 10
    }
    
    func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, countLabel])
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(title: String, count: String) {
        titleLabel.text = title
        countLabel.text = count
        countLabel.textColor = .white
        countLabel.font = .systemFont(ofSize: 25, weight: .heavy)
    }
}
