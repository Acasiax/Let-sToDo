//
//  TodoListTableViewCell.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import SnapKit

class TodoListTableViewCell: UITableViewCell, IdentifiableCell {
    let titleLB = UILabel()
    let contentLB = UILabel()
    let dateLB = UILabel()
    let tagLB = UILabel()
    let checkCircle = UIButton()
    var taskId: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [titleLB, contentLB, dateLB, tagLB, checkCircle].forEach { contentView.addSubview($0) }

        checkCircle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }

        titleLB.snp.makeConstraints { make in
            make.leading.equalTo(checkCircle.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
        }

        contentLB.snp.makeConstraints { make in
            make.top.equalTo(titleLB.snp.bottom).offset(2)
            make.leading.equalTo(titleLB.snp.leading)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
        }

        dateLB.snp.makeConstraints { make in
            make.top.equalTo(contentLB.snp.bottom).offset(2)
            make.leading.equalTo(contentLB.snp.leading)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)  
        }

        tagLB.snp.makeConstraints { make in
            make.top.equalTo(dateLB.snp.bottom).offset(5)
            make.leading.equalTo(dateLB.snp.leading)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        titleLB.numberOfLines = 0
        contentLB.numberOfLines = 0
        dateLB.numberOfLines = 1
        tagLB.numberOfLines = 1
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol IdentifiableCell {
    static var identifier: String { get }
}

extension IdentifiableCell {
    static var identifier: String {
        return String(describing: self)
    }
}
