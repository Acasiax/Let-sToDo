//
//  PriorityViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/3/24.
//

import UIKit
import SnapKit

class PriorityViewController: UIViewController {
    var delegate: DataDelegate?
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "우선순위를 선택하세요"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["높음", "보통", "낮음"])
        sc.selectedSegmentIndex = 1 // 기본 설정은 "보통"
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        setupConstraints()
        setupStyle()
        setupNavigationBar()
    }
    
    func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(segmentedControl)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    func setupStyle() {
        segmentedControl.selectedSegmentTintColor = .systemBlue
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        segmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
    }
    
    func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        let selectedSegmentTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "Unknown"
        print("선택한: \(selectedSegmentTitle)")
        delegate?.passData(selectedSegmentTitle, type: .priority)
        navigationController?.popViewController(animated: true)
        
    }
}
