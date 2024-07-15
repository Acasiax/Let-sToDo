//
//  TaskManager.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import RealmSwift

class Memo: EmbeddedObject {
    @Persisted var content: String
    @Persisted var regDate: Date
    @Persisted var editDate: Date
}


class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var FolderName: String // 세부 할 일 내용
    @Persisted var optionDescription: String
    @Persisted var regDate: Date // 등록 날짜
    // 1:n to many relationship
    @Persisted var detail88: List<ToDoList> // 여러 개의 DetailTodo
    
    //to one relationship 테이블 같은 건데 테이블은 아님
    @Persisted var meno: Memo?
    
    
    // 초기화 메서드
    convenience init(todo: String, optionDescription: String) {
        self.init()
        self.FolderName = todo
        self.optionDescription = optionDescription
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
    @Persisted var taskCategory: String = ""
    
    @Persisted(originProperty: "detail88")
    var main: LinkingObjects<Folder> //참고용 데이터이지 실제로 저장하는 거는 아님 //역관계 확인 //단순히 명세만 해주는 거라서 변경이 된게 아니기 때문에 마이그레이션 안해도 됨
    
    override static func primaryKey() -> String? {
        return "taskId"
    }
    
    convenience init(taskTitle: String, taskContent: String? = nil, taskDeadline: Date? = nil, taskPriority: String = "", taskTag: String = "", taskImagePath: String? = nil, taskCategory: String = "") {
            self.init()
            self.taskTitle = taskTitle
            self.taskContent = taskContent
            self.taskDeadline = taskDeadline
            self.taskPriority = taskPriority
            self.taskTag = taskTag
            self.taskImagePath = taskImagePath
            self.taskCategory = taskCategory
        }
}



class DatabaseManager {
    let database = try! Realm()
    
    func remove(_ task: ToDoList) {
        try! database.write {
            if let imageName = task.taskImagePath {
                self.removeImageFromDocument(filename: imageName)
            }
            database.delete(task)
        }
    }
    
    //📍
    func remove(_ folder: Folder) {
        try! database.write {
            // 폴더 내의 모든 ToDoList 항목과 연관된 이미지도 삭제
            for task in folder.detail88 {
                if let imageName = task.taskImagePath {
                    self.removeImageFromDocument(filename: imageName)
                }
            }
            database.delete(folder.detail88)
            database.delete(folder)
        }
    }
    
    // Documents 디렉토리에서 이미지를 삭제하는 함수
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }

        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("파일 삭제 오류:", error)
            }
        } else {
            print("파일이 존재하지 않음")
        }
    }
}

