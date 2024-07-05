//
//  MainHomeViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

class MainHomeViewController: UIViewController {
    
    let titleLabel: UILabel = {
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
    
    private var collectionView: UICollectionView!
    private let realmDb = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(newTaskButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainListCell.self, forCellWithReuseIdentifier: MainListCell.identifier)
        
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(newTaskButton.snp.top).offset(-20)
        }

        newTaskButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
    }
    
    @objc func registerButtonTapped() {
        let registerVC = RegisterViewController()
        let navController = UINavigationController(rootViewController: registerVC)
        self.present(navController, animated: true, completion: nil)
    }
   
    private func fetchCount(for filter: String) -> Int {
        switch filter {
        case "오늘":
            return realmDb.objects(Task.self).filter("taskDeadline <= %@", Date()).count
        case "예정":
            return realmDb.objects(Task.self).filter("taskDeadline > %@", Date()).count
        case "전체":
            return realmDb.objects(Task.self).count
        case "깃발 표시":
            return realmDb.objects(Task.self).filter("taskTag == '깃발'").count
        case "완료됨":
            return realmDb.objects(Task.self).filter("taskPriority == '완료'").count
        default:
            return 0
        }
    }
}

extension MainHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainListCell.identifier, for: indexPath) as! MainListCell
        
        let count: Int
        switch indexPath.item {
        case 0:
            count = fetchCount(for: "오늘")
            cell.configure(title: "오늘", count: "\(count)")
        case 1:
            count = fetchCount(for: "예정")
            cell.configure(title: "예정", count: "\(count)")
        case 2:
            count = fetchCount(for: "전체")
            cell.configure(title: "전체", count: "\(count)")
        case 3:
            count = fetchCount(for: "깃발 표시")
            cell.configure(title: "깃발 표시", count: "\(count)")
        case 4:
            count = fetchCount(for: "완료됨")
            cell.configure(title: "완료됨", count: "\(count)")
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter: String
        
        switch indexPath.item {
        case 0:
            filter = "오늘"
        case 1:
            filter = "예정"
        case 2:
            filter = "전체"
        case 3:
            filter = "깃발 표시"
        case 4:
            filter = "완료됨"
        default:
            return
        }
        
        let toDoListVC = ToDoListViewController()
        toDoListVC.filter = filter
        self.navigationController?.pushViewController(toDoListVC, animated: true)
    }
}
