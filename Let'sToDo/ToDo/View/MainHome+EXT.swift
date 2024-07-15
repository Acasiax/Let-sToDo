//
//  MainHome+EXT.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

extension MainHomeViewController: Base {
    
    @objc func addFolderButtonTapped() {
        let addFolderVC = AddFolderViewController()
        let navController = UINavigationController(rootViewController: addFolderVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func registerButtonTapped() {
        let registerVC = RegisterViewController()
        registerVC.delegate = self
        let navController = UINavigationController(rootViewController: registerVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    private func fetchCount(for filter: Filter) -> Int {
        return toDoListRepository.fetchCount(for: filter)
    }
    
    private func fetchFolderCount(for folderFilter: FolderFilter, with filter: Filter) -> Int {
        return toDoListRepository.fetchFolderCount(for: folderFilter, with: filter)
    }
    
}


extension MainHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Filter.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainListCell.identifier, for: indexPath) as! MainListCell
        
        let filter = Filter.allCases[indexPath.item]
        let count = fetchCount(for: filter)
        cell.configure(title: filter.title, count: "\(count)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let folderListVC = FolderListViewController()
        folderListVC.selectedFilter = Filter.allCases[indexPath.item]
        folderListVC.delegate = self
        self.navigationController?.pushViewController(folderListVC, animated: true)
        self.delegate?.didSelectFilter(title: Filter.allCases[indexPath.item].title)
    }
}




extension MainHomeViewController: RegisterViewControllerDelegate, FilterSelectionDelegate {
    func didAddNewTask() {
        collectionView.reloadData()
        self.view.makeToast("새로운 일정이 저장되었습니다.")
    }
    
    func didSelectFilter(title: String) {
        print("선택한 폴더: \(title)")
    }
}
