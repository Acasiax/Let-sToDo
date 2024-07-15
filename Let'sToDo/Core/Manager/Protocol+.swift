//
//  Protocol+.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/8/24.
//

import Foundation

protocol DataDelegate {
    func passData(_ data: String, type: DataType)
}

enum DataType {
    case tag
    case priority
    case deadline
}

protocol RegisterViewControllerDelegate: AnyObject {
    func didAddNewTask() //등록한 추가를 바로 main뷰에 딜리게이트로 반영
}

protocol IdentifiableCell {
    static var identifier: String { get }
}

extension IdentifiableCell {
    static var identifier: String {
        return String(describing: self)
    }
}
