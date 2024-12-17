//
//  FileSystemView.swift
//  FileManager
//
//  Created by KOДИ on 18.03.2024.
//

import UIKit

class FileSystemView: UIView {
    
    private let cellIdentifier = "cell"
    
    private let tableView = UITableView(
        frame: .zero,
        style: .insetGrouped
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
        embedViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: - Embed Views

private extension FileSystemView {
    
    func embedViews() {
        [tableView].forEach { addSubview($0) }
    }
}

//MARK: - UITableViewDataSource

extension FileSystemView: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        )
        return cell
    }
}

//MARK: - UITableViewDelegate

extension FileSystemView: UITableViewDelegate {
    
}

//MARK: - Setup Layout

private extension FileSystemView {
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
