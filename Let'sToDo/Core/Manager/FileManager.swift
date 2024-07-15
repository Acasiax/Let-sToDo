//
//  FileManager.swift
//  Let'sToDo
//
//  Created by 이윤지 on 7/6/24.
//

import UIKit

extension UIViewController {
    // 이미지를 Documents 디렉토리에 저장하는 함수
    func saveImageToDocument(image: UIImage, filename: String) {
        // 사용자의 도큐먼트 디렉토리 URL을 가져오기
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        // 이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 이미지를 JPEG 형식으로 압축 (압축 품질: 0.5)
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 이미지를 파일로 저장
        do {
            try data.write(to: fileURL)
        } catch {
            // 파일 저장 실패 시 오류 메시지 출력
            print("파일 저장 오류:", error)
        }
    }
    
    // Documents 디렉토리에서 이미지를 불러오는 함수
    func loadImageToDocument(filename: String) -> UIImage? {
        // 사용자의 도큐먼트 디렉토리 URL을 가져오기
        guard let documentDirectory = FileManager.default.urls(
               for: .documentDirectory,
               in: .userDomainMask).first else { return nil }
        
        // 파일 경로 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 해당 경로에 파일이 존재하는지 확인
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // 파일이 존재하면 이미지를 불러와 반환
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            // 파일이 없을 경우 기본 이미지 반환
            return UIImage(systemName: "star.fill")
        }
    }
    
    // Documents 디렉토리에서 이미지를 삭제하는 함수
    func removeImageFromDocument(filename: String) {
        // 사용자의 도큐먼트 디렉토리 URL을 가져오기
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }

        // 파일 경로 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 파일이 존재하는지 확인
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // 파일 매니저에서 이미지를 삭제
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                // 파일 삭제 실패 시 오류 메시지 출력
                print("파일 삭제 오류:", error)
            }
        } else {
            // 파일이 존재하지 않음을 알림
            print("파일이 존재하지 않음")
        }
    }
}
