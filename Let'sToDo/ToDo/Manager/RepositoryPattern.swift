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
    
    // 정렬된 항목들을 읽어오는 메서드
    func readItemsSorted(by keyPath: String, ascending: Bool) -> [ToDoList] {
        let result = realm.objects(ToDoList.self).sorted(byKeyPath: keyPath, ascending: ascending)
        return Array(result)
    }

    // 필터와 정렬 조건을 사용하여 항목들을 읽어오는 메서드
    func readItemsSortedAndFiltered(by keyPath: String, ascending: Bool, filter: String) -> [ToDoList] {
        let result = realm.objects(ToDoList.self).filter(filter).sorted(byKeyPath: keyPath, ascending: ascending)
        return Array(result)
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
    
    // 특정 폴더 필터에 따른 항목 수를 가져오는 메서드
    // - 필터 조건에 따라 항목 수를 반환
    func fetchFolderCount(for filter: MainHomeViewController.FolderFilter) -> Int {
        switch filter {
        case .travel:
            return realm.objects(ToDoList.self).filter("taskCategory == '여행'").count
        case .healthCare:
            return realm.objects(ToDoList.self).filter("taskCategory == '건강관리'").count
        case .all:
            return realm.objects(ToDoList.self).count
        case .financeManagement:
            return realm.objects(ToDoList.self).filter("taskCategory == '재정관리'").count
        case .selfDevelopment:
            return realm.objects(ToDoList.self).filter("taskCategory == '자기계발'").count
        }
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

    // 폴더 필터를 사용하여 항목을 읽어오는 메서드
    // - 폴더 필터 조건에 따라 다른 항목들을 반환
    func readFolderItems(with filter: String?) -> [ToDoList] {
        if let filter = filter {
            switch filter {
            case "여행":
                return Array(realm.objects(ToDoList.self).filter("taskCategory == '여행'"))
            case "건강관리":
                return Array(realm.objects(ToDoList.self).filter("taskCategory == '건강관리'"))
            case "전체":
                return Array(realm.objects(ToDoList.self))
            case "재정관리":
                return Array(realm.objects(ToDoList.self).filter("taskCategory == '재정관리'"))
            case "자기계발":
                return Array(realm.objects(ToDoList.self).filter("taskCategory == '자기계발'"))
            default:
                return Array(realm.objects(ToDoList.self))
            }
        } else {
            return Array(realm.objects(ToDoList.self))
        }
    }

}


/*
 데이터 업데이트
 Results<ToDoList>는 Realm 객체 컬렉션 타입으로, 실시간 갱신을 지원하여 데이터베이스가 변경될 때 자동으로 업데이트됨.반면, [ToDoList]는 일반 배열로, 데이터베이스 변경 시 자동으로 업데이트되지 않습니다. 따라서 배열을 사용할 경우 데이터가 변경될 때마다 수동으로 업데이트를 해줘야 함!.
 
 //하나의 아이템 값 수정
 try! realm.write {
     realm.create(ToDoList.self, value: ["id": item.id, "money": 1000000], update: .modified)
 }

 
 //전체 아이템 값 수정
 let result = realm.objects(ToDoList.self)
 try! realm.write {
     result.setValue(true, forKey: "isLike")
 }

 
 //필터링
 let filteredList = realm.objects(ToDoList.self).where {
     $0.title.contains(searchText)
 }
 list = filteredList
 tableView.reloadData()

*/
