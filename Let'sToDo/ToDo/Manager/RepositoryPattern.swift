//
//  Repository.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/7/24.
//

import UIKit
import RealmSwift

// Repository 패턴
// - 대체로 사용하는 '테이블+Repository'를 이름으로
final class ToDoListRepository {
    private let realm = try! Realm()
    
    // 데이터를 생성하는 메서드
    // - 데이터 객체를 매개변수로 받아서 Realm 데이터베이스에 추가
    func createItem(_ data: ToDoList) {
        do {
            try realm.write {
                realm.add(data)
                print("saved!")  // 저장 성공 메시지 출력
            }
        } catch {
            print("save error")  // 저장 실패 시 에러 메시지 출력
        }
    }
    
    // 모든 항목을 읽어오는 메서드
    // - taskTitle 기준으로 오름차순 정렬하여 반환
    func readAllItems() -> [ToDoList] {
        let result = realm.objects(ToDoList.self).sorted(byKeyPath: "taskTitle", ascending: true)
        return Array(result)
    }
    
    // 필터를 사용하여 항목을 읽어오는 메서드
    // - 필터 조건에 따라 다른 항목들을 반환
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
    
    // 항목을 삭제하는 메서드
    // - 데이터 객체를 매개변수로 받아서 Realm 데이터베이스에서 삭제
    func deleteItem(_ data: ToDoList) {
        do {
            try realm.write {
                realm.delete(data)
                print("deleted")  // 삭제 성공 메시지 출력
            }
        } catch {
            print("delete error")  // 삭제 실패 시 에러 메시지 출력
        }
    }
    
    // 특정 필터에 따른 항목 수를 가져오는 메서드
    // - 필터 조건에 따라 항목 수를 반환
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
