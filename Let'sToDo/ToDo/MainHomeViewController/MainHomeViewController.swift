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

    private let realmDb = try! Realm()

    private enum Filter: String, CaseIterable {
        case today = "오늘"
        case upcoming = "예정"
        case all = "전체"
        case flagged = "깃발 표시"
        case completed = "완료됨"

        var title: String {
            return self.rawValue
        }
    }

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
    }

    override func configureView() {
        view.backgroundColor = .systemBackground
    }

    override func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(newTaskButton)
        view.addSubview(collectionView)
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
        switch filter {
        case .today:
            return realmDb.objects(ToDoList.self).filter("taskDeadline <= %@", Date()).count
        case .upcoming:
            return realmDb.objects(ToDoList.self).filter("taskDeadline > %@", Date()).count
        case .all:
            return realmDb.objects(ToDoList.self).count
        case .flagged:
            return realmDb.objects(ToDoList.self).filter("taskTag == '깃발'").count
        case .completed:
            return realmDb.objects(ToDoList.self).filter("taskPriority == '완료'").count
        }
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
        let filter = Filter.allCases[indexPath.item]

        let toDoListVC = ToDoListViewController()
        toDoListVC.filter = filter.title
        self.navigationController?.pushViewController(toDoListVC, animated: true)
    }
}

extension MainHomeViewController: RegisterViewControllerDelegate {
    func didAddNewTask() {
        collectionView.reloadData()
        self.view.makeToast("새로운 일정이 저장되었습니다.")
    }
}
