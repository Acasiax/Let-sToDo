//
//  AddFolderViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/15/24.
//

import UIKit
import SnapKit

final class AddFolderViewController: UIViewController {
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.bullet")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let folderNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "목록 이름"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .lightGray.withAlphaComponent(0.2)
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "목록 이름",
            attributes: [.font: UIFont.systemFont(ofSize: 20)]
        )
        return textField
    }()
    
    private let colors: [UIColor] = Colors.allCases.map { $0.color }
    private var selectedColorView: UIView?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        return collectionView
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTapped))
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
        setupConstraints()
        folderNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "새로운 목록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupUI() {
        view.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        view.addSubview(folderNameTextField)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        iconContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        folderNameTextField.snp.makeConstraints { make in
            make.top.equalTo(iconContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(folderNameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonTapped() {
        if let selectedColor = selectedColorView?.backgroundColor, let folderName = folderNameTextField.text {
            print("색상: \(selectedColor)")
            print("폴더이름: \(folderName)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            doneButton.isEnabled = true
            doneButton.tintColor = view.tintColor
        } else {
            doneButton.isEnabled = false
            doneButton.tintColor = .gray
        }
    }
    
    private func setSelectedColor(_ view: UIView) {
        selectedColorView?.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderColor = UIColor.gray.cgColor
        selectedColorView = view
        
        // 아이콘의 배경 색상을 선택된 색상으로 변경
        if let selectedColor = view.backgroundColor {
            iconContainerView.backgroundColor = selectedColor
        }
    }
}

extension AddFolderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.item]
        if let cell = collectionView.cellForItem(at: indexPath) {
            setSelectedColor(cell)
        }
    }
}

class ColorCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
