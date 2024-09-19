//
//  ImageFileManager.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI

final class ImageFileManager {
    static let shared = ImageFileManager()
    private init() { }
    
    func saveImageToDocument(path: String, filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        guard let url = URL(string: path) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                guard let data = image.jpegData(compressionQuality: 0.5) else { return }
                let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")

                do {
                    try data.write(to: fileURL)
                } catch {
                    print("file save error", error)
                }
            }
        }
        
    }
    
    func loadImageToDocument(filename: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return nil
        }
        
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            
            do {
                try FileManager.default.removeItem(atPath: fileURL.path())
            } catch {
                print("file remove error", error)
            }
            
        } else {
            print("file no exist")
        }
        
    }
}
