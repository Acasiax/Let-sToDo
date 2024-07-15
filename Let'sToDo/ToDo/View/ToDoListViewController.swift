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

final class ToDoListViewController: UIViewController {
    let dbManager = DatabaseManager()
    private let toDoListRepository = ToDoListRepository()
    var list: [Folder] = [] // Folder 배열로 변경
    let titleLbl = UILabel()
    let taskTableView = UITableView()
    let realmDb = try! Realm()
    
    var filter: String?
    var folderFilter: String?
    var mainFilter: Filter?
    var folder: Folder? // 선택한 폴더 정보를 저장할 변수!
    
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
        if let folderFilter = folderFilter {
            print("폴더 필터가 설정됨: \(folderFilter)")
            navigationItem.title = folderFilter
            list = toDoListRepository.readFolders(with: folderFilter)
        } else {
            navigationItem.title = "전체"
            list = toDoListRepository.readAllFolders()
        }
        refreshTaskList()
    }
    
    @objc func refreshTaskList() {
        if let folderFilter = folderFilter {
            list = toDoListRepository.readFolders(with: folderFilter)
        } else {
            list = toDoListRepository.readAllFolders()
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
    
    private func configureCell(_ cell: TodoListTableViewCell, with folder: Folder) {
        cell.titleLB.text = folder.FolderName
        cell.contentLB.text = folder.optionDescription
        cell.dateLB.text = formatDate(folder.regDate)
        cell.tagLB.text = "" // Folder에는 tag가 없으므로 빈 문자열로 설정
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
    
    private func configureView() {
        configureSortMenu()
        setupTitleLabel()
        setupTableView()
    }
    
    private func configureSortMenu() {
        let sortByDeadline = createSortAction(title: "마감일로 정렬", keyPath: "regDate", ascending: true)
        let sortByTitle = createSortAction(title: "제목순으로", keyPath: "FolderName", ascending: true)
        
        let sortMenu = UIMenu(title: "정렬 옵션", children: [sortByDeadline, sortByTitle])
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle.fill"), menu: sortMenu)
    }
    
    private func createSortAction(title: String, keyPath: String, ascending: Bool, filter: String? = nil) -> UIAction {
        return UIAction(title: title) { _ in
            self.list = self.toDoListRepository.readFoldersSorted(by: keyPath, ascending: ascending)
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
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as! TodoListTableViewCell
        let folder = list[indexPath.row]
        
        configureCell(cell, with: folder)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("클릭했슈")
        let detailVC = DetailTodoViewController()
        
        let selectedFolder = list[indexPath.row]
        if let firstTask = selectedFolder.detail88.first {
            detailVC.mainTask = firstTask // 폴더 내의 첫 번째 작업을 전달
        }
        
        detailVC.folderCategoryName = selectedFolder.FolderName

        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detailAction = UIContextualAction(style: .normal, title: "취소") { action, view, success in
            success(true)
        }
        detailAction.backgroundColor = .systemGray

        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { action, view, success in
            let folderToDelete = self.list[indexPath.row]
            
            // 데이터베이스에서 폴더 삭제
            self.dbManager.remove(folderToDelete)
            
            success(true)
            self.refreshTaskList()
        }
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction, detailAction])
    }

}
