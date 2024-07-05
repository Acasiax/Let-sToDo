//
//  DeadlineViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/3/24.
//

import UIKit
import SnapKit

class DeadlineViewController: UIViewController {
    var delegate: DataDelegate?
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .automatic
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 10
        picker.clipsToBounds = true
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = "마감일을 선택하세요"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(titleLabel)
        }

        let saveButton = UIButton(type: .system)
        saveButton.setTitle("저장", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        saveButton.backgroundColor = UIColor.systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10

    }

    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }


    @objc private func backButtonTapped() {
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: selectedDate)
        delegate?.passData(dateString, type: .deadline)
        print("선택한 마감일: \(dateString)")
        NotificationCenter.default.post(name: .didSelectDeadline, object: selectedDate)
        navigationController?.popViewController(animated: true)
    }
}
