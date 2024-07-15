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

final class ToDoListViewController: UIViewController, Base {
 
    let dbManager = DatabaseManager()
    let toDoListRepository = ToDoListRepository()
    var list: [Folder] = []
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
    
    func configureCell(_ cell: TodoListTableViewCell, with folder: Folder) {
        cell.titleLB.text = folder.FolderName
        cell.contentLB.text = folder.optionDescription
        cell.dateLB.text = formatDate(folder.regDate)
        cell.tagLB.text = ""
        cell.overviewLabel.text = "\(folder.detail88.count) 개의 목록"
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

