//
//  MainHomeViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import SnapKit
import RealmSwift

// MainHomeViewController
final class MainHomeViewController: BaseViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "전체"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let newTaskButton = UIBarButtonItem(title: "새로운 할일", style: .plain, target: self, action: #selector(registerButtonTapped))
        let addFolderButton = UIBarButtonItem(title: "목록 추가", style: .plain, target: self, action: #selector(addFolderButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([newTaskButton, flexibleSpace, addFolderButton], animated: false)
        return toolbar
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
    
    var folder: Folder?
   
    private let toDoListRepository = ToDoListRepository()
    weak var delegate: FilterSelectionDelegate?
    
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
        view.addSubview(collectionView)
        view.addSubview(toolbar)
    }

    override func setupConstraints() {
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
