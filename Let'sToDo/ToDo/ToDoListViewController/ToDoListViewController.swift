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

class ToDoListViewController: UIViewController {
    let dbManager = DatabaseManager()
    var TodoList: Results<ToDoList>!
    let titleLbl = UILabel()
    let taskTableView = UITableView()
    let realmDb = try! Realm()
    
    var filter: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realmDb.configuration.fileURL)
        view.backgroundColor = .white
        setupUI()
        applyConstraints()
        configureView()
        taskTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTaskList()
    }
    
    @objc func refreshTaskList() {
        if let filter = filter {
            switch filter {
            case "오늘":
                TodoList = realmDb.objects(ToDoList.self).filter("taskDeadline <= %@", Date())
            case "예정":
                TodoList = realmDb.objects(ToDoList.self).filter("taskDeadline > %@", Date())
            case "전체":
                TodoList = realmDb.objects(ToDoList.self)
            case "깃발 표시":
                TodoList = realmDb.objects(ToDoList.self).filter("taskTag == '깃발'")
            case "완료됨":
                TodoList = realmDb.objects(ToDoList.self).filter("taskPriority == '완료'")
            default:
                TodoList = realmDb.objects(ToDoList.self)
            }
        } else {
            TodoList = realmDb.objects(ToDoList.self)
        }
        taskTableView.reloadData()
    }
    
    private func setupUI() {
        view.addSubview(titleLbl)
        view.addSubview(taskTableView)
    }
    
    private func applyConstraints() {
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
    
    private func configureCell(_ cell: TodoListTableViewCell, with task: ToDoList) {
        cell.titleLB.text = task.taskTitle
        cell.contentLB.text = task.taskContent
        cell.taskId = task.taskId
       // cell.taskId = task.taskId.stringValue
        cell.dateLB.text = formatDate(task.taskDeadline)
        cell.tagLB.text = formatTag(task.taskTag)
        cell.checkCircle.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    private func formatTag(_ tag: String) -> String {
        return tag.isEmpty ? "" : "#\(tag)"
    }

    private func configureView() {
        configureSortMenu()
        setupTitleLabel()
        setupTableView()
    }

    private func configureSortMenu() {
        let sortByDeadline = createSortAction(title: "마감일로 정렬", keyPath: "taskDeadline", ascending: true)
        let sortByTitle = createSortAction(title: "제목순으로", keyPath: "taskTitle", ascending: true)
        let sortByPriority = createSortAction(title: "우선순위순으로", keyPath: "taskPriority", ascending: true, filter: "taskDeadline == '2'")
        
        let sortMenu = UIMenu(title: "정렬 옵션", children: [sortByDeadline, sortByTitle, sortByPriority])
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle.fill"), menu: sortMenu)
    }

    private func createSortAction(title: String, keyPath: String, ascending: Bool, filter: String? = nil) -> UIAction {
        return UIAction(title: title) { _ in
            if let filter = filter {
                self.TodoList = self.realmDb.objects(ToDoList.self).filter(filter).sorted(byKeyPath: keyPath, ascending: ascending)
            } else {
                self.TodoList = self.realmDb.objects(ToDoList.self).sorted(byKeyPath: keyPath, ascending: ascending)
            }
            self.taskTableView.reloadData()
        }
    }

    private func setupTitleLabel() {
        titleLbl.text = "전체"
        titleLbl.font = .systemFont(ofSize: 25, weight: .heavy)
        titleLbl.textColor = .systemBlue
    }

    private func setupTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.identifier)
        taskTableView.backgroundColor = .systemGray
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as! TodoListTableViewCell
        let todotask = TodoList[indexPath.row]

        configureCell(cell, with: todotask)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("클릭했슈")
        let detailVC = DetailTodoViewController()
        detailVC.mainTask = TodoList[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detailAction = UIContextualAction(style: .normal, title: "취소") { action, view, success in
            success(true)
        }
        detailAction.backgroundColor = .systemGray

        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { action, view, success in
            self.dbManager.remove(self.TodoList[indexPath.row])
            success(true)
            tableView.reloadData()
        }
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction, detailAction])
    }
}

