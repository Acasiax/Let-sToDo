//
//  ToDoListViewModel.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/9/24.
//
import Foundation
import RealmSwift

class ToDoListViewModel {
    var tasks: Observable<[ToDoList]> = Observable([])
    private let repository = ToDoListRepository()

    init() {
        fetchAllTasks()
    }

    func fetchAllTasks() {
        tasks.value = repository.readAllItems()
    }
    
    func addTask(_ task: ToDoList, to folder: Folder) {
        repository.createItem(task, folder: folder)
        fetchAllTasks()
    }
    
    func deleteTask(_ task: ToDoList) {
        repository.deleteItem(task)
        fetchAllTasks()
    }

    func updateTask(_ oldTask: ToDoList, with newTask: ToDoList) {
        repository.deleteItem(oldTask)  // oldTask를 삭제하고
        repository.createItem(newTask, folder: repository.readFolder(named: newTask.taskCategory)!)  // newTask를 추가
        fetchAllTasks()
    }
}
