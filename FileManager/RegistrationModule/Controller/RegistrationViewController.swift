//
//  RegistrationViewController.swift
//  Registration
//
//  Created by KOДИ on 14.02.2024.
//

import UIKit
import Combine

class RegistrationViewController: UIViewController {
    
    private let viewModel = RegistrationViewModel()
    private lazy var registrationView = RegistrationView(viewModel: viewModel)
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(registrationView)
        registrationView.viewModel = viewModel
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            registrationView.topAnchor.constraint(equalTo: view.topAnchor),
            registrationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registrationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registrationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
