//
//  ToDoListViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit
import Toast

//final class ToDoListViewController: UIViewController, Base {
// 
//    let dbManager = DatabaseManager()
//    let toDoListRepository = ToDoListRepository()
//    var list: [Folder] = []
//    let titleLbl = UILabel()
//    let taskTableView = UITableView()
//    let realmDb = try! Realm()
//    
//    var filter: String?
//    var folderFilter: String?
//    var mainFilter: Filter?
//    var folder: Folder?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print(realmDb.configuration.fileURL)
//        view.backgroundColor = .white
//        setupHierarchy()
//        setupConstraints()
//        configureView()
//        taskTableView.rowHeight = UITableView.automaticDimension
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateNavigationBarTitle()
//        refreshTaskList()
//    }
//    
//    func configureView() {
//        configureSortMenu()
//        setupTitleLabel()
//        setupTableView()
//    }
//    
//    private func setupTableView() {
//        taskTableView.delegate = self
//        taskTableView.dataSource = self
//        taskTableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.identifier)
//        taskTableView.backgroundColor = .systemGray
//    }
//    
//    func setupHierarchy() {
//        view.addSubview(titleLbl)
//        view.addSubview(taskTableView)
//    }
//   
//    
//    func setupConstraints() {
//        titleLbl.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
//            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
//            make.height.equalTo(35)
//        }
//        
//        taskTableView.snp.makeConstraints { make in
//            make.top.equalTo(titleLbl.snp.bottom).offset(20)
//            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//    
//    func configureCell(_ cell: TodoListTableViewCell, with folder: Folder) {
//        cell.titleLB.text = "<\(folder.FolderName)> 폴더의 첫번째"
//        
//        cell.contentLB.text = folder.optionDescription //폴더명말고, 일정 제목으로 변경할때 이거 변경해야 됨.
//        
//        print(folder.detail88.projectTo.taskContent.description)
//        cell.dateLB.text = formatDate(folder.regDate)
//        cell.tagLB.text = ""
//        cell.overviewLabel.text = "\(folder.detail88.count) 개의 목록"
//        cell.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
//        
//        
//        //폴더명말고, 일정 제목으로 변경할때 이거 변경해야 됨.
//           let taskContents = folder.detail88.projectTo.taskContent.compactMap { $0 }
//           if taskContents.count > 1 {
//               cell.titleLB.text = taskContents[0] // 첫 번째 항목을 제목으로 설정
//               cell.contentLB.text = taskContents[1] // 두 번째 항목을 내용으로 설정
//           } else if let firstTaskContent = taskContents.first {
//               cell.titleLB.text = firstTaskContent // 첫 번째 항목만 있는 경우 제목으로 설정
//               cell.contentLB.text = "" // 내용은 빈 문자열로 설정
//           }
//        
//    }
//    
//    private func formatDate(_ date: Date?) -> String {
//        guard let date = date else { return "" }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .short
//        return dateFormatter.string(from: date)
//    }
//    
//}


import UIKit
import RealmSwift
import SnapKit
import Toast

final class ToDoListViewController: UIViewController, Base {
 
    let dbManager = DatabaseManager()
    let toDoListRepository = ToDoListRepository()
    var list: [ToDoList] = []
    let titleLbl = UILabel()
    let taskTableView = UITableView()
    let realmDb = try! Realm()
    
    var filter: String?
    var folderFilter: String?
    var mainFilter: Filter?
    var folder: Folder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realmDb.configuration.fileURL)
        view.backgroundColor = .white
        setupHierarchy()
        setupConstraints()
        configureView()
        taskTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarTitle()
        refreshTaskList()
    }
    
    func configureView() {
        configureSortMenu()
        setupTitleLabel()
        setupTableView()
    }
    
    private func setupTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.identifier)
        taskTableView.backgroundColor = .systemGray
    }
    
    func setupHierarchy() {
        view.addSubview(titleLbl)
        view.addSubview(taskTableView)
    }
   
    
    func setupConstraints() {
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(35)
        }
        
        taskTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCell(_ cell: TodoListTableViewCell, with task: ToDoList) {
        cell.titleLB.text = task.taskTitle
        cell.contentLB.text = task.taskContent
        cell.dateLB.text = formatDate(task.taskDeadline)
        cell.tagLB.text = task.taskTag
        cell.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
}
