//
//  RegisteViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift
import Toast

protocol DataDelegate {
    func passData(_ data: String, type: DataType)
}

enum DataType {
    case tag
    case priority
    case deadline
}


class RegisterViewController: UIViewController {
  
    private let titleTextField = UITextField()
    private let memoTextField = UITextField()
    private let deadlineButton = UIButton(type: .system)
    private let tagButton = UIButton(type: .system)
    private let priorityButton = UIButton(type: .system)
    private let imageAddButton = UIButton(type: .system)
    let realm = try! Realm()
    
    private var saveButton: UIBarButtonItem!
    
    var selectedDeadline: Date?
    var selectedTag: String?
    var selectedPriority: String?
    var selectedImage: Data?
    
    
    var showToast: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(realm.configuration.fileURL)
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupTextFieldObserver()
        setupButtonActions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectDeadline(_:)), name: .didSelectDeadline, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectTag(_:)), name: .didSelectTag, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectPriority(_:)), name: .didSelectPriority, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectImage(_:)), name: .didSelectImage, object: nil)
        
        //램 스키마 버전 확인하는 코드
        do {
            let version = try
            schemaVersionAtURL(realm.configuration.fileURL!)
            print("램 스키마 버전은: \(version)")
        } catch {
            print(error)
        }
    }
    
    func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = cancelButton
        
        saveButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false // 초기 상태에서 비활성화
        
        navigationItem.title = "새로운 할 일"
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc func saveAction() {
        let newTask = Task()
        newTask.taskTitle = titleTextField.text ?? ""
        newTask.taskContent = memoTextField.text
        newTask.taskDeadline = selectedDeadline
        newTask.taskTag = selectedTag ?? ""
        newTask.taskPriority = selectedPriority ?? ""
        newTask.taskImage = selectedImage
           
        
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(newTask)
        }
        
        let toDoListVC = ToDoListViewController()
        showToast?()
        
        let navController = UINavigationController(rootViewController: toDoListVC)
        self.present(navController, animated: true, completion: nil)
        
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        configureTextField(titleTextField, placeholder: "제목")
        configureTextField(memoTextField, placeholder: "메모")
        
        setupButton(deadlineButton, title: "마감일")
        setupButton(tagButton, title: "태그")
        setupButton(priorityButton, title: "우선 순위")
        setupButton(imageAddButton, title: "이미지 추가")
        
        view.addSubview(titleTextField)
        view.addSubview(memoTextField)
        view.addSubview(deadlineButton)
        view.addSubview(tagButton)
        view.addSubview(priorityButton)
        view.addSubview(imageAddButton)
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
    
    func setupConstraints() {
        let padding: CGFloat = 16
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(padding)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.height.equalTo(50)
        }
        
        memoTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
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
    }
    
    func setupTextFieldObserver() {
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = titleTextField.text, !text.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    func setupButtonActions() {
        deadlineButton.addTarget(self, action: #selector(deadlineButtonTapped), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
        priorityButton.addTarget(self, action: #selector(priorityButtonTapped), for: .touchUpInside)
        imageAddButton.addTarget(self, action: #selector(imageAddButtonTapped), for: .touchUpInside)
    }
    
    @objc func deadlineButtonTapped() {
        let deadlineVC = DeadlineViewController()
        deadlineVC.delegate = self
        self.navigationController?.pushViewController(deadlineVC, animated: true)
    }
    
    @objc func tagButtonTapped() {
        let tagVC = TagViewController()
        tagVC.delegate = self
        self.navigationController?.pushViewController(tagVC, animated: true)
    }
    
    @objc func priorityButtonTapped() {
        let priorityVC = PriorityViewController()
        priorityVC.delegate = self
        self.navigationController?.pushViewController(priorityVC, animated: true)
    }
    
    @objc func imageAddButtonTapped() {
        let imageAddVC = ImageAddViewController()
        self.navigationController?.pushViewController(imageAddVC, animated: true)
    }
    
    
    
    // Notification
    @objc func didSelectDeadline(_ notification: Notification) {
        if let date = notification.object as? Date {
            selectedDeadline = date
            print("선택한 마감일: \(date)")
        }
    }
    
    @objc func didSelectTag(_ notification: Notification) {
        if let tag = notification.object as? String {
            selectedTag = tag
            print("작성한 태그: \(tag)")
            
        }
    }
    
    @objc func didSelectPriority(_ notification: Notification) {
        if let priority = notification.object as? String {
            selectedPriority = priority
            print("선택한 우선순위: \(priority)")
        }
    }
    
    @objc func didSelectImage(_ notification: Notification) {
        if let imageData = notification.object as? Data {
            selectedImage = imageData
            print("이미지 선택됨")
        }
    }
}


// 확장 부분
extension RegisterViewController: DataDelegate {
    func passData(_ data: String, type: DataType) {
        switch type {
        case .deadline:
            print("전달받은 마감일: \(data)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            if let date = dateFormatter.date(from: data) {
                selectedDeadline = date
                deadlineButton.setTitle("내가 선택한 마감일: \(data)", for: .normal)
            }
        case .tag:
            print("전달받은 태그: \(data)")
            selectedTag = data
            tagButton.setTitle("내가 선택한 태그: \(data)", for: .normal)
        case .priority:
            print("전달받은 우선순위: \(data)")
            selectedPriority = data
            priorityButton.setTitle("내가 선택한 우선순위: \(data)", for: .normal)
        }
    }
}



extension Notification.Name {
    static let didAddTask = Notification.Name("didAddTask")
    static let didSelectDeadline = Notification.Name("didSelectDeadline")
    static let didSelectTag = Notification.Name("didSelectTag")
    static let didSelectPriority = Notification.Name("didSelectPriority")
    static let didSelectImage = Notification.Name("didSelectImage")
}



//노티피케이션
//post보다 addObserver가 항상 먼저 등록이 되어애 정상적으로 실행이 됨!!
