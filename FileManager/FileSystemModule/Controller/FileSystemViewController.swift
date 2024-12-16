//
//  FileSystemViewController.swift
//  Registration
//
//  Created by KOДИ on 20.02.2024.
//

import UIKit
import Combine

class FileSystemViewController: UIViewController {
    
    private lazy var fileSystemView = FileSystemView()
    private let viewModel = FileSystemViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        self.view = fileSystemView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "folder"),
                style: .done,
                target: self,
                action: #selector(addFolderButtonTapped)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "doc.text"),
                style: .done,
                target: self,
                action: #selector(addFileButtonTapped)
            )
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

// MARK: - Bind ViewModel

private extension FileSystemViewController {
    
    func bindViewModel() {
       
    }
}
