//
//  TaskManager.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import RealmSwift

protocol DataDelegate {
    func passData(_ data: String, type: DataType)
}

enum DataType {
    case tag
    case priority
    case deadline
}

protocol RegisterViewControllerDelegate: AnyObject {
    func didAddNewTask() //등록한 추가를 바로 main뷰에 딜리게이트로 반영
}

class ToDoList: Object {
    @Persisted var taskId: String = UUID().uuidString
  //  @Persisted(primaryKey: true) var taskId: ObjectId // 고유 ID
    @Persisted var taskTitle: String = ""
    @Persisted var taskContent: String?
    @Persisted var taskDeadline: Date?
    @Persisted var taskPriority: String = ""
    @Persisted var taskTag: String = ""
   // @Persisted var taskImage: Data?
    @Persisted var taskImagePath: String?
    @Persisted var detail88: List<DetailTodo> // 여러 개의 DetailTodo
    
    override static func primaryKey() -> String? {
        return "taskId"
    }
    
    convenience init(taskTitle: String, taskContent: String? = nil, taskDeadline: Date? = nil, taskPriority: String = "", taskTag: String = "", taskImage: Data? = nil) {
        self.init()
        self.taskTitle = taskTitle
        self.taskContent = taskContent
        self.taskDeadline = taskDeadline
        self.taskPriority = taskPriority
        self.taskTag = taskTag
        self.taskImagePath = taskImagePath
    }
}


class DetailTodo: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var todo: String // 세부 할 일 내용
    @Persisted var deadline: Date // 마감 날짜
    @Persisted var regDate: Date // 등록 날짜

    // 초기화 메서드
    convenience init(todo: String, deadline: Date) {
        self.init()
        self.todo = todo
        self.deadline = deadline
        self.regDate = Date()
    }
}



class DatabaseManager {
    let database = try! Realm()
    
    func remove(_ task: ToDoList) {
        try! database.write {
            database.delete(task)
        }
    }
}

