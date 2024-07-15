//
//  RegisteViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

class RegisterViewController: UIViewController, Base {
    let toDoListRepository = ToDoListRepository()
    
    let titleTextField = UITextField()
    let memoTextField = UITextField()
    let deadlineButton = UIButton(type: .system)
    let tagButton = UIButton(type: .system)
    let priorityButton = UIButton(type: .system)
    let imageAddButton = UIButton(type: .system)
    let folderSegmentedControl = UISegmentedControl(items: FolderFilter.allCases.map { $0.title })
    var saveButton: UIBarButtonItem!
    
    var viewModel: ToDoListViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    var selectedDeadline: Date?
    var selectedTag: String?
    var selectedPriority: String?
    var selectedImage: Data?
    var selectedFolder: String?
    var folder: Folder?
    weak var delegate: RegisterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupTextFieldObserver()
        setupButtonActions()
        
        // Realm 스키마 버전 확인하는 코드
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            do {
                let version = try schemaVersionAtURL(fileURL)
                print("Realm 스키마 버전은: \(version)")
            } catch {
                print(error)
            }
        }
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        view.addSubview(titleTextField)
        view.addSubview(memoTextField)
        view.addSubview(deadlineButton)
        view.addSubview(tagButton)
        view.addSubview(priorityButton)
        view.addSubview(imageAddButton)
        view.addSubview(folderSegmentedControl)
    }
    
    func setupConstraints() {
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
    
    func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        textField.textColor = .label
        textField.clearButtonMode = .whileEditing
    }
    
    func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
}

//노티피케이션
//post보다 addObserver가 항상 먼저 등록이 되어애 정상적으로 실행이 됨!!


