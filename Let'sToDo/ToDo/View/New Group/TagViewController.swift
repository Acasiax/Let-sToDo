//
//  TagViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/3/24.
//

import UIKit
import SnapKit
import Toast

protocol TagDataDelegate {
    func passTagData(_ tag: String)
}


class TagViewController: UIViewController {
    
    var delegate: TagDataDelegate?
    
    let showTagButton = UIButton()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "태그를 입력하세요"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "태그 입력"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.shadowColor = UIColor.gray.cgColor
        tf.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tf.layer.shadowOpacity = 0.5
        tf.layer.shadowRadius = 4.0
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        setupConstraints()
        setupStyle()
        setupNavigationBar()
    }
    
    func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
        }
    }
    
    func setupStyle() {
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        textField.placeholder = "태그 입력"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowRadius = 4.0
    }
    
    func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        let enteredText = textField.text ?? "미작성"
       // print("작성한 태그: \(enteredText)")
        delegate?.passTagData(enteredText)
       
        navigationController?.popViewController(animated: true)
    }
}


//
//extension TagViewController: TagDataDelegate {
//    func passTagData(_ tag: String) {
//        print("전달받은 태그: \(tag)")
//        showTagButton.setTitle(tag, for: .normal)
//    }
//    
//    
//}
