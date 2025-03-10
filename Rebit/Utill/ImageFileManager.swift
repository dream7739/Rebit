//
//  ImageFileManager.swift
//  Rebit
//
//  Created by 홍정민 on 9/19/24.
//

import SwiftUI

enum FileError: Error {
    // save
    case documentNotFound
    case downloadFailed
    case convertImageFailed
    case writeFailed
    
    // read
    case fileNotFound
    
    // delete
    case deleteFailed
}

final class ImageFileManager {
    static let shared = ImageFileManager()
    private init() { }
    
    func saveImageToDocument(path: String, filename: String) async throws  {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { throw FileError.documentNotFound }
        
        guard let url = URL(string: path), let data = try? Data(contentsOf: url) else {
            throw FileError.downloadFailed
        }
        
        guard let image = UIImage(data: data), let compressImage = image.jpegData(compressionQuality: 0.5) else {
            throw FileError.convertImageFailed
        }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        guard let _ = try? compressImage.write(to: fileURL) else {
            throw FileError.writeFailed
        }
    }
    
    func loadImageToDocument(filename: String) throws -> UIImage {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { throw FileError.documentNotFound }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        guard FileManager.default.fileExists(atPath: fileURL.path()), let image = UIImage(contentsOfFile: fileURL.path()) else  {
            throw FileError.fileNotFound
        }
        
        return image
    }
    
    func removeImageFromDocument(filename: String) throws {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path())
            } catch {
                throw FileError.deleteFailed
            }
        } else {
            throw FileError.fileNotFound
        }
    }
}
