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
import PhotosUI


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


class RegisterViewController: BaseViewController {
    private let toDoListRepository = ToDoListRepository()
    
    private let titleTextField = UITextField()
    private let memoTextField = UITextField()
    private let deadlineButton = UIButton(type: .system)
    private let tagButton = UIButton(type: .system)
    private let priorityButton = UIButton(type: .system)
    private let imageAddButton = UIButton(type: .system)
    private let folderSegmentedControl = UISegmentedControl(items: ["여행", "건강관리", "전체", "재정관리", "자기계발"])
    private var saveButton: UIBarButtonItem!

    var selectedDeadline: Date?
    var selectedTag: String?
    var selectedPriority: String?
    var selectedImage: Data?
    var selectedFolder: String?
    var folder: Folder? 
    weak var delegate: RegisterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupViews()
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

    override func setupHierarchy() {
        super.setupHierarchy()

        view.addSubview(titleTextField)
        view.addSubview(memoTextField)
        view.addSubview(deadlineButton)
        view.addSubview(tagButton)
        view.addSubview(priorityButton)
        view.addSubview(imageAddButton)
        view.addSubview(folderSegmentedControl)
    }

    private func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = cancelButton

        saveButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false // 초기 상태에서 비활성화

        navigationItem.title = "새로운 할 일"
    }

    @objc private func cancelAction() {
        dismiss(animated: true)
    }
   
    //🧯
    @objc private func saveAction() {
        let newTask = ToDoList()
        newTask.taskTitle = titleTextField.text ?? ""
        newTask.taskContent = memoTextField.text
        newTask.taskDeadline = selectedDeadline
        newTask.taskTag = selectedTag ?? ""
        newTask.taskPriority = selectedPriority ?? ""
        newTask.taskCategory = selectedFolder ?? ""

        if let selectedImage = selectedImage {
            let filename = UUID().uuidString
            saveImageToDocument(image: UIImage(data: selectedImage)!, filename: filename)
            newTask.taskImagePath = filename // 파일 이름을 저장
        }
    
        // 폴더 초기화 로직 추가
          let folderName = FolderFilter.allCases[folderSegmentedControl.selectedSegmentIndex].title
          if let existingFolder = toDoListRepository.readFolder(named: folderName) {
              folder = existingFolder
          } else {
              let newFolder = Folder()
              newFolder.FolderName = folderName
              toDoListRepository.createFolder(newFolder)
              folder = newFolder
          }

          guard let folder = folder else {
              print("폴더가 설정되지 않았습니다.")
              return
          }

          toDoListRepository.createItem(newTask, folder: folder)
        delegate?.didAddNewTask()
        dismiss(animated: true)
    }
    
    override func setupConstraints() {
        super.setupConstraints()

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

    private func setupViews() {
        view.backgroundColor = .systemBackground

        configureTextField(titleTextField, placeholder: "제목")
        configureTextField(memoTextField, placeholder: "메모")

        setupButton(deadlineButton, title: "마감일")
        setupButton(tagButton, title: "태그")
        setupButton(priorityButton, title: "우선 순위")
        setupButton(imageAddButton, title: "이미지 추가")
        
        folderSegmentedControl.selectedSegmentIndex = 0 // 기본 선택
        folderSegmentedControl.addTarget(self, action: #selector(folderSegmentedControlChanged), for: .valueChanged)
        selectedFolder = FolderFilter.allCases[folderSegmentedControl.selectedSegmentIndex].title // 기본 선택 폴더
    }

    private func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        textField.textColor = .label
        textField.clearButtonMode = .whileEditing
    }

    private func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }

    private func setupTextFieldObserver() {
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        saveButton.isEnabled = !(titleTextField.text?.isEmpty ?? true)
    }

    private func setupButtonActions() {
        deadlineButton.addTarget(self, action: #selector(deadlineButtonTapped), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
        priorityButton.addTarget(self, action: #selector(priorityButtonTapped), for: .touchUpInside)
        imageAddButton.addTarget(self, action: #selector(imageAddButtonTapped), for: .touchUpInside)
    }

    @objc private func deadlineButtonTapped() {
        let deadlineVC = DeadlineViewController()
        deadlineVC.delegate = self
        self.navigationController?.pushViewController(deadlineVC, animated: true)
    }

    @objc private func tagButtonTapped() {
        let tagVC = TagViewController()
        tagVC.delegate = self
        self.navigationController?.pushViewController(tagVC, animated: true)
    }

    @objc private func priorityButtonTapped() {
        let priorityVC = PriorityViewController()
        priorityVC.delegate = self
        self.navigationController?.pushViewController(priorityVC, animated: true)
    }

    @objc private func imageAddButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func folderSegmentedControlChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        selectedFolder = FolderFilter.allCases[selectedIndex].title
    }
}

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

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            selectedImage = image.jpegData(compressionQuality: 0.8)
            imageAddButton.setTitle("이미지 선택 완료", for: .normal)
        } else if let image = info[.originalImage] as? UIImage {
            selectedImage = image.jpegData(compressionQuality: 0.8)
            imageAddButton.setTitle("이미지 선택 완료", for: .normal)
        }
        dismiss(animated: true)
    }
}

extension RegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.selectedImage = image.jpegData(compressionQuality: 0.8)
                        self.imageAddButton.setTitle("이미지 선택 완료", for: .normal)
                    }
                }
            }
        }
        dismiss(animated: true)
    }
}



//노티피케이션
//post보다 addObserver가 항상 먼저 등록이 되어애 정상적으로 실행이 됨!!


