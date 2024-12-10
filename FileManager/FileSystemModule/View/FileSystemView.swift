//
//  FileSystemView.swift
//  FileManager
//
//  Created by KOДИ on 18.03.2024.
//

import UIKit

protocol FileSystemViewDelegate: AnyObject {
    func didSelectFile(at url: URL)
    func deleteItem(at indexPath: IndexPath)
    func didSelectDirectory(at indexPath: IndexPath)
}

class FileSystemView: UITableView {
    
    private let cellIdentifier = "Cell"
    weak var fileSystemViewdelegate: FileSystemViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .insetGrouped)
        setupTableView()
    }
    
    private func setupTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITableViewDataSource
extension FileSystemView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FileSystemView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        fileSystemViewdelegate?.didSelectDirectory(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileSystemViewdelegate?.deleteItem(at: indexPath)
        }
    }
}
