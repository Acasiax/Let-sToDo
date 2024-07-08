//
//  MainHomeViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

final class MainHomeViewController: BaseViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "전체"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let newTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새로운 할일", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainListCell.self, forCellWithReuseIdentifier: MainListCell.identifier)
        return collectionView
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
    
    private let realmDb = try! Realm()

    enum Filter: String, CaseIterable {
        case today = "오늘"
        case upcoming = "예정"
        case all = "전체"
        case flagged = "깃발 표시"
        case completed = "완료됨"

        var title: String {
            return self.rawValue
        }
    }
    
    enum FolderFilter: String, CaseIterable {
        case travel = "여행"
        case healthCare = "건강관리"
        case all = "전체"
        case financeManagement = "재정관리"
        case selfDevelopment = "자기계발"

        var title: String {
            return self.rawValue
        }
    }

    
    private let toDoListRepository = ToDoListRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupHierarchy()
        setupConstraints()
        print("램 파일 경로-> \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        folderCollectionView.reloadData()
    }

    override func configureView() {
        view.backgroundColor = .systemBackground
    }

    override func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(newTaskButton)
        view.addSubview(collectionView)
        view.addSubview(folderCollectionView)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        newTaskButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(view.frame.height * 0.4)
        }
        
        folderCollectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(newTaskButton.snp.top).offset(-20)
        }
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
    
    private func fetchFolderCount(for folderFilter: FolderFilter) -> Int {
        return toDoListRepository.fetchFolderCount(for: folderFilter)
    }
}

extension MainHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return Filter.allCases.count
        } else {
            return FolderFilter.allCases.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainListCell.identifier, for: indexPath) as! MainListCell

            let filter = Filter.allCases[indexPath.item]
            let count = fetchCount(for: filter)
            cell.configure(title: filter.title, count: "\(count)")

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainFolderListCell.identifier, for: indexPath) as! MainFolderListCell

            let folderFilter = FolderFilter.allCases[indexPath.item]
            let count = fetchFolderCount(for: folderFilter)
            cell.configure(title: folderFilter.title, count: "\(count)")

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let filter = Filter.allCases[indexPath.item]

            let toDoListVC = ToDoListViewController()
            toDoListVC.filter = filter.title
            self.navigationController?.pushViewController(toDoListVC, animated: true)
        } else {
            // 폴더 선택 시 동작 설정
            let folderFilter = FolderFilter.allCases[indexPath.item]

            let toDoListVC = ToDoListViewController()
            toDoListVC.filter = folderFilter.title
            self.navigationController?.pushViewController(toDoListVC, animated: true)
        }
    }
}

extension MainHomeViewController: RegisterViewControllerDelegate {
    func didAddNewTask() {
        collectionView.reloadData()
        folderCollectionView.reloadData()
        self.view.makeToast("새로운 일정이 저장되었습니다.")
    }
}
