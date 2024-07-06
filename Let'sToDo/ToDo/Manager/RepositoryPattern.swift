//
//  Repository.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/7/24.
//

import UIKit
import RealmSwift

final class ToDoListRepository {
    private let realm = try! Realm()
    
    func createItem(_ data: ToDoList) {
        do {
            try realm.write {
                realm.add(data)
                print("saved!")
            }
        } catch {
            print("save error")
        }
    }
    
    func readAllItems() -> [ToDoList] {
        let result = realm.objects(ToDoList.self).sorted(byKeyPath: "taskTitle", ascending: true)
        return Array(result)
    }
    
    func readItems(with filter: String?) -> [ToDoList] {
        if let filter = filter {
            switch filter {
            case "오늘":
                return Array(realm.objects(ToDoList.self).filter("taskDeadline <= %@", Date()))
            case "예정":
                return Array(realm.objects(ToDoList.self).filter("taskDeadline > %@", Date()))
            case "전체":
                return Array(realm.objects(ToDoList.self))
            case "깃발 표시":
                return Array(realm.objects(ToDoList.self).filter("taskTag == '깃발'"))
            case "완료됨":
                return Array(realm.objects(ToDoList.self).filter("taskPriority == '완료'"))
            default:
                return Array(realm.objects(ToDoList.self))
            }
        } else {
            return Array(realm.objects(ToDoList.self))
        }
    }
    
    func deleteItem(_ data: ToDoList) {
        do {
            try realm.write {
                realm.delete(data)
                print("deleted")
            }
        } catch {
            print("delete error")
        }
    }
    
    func fetchCount(for filter: MainHomeViewController.Filter) -> Int {
        switch filter {
        case .today:
            return realm.objects(ToDoList.self).filter("taskDeadline <= %@", Date()).count
        case .upcoming:
            return realm.objects(ToDoList.self).filter("taskDeadline > %@", Date()).count
        case .all:
            return realm.objects(ToDoList.self).count
        case .flagged:
            return realm.objects(ToDoList.self).filter("taskTag == '깃발'").count
        case .completed:
            return realm.objects(ToDoList.self).filter("taskPriority == '완료'").count
        }
    }
}
