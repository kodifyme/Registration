//
//  FileSystemManager.swift
//  Registration
//
//  Created by KOДИ on 28.02.2024.
//

import Foundation

protocol FileSystemService {
    func createDirectory(at url: URL) throws
    func createDirectory(for user: User) throws
    func showRootDirectoryContents() -> URL?
    func loadContents(inDirectory directory: URL) -> [URL]
    func removeItem(at url: URL) throws
    func loadTextFromFile(at url: URL) -> String?
    func saveTextToFile(text: Data, at url: URL)
    func createFile(atPath: String, contents: Data?)
    func directoryExists(at url: URL) -> Bool
    func itemExists(atPath path: String) -> Bool
}

class FileManagerAdapter: FileSystemService {
    
    private let fileManager: FileManager
    
    private var documentURL: URL? {
        try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func createDirectory(at url: URL) throws {
        let createIntermediates = false
        let attributes: [FileAttributeKey : Any]? = nil
        try fileManager.createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: attributes)
    }
    
    func createDirectory(for user: User) throws {
        guard let documentURL else { return }
        let userDirectoryURL = documentURL.appendingPathComponent(user.userID)
        if !fileManager.fileExists(atPath: userDirectoryURL.path) {
            try fileManager.createDirectory(at: userDirectoryURL, withIntermediateDirectories: true)
        }
    }
    
    func showRootDirectoryContents() -> URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func loadContents(inDirectory directory: URL) -> [URL] {
        do {
            let contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            return contents
        } catch {
            print("Error loading contents: \(error.localizedDescription)")
            return []
        }
    }
    
    func removeItem(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }
    
    func loadTextFromFile(at url: URL) -> String? {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            return text
        } catch {
            print("Ошибка при загрузке текста: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveTextToFile(text: Data, at url: URL) {
        do {
            try text.write(to: url, options: .atomic)
            print("Текст записан")
        } catch {
            print("Ошибка при записи текста: \(error.localizedDescription)")
        }
    }
    
    func createFile(atPath: String, contents: Data?) {
        fileManager.createFile(atPath: atPath, contents: contents)
    }
    
    func itemExists(atPath path: String) -> Bool {
        fileManager.fileExists(atPath: path)
    }
    
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        } else {
            return false
        }
    }
}
