//
//  MainHomeViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/2/24.
//

import UIKit
import SnapKit

class MainHomeViewController: UIViewController {

    private let newTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새로운 할일", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(newTaskButton)
    }
    
    func setupConstraints() {
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

