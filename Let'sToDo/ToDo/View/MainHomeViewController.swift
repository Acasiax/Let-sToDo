//
//  MainHomeViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import SnapKit

class MainHomeViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "전체"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
       // label.textAlignment = .center
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
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
   
}



extension MainHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainListCell.identifier, for: indexPath) as! MainListCell
        
        switch indexPath.item {
        case 0:
            cell.configure(title: "오늘", count: "0")
        case 1:
            cell.configure(title: "예정", count: "0")
        case 2:
            cell.configure(title: "전체", count: "1")
        case 3:
            cell.configure(title: "깃발 표시", count: "0")
        case 4:
            cell.configure(title: "완료됨", count: "0")
        default:
            break
        }
        
        return cell
    }
    
}


