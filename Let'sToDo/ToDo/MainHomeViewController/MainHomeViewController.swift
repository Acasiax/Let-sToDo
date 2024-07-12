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
    
    var folder: Folder?
   // var list:
    
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

//    override func setupConstraints() {
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
//        }
//
//        newTaskButton.snp.makeConstraints { make in
//            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
//            make.height.equalTo(50)
//            make.width.equalTo(150)
//        }
//
//        collectionView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(20)
//            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
//            make.height.equalTo(view.frame.height * 0.4)
//        }
//        
//        folderCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(collectionView.snp.bottom).offset(5)
//            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
//            make.bottom.equalTo(newTaskButton.snp.top).offset(-20)
//        }
//    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        newTaskButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(50)
            $0.width.equalTo(150)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(view.frame.height * 0.4)
        }
        
        folderCollectionView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(5)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(newTaskButton.snp.top).offset(-20)
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
            toDoListVC.folderFilter = folderFilter.title
           // toDoListVC.folder = selectedFolder //선택한 폴더 정보를 전달!
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



//MVVM 패턴과 옵저버 패턴에 대해 복습 정리하기
//2024년 7월 12일, 금요일
//
//오늘은 MVVM(Model-View-ViewModel) 패턴과 옵저버 패턴에 대해 공부하면서 느낀 점들을 정리해보기!
//    . 이 두 가지 패턴은 UI 개발에서 매우 중요한 역할을 하며, 특히 Swift를 사용한 iOS 개발에서 자주 사용된다.
//
// MVVM은 애플리케이션의 UI와 비즈니스 로직을 분리하기 위해 고안된 디자인 패턴이다. 세 가지 주요 구성 요소로 나뉜다.
//Model: 애플리케이션의 데이터와 비즈니스 로직을 담당한다. 데이터베이스, 웹 서비스, 로컬 데이터 저장소 등에서 데이터를 가져오거나 저장하는 기능을 수행한다.
//View: 사용자 인터페이스(UI) 요소를 나타내며, 사용자가 보는 화면을 담당한다. 버튼, 레이블, 텍스트 필드 등과 같은 UI 요소로 구성된다.
//ViewModel: View와 Model 사이의 중개자로서, Model에서 데이터를 가져와 가공하여 View에 제공한다. 또한, View에서 발생하는 사용자 입력을 처리하여 Model에 전달한다.
//
//옵저버 패턴은 객체 간의 일대다(one-to-many) 의존성을 정의하여 한 객체의 상태 변화가 다른 객체들에 통보될 수 있도록 하는 디자인 패턴이다. 주로 이벤트 기반 시스템에서 사용된다.
//
//Subject: 상태 변화를 통보할 객체다. 상태 변화가 발생하면 옵저버들에게 알림을 보낸다.
//Observer: 상태 변화를 통보받는 객체다. Subject로부터 알림을 받으면 적절한 작업을 수행한다.
//MVVM 패턴에서 옵저버 패턴은 주로 ViewModel과 View 사이의 데이터 바인딩에 사용된다. ViewModel의 데이터가 변경되면 이를 View에 자동으로 반영하기 위해 옵저버 패턴이 사용된다.
//
//Model: 애플리케이션의 데이터를 관리한다.
//ViewModel: Model의 데이터를 관찰하고, 이 데이터를 View에 제공하여 UI를 업데이트한다.
//View: ViewModel을 관찰(observe)하여 데이터가 변경될 때마다 UI를 업데이트한다.
