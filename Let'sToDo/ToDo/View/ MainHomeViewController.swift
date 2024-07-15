//
//  MainHomeViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/15/24.
//

import UIKit
import SnapKit
import RealmSwift

final class MainHomeViewController: UIViewController, Base {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "전체"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let newTaskButton = UIBarButtonItem(title: "새로운 할일", style: .plain, target: self, action: #selector(registerButtonTapped))
        let addFolderButton = UIBarButtonItem(title: "목록 추가", style: .plain, target: self, action: #selector(addFolderButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([newTaskButton, flexibleSpace, addFolderButton], animated: false)
        return toolbar
    }()
    
    lazy var collectionView: UICollectionView = {
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
    
    let realmDb = try! Realm()
    
    var folder: Folder?
    
    let toDoListRepository = ToDoListRepository()
    weak var delegate: FilterSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        configureView()
        
        print("램 파일 경로-> \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(toolbar)
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
            make.height.equalTo(250)
        }
        
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
}
