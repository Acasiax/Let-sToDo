//
//  Repository.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/7/24.
//

import UIKit
import RealmSwift

final class ToDoListRepository {
    let realm = try! Realm()

    func readFolder(named name: String) -> Folder? {
        return realm.objects(Folder.self).filter("FolderName == %@", name).first
    }

    func readFolders(with folderFilter: String?, mainFilter: Filter? = nil) -> [Folder] {
        var predicate = NSPredicate(value: true)
        
        if let folderFilter = folderFilter {
            let folderPredicate = NSPredicate(format: "FolderName == %@", folderFilter)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, folderPredicate])
        }
        
        if let mainFilter = mainFilter {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, mainFilter.predicate])
        }
        
        return Array(realm.objects(Folder.self).filter(predicate))
    }

    func readAllFolders(mainFilter: Filter? = nil) -> [Folder] {
        if let mainFilter = mainFilter {
            return Array(realm.objects(Folder.self).filter(mainFilter.predicate))
        } else {
            return Array(realm.objects(Folder.self))
        }
    }

    func readFoldersSorted(by keyPath: String, ascending: Bool) -> [Folder] {
        let folders = realm.objects(Folder.self).sorted(byKeyPath: keyPath, ascending: ascending)
        return Array(folders)
    }
    func readToDoListsSorted(by keyPath: String, ascending: Bool) -> [ToDoList] {
           let tasks = realm.objects(ToDoList.self).sorted(byKeyPath: keyPath, ascending: ascending)
           return Array(tasks)
       }



    func createItem(_ data: ToDoList, folder: Folder) {
        do {
            try realm.write {
                folder.detail88.append(data)
                print("saved!")
            }
        } catch {
            print("save error")
        }
    }

    func createFolder(_ folder: Folder) {
        do {
            try realm.write {
                realm.add(folder)
                print("폴더 저장됨: \(folder.FolderName)")
            }
        } catch {
            print("폴더 저장 실패: \(error)")
        }
    }

    func readAllItems() -> [ToDoList] {
        let result = realm.objects(ToDoList.self).sorted(byKeyPath: "taskTitle", ascending: true)
        return Array(result)
    }

    func readItemsSorted(by keyPath: String, ascending: Bool) -> [ToDoList] {
        let result = realm.objects(ToDoList.self).sorted(byKeyPath: keyPath, ascending: ascending)
        return Array(result)
    }

    func readItemsSortedAndFiltered(by keyPath: String, ascending: Bool, filter: String) -> [ToDoList] {
        let result = realm.objects(ToDoList.self).filter(filter).sorted(byKeyPath: keyPath, ascending: ascending)
        return Array(result)
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

    func fetchCount(for filter: Filter) -> Int {
        return realm.objects(ToDoList.self).filter(filter.predicate).count
    }

    func fetchFolderCount(for folderFilter: FolderFilter, with mainFilter: Filter?) -> Int {
        var predicate = folderFilter.predicate
        if let mainFilter = mainFilter {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mainFilter.predicate, folderFilter.predicate])
        }
        return realm.objects(ToDoList.self).filter(predicate).count
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

    func fetchTasks(folderFilter: String, mainFilter: Filter) -> [ToDoList] {
        let folderPredicate = NSPredicate(format: "taskCategory == %@", folderFilter)
        let mainPredicate = mainFilter.predicate
        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, mainPredicate])
        return Array(realm.objects(ToDoList.self).filter(combinedPredicate))
    }
}

extension Filter {
    var predicate: NSPredicate {
        switch self {
        case .today:
            return NSPredicate(format: "taskDeadline <= %@", Calendar.current.startOfDay(for: Date()) as NSDate)
        case .upcoming:
            return NSPredicate(format: "taskDeadline > %@", Calendar.current.startOfDay(for: Date()) as NSDate)
        case .all:
            return NSPredicate(value: true)
        case .flagged:
            return NSPredicate(format: "taskTag == '깃발'")
        case .completed:
            return NSPredicate(format: "taskPriority == '완료'")
        }
    }
}

extension FolderFilter {
    var predicate: NSPredicate {
        switch self {
        case .travel:
            return NSPredicate(format: "taskCategory == %@", "여행")
        case .healthCare:
            return NSPredicate(format: "taskCategory == %@", "건강관리")
        case .all:
            return NSPredicate(value: true)
        case .financeManagement:
            return NSPredicate(format: "taskCategory == %@", "재정관리")
        case .selfDevelopment:
            return NSPredicate(format: "taskCategory == %@", "자기계발")
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
