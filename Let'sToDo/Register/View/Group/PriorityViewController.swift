//
//  PriorityViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/3/24.
//

import UIKit
import SnapKit

class PriorityViewController: BaseViewController {
    var delegate: DataDelegate?
    
    var selectedPriority: Observable<Void?> = Observable(nil)
    private var priority: String = "보통"
    
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
    
    private let selectedPriorityLabel: UILabel = {
        let label = UILabel()
        label.text = "선택된 우선순위: 보통"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupHierarchy()
        setupConstraints()
        configureView()
        setupNavigationBar()
        bindData()
    }
    
    override func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(selectedPriorityLabel)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        selectedPriorityLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    

    override func configureView() {
        segmentedControl.selectedSegmentTintColor = .systemBlue
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        segmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
    }
    
    private func bindData() {
        selectedPriority.bind { [weak self] _ in
            guard let self = self else { return }
            self.selectedPriorityLabel.text = "선택된 우선순위: \(self.priority)"
        }
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged() {
        priority = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "보통"
        selectedPriority.value = ()
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
