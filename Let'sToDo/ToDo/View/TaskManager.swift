//
//  TaskManager.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import RealmSwift

class Task: Object {
    @Persisted var taskId: String = UUID().uuidString
    @Persisted var taskTitle: String = ""
    @Persisted var taskContent: String?
    @Persisted var taskDeadline: Date?
    @Persisted var taskPriority: String = ""
    @Persisted var taskTag: String = ""
    
    override static func primaryKey() -> String? {
        return "taskId"
    }
    
    convenience init(taskTitle: String, taskContent: String? = nil, taskDeadline: Date? = nil, taskPriority: String = "", taskTag: String = "") {
        self.init()
        self.taskTitle = taskTitle
        self.taskContent = taskContent
        self.taskDeadline = taskDeadline
        self.taskPriority = taskPriority
        self.taskTag = taskTag
    }
}

class DatabaseManager {
    let database = try! Realm()
    
    func remove(_ task: Task) {
        try! database.write {
            database.delete(task)
        }
    }
}
