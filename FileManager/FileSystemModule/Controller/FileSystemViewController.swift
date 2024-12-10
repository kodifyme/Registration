//
//  FileSystemViewController.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import UIKit
import Combine

class FileSystemViewController: UIViewController {
    
    private let viewModel = FileSystemViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var fileSystemView: FileSystemView = {
        let view = FileSystemView()
        view.fileSystemViewdelegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
        setupNavigationBar()
        setupConstraints()
        
        // Установка начальной директории
        guard let rootDirectory = viewModel.fileManager.showRootDirectoryContents()?.appendingPathComponent(viewModel.userManager.getUsername() ?? "") else { return }
        viewModel.currentDirectory = rootDirectory
    }
    
    private func setupViews() {
        view.addSubview(fileSystemView)
    }
    
    private func setupBindings() {
        viewModel.$contents
            .receive(on: RunLoop.main)
            .sink { [weak self] contents in
                self?.fileSystemView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isAtRootDirectory
            .receive(on: RunLoop.main)
            .sink { [weak self] isAtRoot in
                self?.updateLeftBarButtonItem(isAtRoot: isAtRoot)
            }
            .store(in: &cancellables)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "folder"), style: .done, target: self, action: #selector(addFolderButtonTapped)),
            UIBarButtonItem(image: UIImage(systemName: "doc.text"), style: .done, target: self, action: #selector(addFileButtonTapped))
        ]
    }
    
    private func updateLeftBarButtonItem(isAtRoot: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: isAtRoot ? "Выход" : "Назад",
            style: .plain,
            target: self,
            action: isAtRoot ? #selector(logoutButtonTapped) : #selector(backButtonTapped)
        )
    }
    
    @objc private func addFolderButtonTapped() {
        AlertManager.shared.showFolderCreationAlert(from: self) { [weak self] folderName in
            guard let folderName, !folderName.isEmpty else { return }
            _ = self?.viewModel.createFolder(named: folderName)
        }
    }
    
    @objc private func addFileButtonTapped() {
        AlertManager.shared.showFileCreationAlert(from: self) { [weak self] fileName in
            guard let fileName, !fileName.isEmpty else { return }
            _ = self?.viewModel.createFile(named: fileName, content: "".data(using: .utf8))
        }
    }
    
    @objc private func logoutButtonTapped() {
        viewModel.userManager.setLoginStatus(isLoggedIn: false)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        viewModel.navigateBack()
    }
}

//MARK: - FileSystemViewDelegate

extension FileSystemViewController: FileSystemViewDelegate {
    
    func didSelectDirectory(at indexPath: IndexPath) {
        guard let directory = viewModel.contents[safe: indexPath.row] else { return }
        viewModel.currentDirectory = directory
    }
    
    func deleteItem(at indexPath: IndexPath) {
        guard let item = viewModel.contents[safe: indexPath.row] else { return }
        viewModel.deleteItem(at: item)
    }
    
    func didSelectFile(at url: URL) {
        let message = viewModel.fileManager.loadTextFromFile(at: url)
        AlertManager.shared.showTextInsideFileAlert(from: self, at: url, message: message) { text in
            if let text = text {
                self.viewModel.fileManager.saveTextToFile(text: text, at: url)
            }
        }
    }
}

//MARK: - Constraints

private extension FileSystemViewController {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            fileSystemView.topAnchor.constraint(equalTo: view.topAnchor),
            fileSystemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fileSystemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fileSystemView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
