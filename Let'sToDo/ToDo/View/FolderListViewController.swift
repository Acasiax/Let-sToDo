//
//  FolderListViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/15/24.
//

import UIKit
import SnapKit

class FolderListViewController: UIViewController {
    var selectedFilter: Filter?
    weak var delegate: FilterSelectionDelegate?
    
    private let folderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "폴더"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var folderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainFolderListCell.self, forCellWithReuseIdentifier: MainFolderListCell.identifier)
        return collectionView
    }()
    
    private let toDoListRepository = ToDoListRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
        
        if let filter = selectedFilter {
            folderTitleLabel.text = "\(filter.title) 폴더"
        }
    }

    private func setupHierarchy() {
        view.addSubview(folderTitleLabel)
        view.addSubview(folderCollectionView)
    }

    private func setupConstraints() {
        folderTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        folderCollectionView.snp.makeConstraints { make in
            make.top.equalTo(folderTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func didSelectFilter(title: String) {
        folderTitleLabel.text = "\(title) 폴더"
    }
}

extension FolderListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FolderFilter.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainFolderListCell.identifier, for: indexPath) as! MainFolderListCell

        let folderFilter = FolderFilter.allCases[indexPath.item]
        let count = toDoListRepository.fetchFolderCount(for: folderFilter, with: selectedFilter)
        cell.configure(title: folderFilter.title, count: "\(count)")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let folderFilter = FolderFilter.allCases[indexPath.item]
        let toDoListVC = ToDoListViewController()
        toDoListVC.folderFilter = folderFilter.title
        toDoListVC.mainFilter = selectedFilter
        self.navigationController?.pushViewController(toDoListVC, animated: true)
    }
}
