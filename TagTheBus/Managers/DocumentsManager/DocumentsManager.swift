//
//  DocumentsManager.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit

class DocumentsManager: NSObject {
    
    static func save(image: UIImage, with name: String) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        let fileURL = documentsDirectory.appendingPathComponent(name)
        let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
        if let data = image.jpegData(compressionQuality:  1.0), !fileExists {
            do {
                try data.write(to: fileURL)
                return true
            } catch {
                print("error saving file:", error)
            }
        }
        return false
    }
    
    
    static func loadImage(with name: String) -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
            let image = UIImage(contentsOfFile: imageURL.path)
            return image
        }
        return nil
    }
    
    static func fileUrl(from name: String) -> URL? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first {
            let url = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
            return url
        }
        return nil
    }
    
    static func deleteFile(for name: String) {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first {
            let fileManager = FileManager.default
            if name.count > 0 {
                let url = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
                do {
                    try fileManager.removeItem(at: url)
                } catch {
                    print("error while deleting file -> \(name)")
                }
            }
        }
    }
    
}
