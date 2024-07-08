//
//  TaskManager.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import RealmSwift


class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var FolderName: String // 세부 할 일 내용
    @Persisted var deadline: Date // 마감 날짜
    @Persisted var regDate: Date // 등록 날짜

    @Persisted var detail88: List<Folder> // 여러 개의 DetailTodo
    
    
    // 초기화 메서드
    convenience init(todo: String, deadline: Date) {
        self.init()
        self.FolderName = todo
        self.deadline = deadline
        self.regDate = Date()
    }
}

class ToDoList: Object {
  //  @Persisted var taskId: String = UUID().uuidString
    @Persisted(primaryKey: true) var taskId: ObjectId // 고유 ID
    @Persisted var taskTitle: String = ""
    @Persisted var taskContent: String?
    @Persisted var taskDeadline: Date?
    @Persisted var taskPriority: String = ""
    @Persisted var taskTag: String = ""
    @Persisted var taskImagePath: String?
    
  //  @Persisted(originProperty: "detail88")
  //  var main: LinkingObjects<Folder> //참고용 데이터이지 실제로 저장하는 거는 아님 //역관계 확인 //단순히 명세만 해주는 거라서 변경이 된게 아니기 때문에 마이그레이션 안해도 됨
    
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





class DatabaseManager {
    let database = try! Realm()
    
    func remove(_ task: ToDoList) {
        try! database.write {
            database.delete(task)
        }
    }
}

