//
//  BaseViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
//나중에 재시도
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        configureView()
       
    }
    
    func setupHierarchy() {
        //서브뷰 추가
    }
    
    func setupConstraints() {
        //제약 조건 추가
    }
    
    func configureView() {
        //설정 추가
    }
}

enum Filter: String, CaseIterable {
    case today = "오늘"
    case upcoming = "예정"
    case all = "전체"
    case flagged = "깃발 표시"
    case completed = "완료됨"

    var title: String {
        return self.rawValue
    }
}

enum FolderFilter: String, CaseIterable {
    case travel = "여행"
    case healthCare = "건강관리"
    case all = "전체"
    case financeManagement = "재정관리"
    case selfDevelopment = "자기계발"

    var title: String {
        return self.rawValue
    }
}



//폴더 추가뷰에서 색상 열거형
enum Colors: CaseIterable {
    case red, orange, yellow, green, blue, purple, brown
    case cyan, magenta, lime, pink, teal, lavender, olive
    case maroon, navy, grey, black, basic
    case customBlue, customPink, customPurple
    
    var color: UIColor {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .blue:
            return .blue
        case .purple:
            return .purple
        case .brown:
            return .brown
        case .cyan:
            return .cyan
        case .magenta:
            return .magenta
        case .lime:
            return UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        case .pink:
            return UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0)
        case .teal:
            return UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
        case .lavender:
            return UIColor(red: 0.9, green: 0.9, blue: 0.98, alpha: 1.0)
        case .olive:
            return UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0)
        case .maroon:
            return UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
        case .navy:
            return UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0)
        case .grey:
            return .gray
        case .black:
            return .black
        case .basic:
            return UIColor(red: 0.98, green: 0.89, blue: 0.73, alpha: 1.00)
        case .customBlue:
            return UIColor(red: 0.64, green: 0.82, blue: 1.00, alpha: 1.00)
        case .customPink:
            return UIColor(red: 1.00, green: 0.69, blue: 0.80, alpha: 1.00)
        case .customPurple:
            return UIColor(red: 0.80, green: 0.71, blue: 0.86, alpha: 1.00)
            
        }
    }
}

