//
//  RegisterView+EXT.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/10/24.
//

import UIKit
import SnapKit
import RealmSwift
import Toast
import PhotosUI

extension RegisterViewController {
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        configureTextField(titleTextField, placeholder: "제목")
        configureTextField(memoTextField, placeholder: "메모")
        
        setupButton(deadlineButton, title: "마감일")
        setupButton(tagButton, title: "태그")
        setupButton(priorityButton, title: "우선 순위")
        setupButton(imageAddButton, title: "이미지 추가")
        
        folderSegmentedControl.selectedSegmentIndex = 0
        folderSegmentedControl.addTarget(self, action: #selector(folderSegmentedControlChanged), for: .valueChanged)
        selectedFolder = FolderFilter.allCases[folderSegmentedControl.selectedSegmentIndex].title
    }
    
    func bindViewModel() {
        viewModel.taskTitle.bind { [weak self]  title in
            self?.titleTextField.text = title
        }
        viewModel.taskContent.bind { [weak self]  content in
            self?.memoTextField.text = content
        }
        viewModel.taskDeadline.bind { [weak self]  deadline in
            if let deadline = deadline {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                self?.deadlineButton.setTitle(formatter.string(from: deadline), for: .normal)
            } else {
                self?.deadlineButton.setTitle("마감일", for: .normal)
            }
        }
        viewModel.taskTag.bind { [weak self]  tag in
            self?.tagButton.setTitle(tag.isEmpty ? "태그" : tag, for: .normal)
        }
        viewModel.taskPriority.bind { [weak self] priority in
            self?.priorityButton.setTitle(priority.isEmpty ? "우선 순위" : priority, for: .normal)
        }
        viewModel.taskCategory.bind { [weak self] category in
            if let index = FolderFilter.allCases.firstIndex(where: { $0.title == category }) {
                self?.folderSegmentedControl.selectedSegmentIndex = index
            }
        }
        viewModel.taskImage.bind { [weak self] image in
            if let _ = image {
                self?.imageAddButton.setTitle("이미지 선택 완료", for: .normal)
            } else {
                self?.imageAddButton.setTitle("이미지 추가", for: .normal)
            }
        }
    }
    
    func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = cancelButton
        
        saveButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false
        
        navigationItem.title = "새로운 할 일"
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc private func saveAction() {
        guard let title = titleTextField.text, !title.isEmpty else {
            print("제목이 비어 있습니다.")
            return
        }
        
        let newTask = createNewTask(withTitle: title)
        saveTaskImageIfNeeded(for: newTask)
        assignTaskToFolder(newTask)
        
        guard let folder = folder else {
            print("폴더가 설정되지 않았습니다.")
            return
        }
        
        toDoListRepository.createItem(newTask, folder: folder)
        delegate?.didAddNewTask()
        dismiss(animated: true)
    }
    
    func createNewTask(withTitle title: String) -> ToDoList {
        let newTask = ToDoList()
        newTask.taskTitle = title
        newTask.taskContent = memoTextField.text
        newTask.taskDeadline = selectedDeadline ?? nil
        newTask.taskTag = selectedTag ?? ""
        newTask.taskPriority = selectedPriority ?? ""
        newTask.taskCategory = selectedFolder ?? ""
        return newTask
    }
    
    func saveTaskImageIfNeeded(for task: ToDoList) {
        if let selectedImage = selectedImage {
            let filename = UUID().uuidString
            saveImageToDocument(image: UIImage(data: selectedImage)!, filename: filename)
            task.taskImagePath = filename
        }
    }
    
    func assignTaskToFolder(_ task: ToDoList) {
        let folderName = FolderFilter.allCases[folderSegmentedControl.selectedSegmentIndex].title
        folder = toDoListRepository.readFolder(named: folderName) ?? createNewFolder(named: folderName)
    }
    
    func createNewFolder(named name: String) -> Folder {
        let newFolder = Folder()
        newFolder.FolderName = name
        toDoListRepository.createFolder(newFolder)
        return newFolder
    }
    
    func setupTextFieldObserver() {
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        saveButton.isEnabled = !(titleTextField.text?.isEmpty ?? true)
    }
    
    func setupButtonActions() {
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
