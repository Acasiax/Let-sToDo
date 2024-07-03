//
//  ListCell.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/3/24.
//

import UIKit
import SnapKit

class ListCell: UICollectionViewCell, IdentifiableCell {
    
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
        // StackView 생성
        let stackView = UIStackView(arrangedSubviews: [titleLabel, countLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
       
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }

    
    func configure(title: String, count: String) {
        titleLabel.text = title
      //  titleLabel.textColor = .gray
        countLabel.text = count
        countLabel.textColor = .white
        countLabel.font = .systemFont(ofSize: 20, weight: .heavy)
    }
}
