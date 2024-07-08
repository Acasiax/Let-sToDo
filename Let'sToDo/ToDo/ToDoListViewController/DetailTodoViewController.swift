//
//  DetailTodoViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/6/24.
//

import UIKit
import RealmSwift
import SnapKit
import Toast

class DetailTodoViewController: UIViewController {

    var mainTask: ToDoList? // ToDoList 객체를 저장하는 변수
    var folderCategoryName: String?
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let deadlineLabel = UILabel()
    let priorityLabel = UILabel()
    let tagLabel = UILabel()
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupUI()
        applyConstraints()
        configureView()
        if let folderCategoryName = folderCategoryName {
                  navigationItem.title = folderCategoryName
            print("선택된 폴더 필터: \(folderCategoryName)")
              }
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(deadlineLabel)
        view.addSubview(priorityLabel)
        view.addSubview(tagLabel)
        view.addSubview(imageView)
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor.label
        
        contentLabel.font = .systemFont(ofSize: 16, weight: .regular)
        contentLabel.textColor = UIColor.secondaryLabel
        
        deadlineLabel.font = .systemFont(ofSize: 14, weight: .regular)
        deadlineLabel.textColor = UIColor.systemRed
        
        priorityLabel.font = .systemFont(ofSize: 14, weight: .regular)
        priorityLabel.textColor = UIColor.systemBlue
        
        tagLabel.font = .systemFont(ofSize: 14, weight: .regular)
        tagLabel.textColor = UIColor.systemGreen
        
        // 이미지 뷰 스타일 설정
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.backgroundColor = UIColor.systemGray6
    }
    
    private func applyConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(deadlineLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(200)
        }
    }
    
    private func configureView() {
        guard let task = mainTask else { return }
        
        titleLabel.text = task.taskTitle
        contentLabel.text = "내용: \(task.taskContent!)"
        deadlineLabel.text = "마감일: \(formatDate(task.taskDeadline))"
        priorityLabel.text = "우선순위: \(task.taskPriority)"
        tagLabel.text = "태그: \(task.taskTag)"
        
      //  if let imageData = task.taskImagePath {
          //  imageView.image = UIImage(data: imageData)
        if let imagePath = task.taskImagePath {
            imageView.image = loadImageFromDocument(filename: imagePath)
        } else {
            imageView.image = nil
        }
    }
    
    func loadImageFromDocument(filename: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(
               for: .documentDirectory,
               in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return nil
        }
    }

    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "No deadline" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}
