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
    
    var selectedDate: Observable<Void?> = Observable(nil)
    private var date: Date?
    
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .automatic
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 10
        picker.clipsToBounds = true
        return picker
    }()

    private let selectedDateLabel: UILabel = {
            let label = UILabel()
            label.text = "선택된 마감일 없음"
            label.textAlignment = .center
            return label
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindData()
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
        
        view.addSubview(selectedDateLabel)
                selectedDateLabel.snp.makeConstraints { make in
                    make.top.equalTo(datePicker.snp.bottom).offset(20)
                    make.leading.trailing.equalTo(titleLabel)
                }

    }

    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    
    private func bindData() {
            selectedDate.bind { [weak self] _ in
                guard let self = self else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                if let date = self.date {
                    self.selectedDateLabel.text = "선택된 마감일: \(dateFormatter.string(from: date))"
                } else {
                    self.selectedDateLabel.text = "선택된 마감일 없음(옵져버 활용)"
                }
            }
            
            datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        }

        @objc private func datePickerValueChanged() {
            date = datePicker.date
            selectedDate.value = ()
        }
    

    @objc private func backButtonTapped() {
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                let dateString = dateFormatter.string(from: date)
                delegate?.passData(dateString, type: .deadline)
                print("선택한 마감일: \(dateString)")
            }
            navigationController?.popViewController(animated: true)
        }
}
