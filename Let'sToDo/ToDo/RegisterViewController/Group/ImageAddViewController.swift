//
//  ImageAddViewController.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/3/24.
//

import UIKit
import PhotosUI
import SnapKit
//인포 설정해야됨
class ImageAddViewController: UIViewController, PHPickerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presentImagePicker()  // 뷰가 로드될 때 이미지 선택기 표시
    }
    
    private func presentImagePicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
            guard let self = self else { return }
            if let image = reading as? UIImage {
                DispatchQueue.main.async {
                    // 이미지를 사용하세요
                    self.handleSelectedImage(image)
                }
            }
        }
    }
    
    private func handleSelectedImage(_ image: UIImage) {
        // 이미지 사용 예: 이미지 저장 또는 프린트
        print("이미지 선택됨: \(image)")
        
        // 이미지 저장
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        
        // 이미지 프린트
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .photo
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printingItem = image
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
               NotificationCenter.default.post(name: .didSelectImage, object: imageData)
           }
        printController.present(animated: true, completionHandler: nil)
    }
    
    @objc private func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // 저장 실패
            print("사진 저장 실패: \(error.localizedDescription)")
        } else {
            // 저장 성공
            print("사진 저장 성공")
        }
    }
}
