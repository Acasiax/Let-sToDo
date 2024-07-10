//
//  RegisterView+EXT.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/10/24.
//

import UIKit

extension RegisterViewController {
    
   func setupConstraints2() {

        let padding: CGFloat = 16

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(padding)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(50)
        }

        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(padding)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(130)
        }

        deadlineButton.snp.makeConstraints { make in
            make.top.equalTo(memoTextField.snp.bottom).offset(padding)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(44)
        }

        tagButton.snp.makeConstraints { make in
            make.top.equalTo(deadlineButton.snp.bottom).offset(padding)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(44)
        }

        priorityButton.snp.makeConstraints { make in
            make.top.equalTo(tagButton.snp.bottom).offset(padding)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(44)
        }

        imageAddButton.snp.makeConstraints { make in
            make.top.equalTo(priorityButton.snp.bottom).offset(padding)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(44)
        }
        
        folderSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(imageAddButton.snp.bottom).offset(padding)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(44)
        }
    }
    
    
    
}
