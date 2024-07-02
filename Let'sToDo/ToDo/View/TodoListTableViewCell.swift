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
        
        titleLB.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
        }
        contentLB.snp.makeConstraints { make in
            make.top.equalTo(titleLB.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
        }
        dateLB.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().offset(-8)
        }
        tagLB.snp.makeConstraints { make in
            make.top.equalTo(dateLB.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-8)
        }
        checkCircle.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(24)
        }
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
