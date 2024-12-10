//
//  FileSystemViewModel.swift
//  FileManager
//
//  Created by KOДИ on 10.12.2024.
//

import Foundation
import Combine

class FileSystemViewModel {
    
    // MARK: - Input
    
    @Published var currentDirectory: URL?
    
    // MARK: - Output
    
    @Published private(set) var contents: [URL] = []
    @Published private(set) var isAtRootDirectory: Bool = true
    
    let fileManager: FileManagerAdapter
    let userManager: UserDefaultsManager
    private var cancellables = Set<AnyCancellable>()
    
    init(fileManager: FileManagerAdapter = FileManagerAdapter(),
         userManager: UserDefaultsManager = UserDefaultsManager.shared) {
        self.fileManager = fileManager
        self.userManager = userManager
        setupBindings()
    }
    
    private func setupBindings() {
        $currentDirectory
            .compactMap { $0 }
            .sink { [weak self] directory in
                self?.loadContents(in: directory)
                self?.updateRootDirectoryStatus(for: directory)
            }
            .store(in: &cancellables)
    }
    
    private func loadContents(in directory: URL) {
        contents = fileManager.loadContents(inDirectory: directory)
        sortContents()
    }
    
    private func sortContents() {
        contents.sort {
            let isDir0 = $0.hasDirectoryPath
            let isDir1 = $1.hasDirectoryPath
            if isDir0 == isDir1 {
                return $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending
            }
            return isDir0 && !isDir1
        }
    }
    
    private func updateRootDirectoryStatus(for directory: URL) {
        let rootDirectory = fileManager.showRootDirectoryContents()?.appendingPathComponent(userManager.getUsername() ?? "")
        isAtRootDirectory = directory == rootDirectory
    }
    
    func createFolder(named name: String) -> URL? {
        guard let currentDirectory = currentDirectory else { return nil }
        let newFolderURL = currentDirectory.appendingPathComponent(name, isDirectory: true)
        do {
            try fileManager.createDirectory(at: newFolderURL)
            loadContents(in: currentDirectory)
            return newFolderURL
        } catch {
            print("Error creating folder: \(error.localizedDescription)")
            return nil
        }
    }
    
    func createFile(named name: String, content: Data? = nil) -> URL? {
        guard let currentDirectory = currentDirectory else { return nil }
        let newFileURL = currentDirectory.appendingPathComponent(name)
        guard !fileManager.itemExists(atPath: newFileURL.path) else { return nil }
        fileManager.createFile(atPath: newFileURL.path, contents: content)
        loadContents(in: currentDirectory)
        return newFileURL
    }
    
    func deleteItem(at url: URL) {
        do {
            try fileManager.removeItem(at: url)
            if let directory = currentDirectory {
                loadContents(in: directory)
            }
        } catch {
            print("Error deleting item: \(error.localizedDescription)")
        }
    }
    
    func navigateBack() {
        guard let currentDirectory = currentDirectory else { return }
        self.currentDirectory = currentDirectory.deletingLastPathComponent()
    }
}
