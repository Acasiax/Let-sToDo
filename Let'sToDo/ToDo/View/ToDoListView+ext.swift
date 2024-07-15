//
//  tod.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/15/24.
//

import UIKit

//extension ToDoListViewController {
//    
//    @objc func refreshTaskList() {
//        if let folderFilter = folderFilter {
//            list = toDoListRepository.readFolders(with: folderFilter, mainFilter: mainFilter)
//        } else {
//            list = toDoListRepository.readAllFolders(mainFilter: mainFilter)
//        }
//        taskTableView.reloadData()
//        updateEmptyState()
//    }
//    
//     func updateNavigationBarTitle() {
//        if let folderFilter = folderFilter {
//            navigationItem.title = folderFilter
//        } else {
//            navigationItem.title = "전체"
//        }
//    }
//    
//     func updateEmptyState() {
//        if list.isEmpty {
//            let emptyLabel = UILabel()
//            emptyLabel.text = "일정이 없습니다."
//            emptyLabel.textAlignment = .center
//            emptyLabel.textColor = .gray
//            emptyLabel.font = UIFont.systemFont(ofSize: 20)
//            taskTableView.backgroundView = emptyLabel
//        } else {
//            taskTableView.backgroundView = nil
//        }
//    }
//    
//    func configureSortMenu() {
//        let sortByDeadline = createSortAction(title: "마감일로 정렬", keyPath: "regDate", ascending: true)
//        let sortByTitle = createSortAction(title: "제목순으로", keyPath: "FolderName", ascending: true)
//        
//        let sortMenu = UIMenu(title: "정렬 옵션", children: [sortByDeadline, sortByTitle])
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle.fill"), menu: sortMenu)
//    }
//    
//    func createSortAction(title: String, keyPath: String, ascending: Bool, filter: String? = nil) -> UIAction {
//        return UIAction(title: title) { _ in
//            self.list = self.toDoListRepository.readFoldersSorted(by: keyPath, ascending: ascending)
//            self.taskTableView.reloadData()
//        }
//    }
//    
//    func setupTitleLabel() {
//        titleLbl.text = "전체"
//        titleLbl.font = .systemFont(ofSize: 25, weight: .heavy)
//        titleLbl.textColor = .systemBlue
//    }
//}
//
//extension ToDoListViewController:  UITableViewDelegate, UITableViewDataSource  {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return list.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as! TodoListTableViewCell
//        let folder = list[indexPath.row]
//        
//        configureCell(cell, with: folder)
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("클릭했슈")
//        let detailVC = DetailTodoViewController()
//        
//        let selectedFolder = list[indexPath.row]
//        if let firstTask = selectedFolder.detail88.first {
//            detailVC.mainTask = firstTask // 폴더 내의 첫 번째 작업을 전달
//        }
//        
//        detailVC.folderCategoryName = selectedFolder.FolderName
//        
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let detailAction = UIContextualAction(style: .normal, title: "취소") { action, view, success in
//            success(true)
//        }
//        detailAction.backgroundColor = .systemGray
//        
//        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { action, view, success in
//            let folderToDelete = self.list[indexPath.row]
//            
//            // 데이터베이스에서 폴더 삭제
//            self.dbManager.remove(folderToDelete)
//            
//            success(true)
//            self.refreshTaskList()
//        }
//        deleteAction.backgroundColor = .red
//        
//        return UISwipeActionsConfiguration(actions: [deleteAction, detailAction])
//    }
//}

extension ToDoListViewController {
    
    @objc func refreshTaskList() {
        if let folderFilter = folderFilter {
            let folders = toDoListRepository.readFolders(with: folderFilter, mainFilter: mainFilter)
            list = folders.flatMap { $0.detail88 }
        } else {
            let folders = toDoListRepository.readAllFolders(mainFilter: mainFilter)
            list = folders.flatMap { $0.detail88 }
        }
        taskTableView.reloadData()
        updateEmptyState()
    }
    
     func updateNavigationBarTitle() {
        if let folderFilter = folderFilter {
            navigationItem.title = folderFilter
        } else {
            navigationItem.title = "전체"
        }
    }
    
     func updateEmptyState() {
        if list.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "일정이 없습니다."
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .gray
            emptyLabel.font = UIFont.systemFont(ofSize: 20)
            taskTableView.backgroundView = emptyLabel
        } else {
            taskTableView.backgroundView = nil
        }
    }
    
    func configureSortMenu() {
        let sortByDeadline = createSortAction(title: "마감일로 정렬", keyPath: "taskDeadline", ascending: true)
        let sortByTitle = createSortAction(title: "제목순으로", keyPath: "taskTitle", ascending: true)
        
        let sortMenu = UIMenu(title: "정렬 옵션", children: [sortByDeadline, sortByTitle])
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle.fill"), menu: sortMenu)
    }
    
    func createSortAction(title: String, keyPath: String, ascending: Bool, filter: String? = nil) -> UIAction {
        return UIAction(title: title) { _ in
            self.list = self.toDoListRepository.readToDoListsSorted(by: keyPath, ascending: ascending)
            self.taskTableView.reloadData()
        }
    }
    
    func setupTitleLabel() {
        titleLbl.text = "전체"
        titleLbl.font = .systemFont(ofSize: 25, weight: .heavy)
        titleLbl.textColor = .systemBlue
    }
}

extension ToDoListViewController:  UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier, for: indexPath) as! TodoListTableViewCell
        let task = list[indexPath.row]
        
        configureCell(cell, with: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("클릭했슈")
        let detailVC = DetailTodoViewController()
        
        let selectedTask = list[indexPath.row]
        
        detailVC.mainTask = selectedTask // 선택된 작업을 전달
        
        if let folder = selectedTask.main.first {
            detailVC.folderCategoryName = folder.FolderName
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let detailAction = UIContextualAction(style: .normal, title: "취소") { action, view, success in
            success(true)
        }
        detailAction.backgroundColor = .systemGray
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { action, view, success in
            let taskToDelete = self.list[indexPath.row]
            
            // 데이터베이스에서 작업 삭제
            self.dbManager.remove(taskToDelete)
            
            success(true)
            self.refreshTaskList()
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction, detailAction])
    }
}
