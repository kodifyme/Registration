//
//  RegistrationView.swift
//  Registration
//
//  Created by KOДИ on 29.02.2024.
//

import UIKit
import Combine

class RegistrationView: UIView {
    // ViewModel
    var viewModel: RegistrationViewModel

    private var cancellables = Set<AnyCancellable>()

    //MARK: - Subviews
    private let titleLabel = UILabel(text: "Регистрация",
                                     font: .systemFont(ofSize: 30))

    let nameTextField = CustomTextField(placeholder: "Имя",
                                        keyBoardType: .default)
    let numberTextField = CustomTextField(placeholder: "Номер телефона",
                                          keyBoardType: .phonePad)
    let passwordTextField = CustomTextField(placeholder: "Пароль",
                                            keyBoardType: .default)

    private lazy var ageLabel: UILabel = {
        UILabel(text: "Возраст: \(Int(ageSlider.value))",
                font: .systemFont(ofSize: 18))
    }()

    private lazy var ageSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 6
        slider.maximumValue = 100
        slider.value = 6
        slider.minimumTrackTintColor = .blue
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private let genderSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Мужской", "Женский", "Другое"])
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()

    private let noticeLabel = UILabel(text: "Получать уведомление по смс",
                                      font: .italicSystemFont(ofSize: 17))

    private let noticeSwitch: UISwitch = {
        let noticeSwitch = UISwitch()
        noticeSwitch.isOn = true
        return noticeSwitch
    }()

    private lazy var screenObjectsStackView: UIStackView = {
        UIStackView(arrangedSubviews: [nameTextField, numberTextField, passwordTextField, ageLabel, ageSlider, genderSegmentControl, noticeStackView],
                    axis: .vertical,
                    spacing: 30)
    }()

    private lazy var noticeStackView: UIStackView = {
        UIStackView(arrangedSubviews: [noticeLabel, noticeSwitch],
                    axis: .horizontal,
                    spacing: 20)
    }()

    lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пропустить", for: .normal)
        button.setTitleColor(.systemBlue, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.configuration = .plain()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(viewModel: RegistrationViewModel) {
            self.viewModel = viewModel
            super.init(frame: .zero)
            setupAppearance()
            embedViews()
            setupConstraints()
            setupBindings()
        }
    
    

    //MARK: - Private Methods
    private func setupAppearance() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupBindings() {
        // Привязка текстовых полей к ViewModel
        nameTextField.textPublisher
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellables)

        numberTextField.textPublisher
            .assign(to: \.phoneNumber, on: viewModel)
            .store(in: &cancellables)

        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)

        // Привязка слайдера к ViewModel
        ageSlider.valuePublisher
            .map { Int($0) }
            .assign(to: \.age, on: viewModel)
            .store(in: &cancellables)

        // Обновление текста возраста
        viewModel.$ageText
            .map { Optional($0) } // Преобразуем String в String?
            .assign(to: \UILabel.text, on: ageLabel)
            .store(in: &cancellables)

        // Привязка сегментированного контроллера к ViewModel
        genderSegmentControl.selectedSegmentIndexPublisher
            .assign(to: \.genderIndex, on: viewModel)
            .store(in: &cancellables)

        // Привязка переключателя к ViewModel
        noticeSwitch.isOnPublisher
            .assign(to: \.isNoticeEnabled, on: viewModel)
            .store(in: &cancellables)

        // Обновление состояния кнопки регистрации
        viewModel.$isFormValid
            .assign(to: \.isEnabled, on: registrationButton)
            .store(in: &cancellables)

        // Обработка нажатия кнопки регистрации
        registrationButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel.registerUser()
            }
            .store(in: &cancellables)

        // Обработка результата регистрации
        viewModel.$registrationResult
            .compactMap { $0 }
            .sink { result in
                switch result {
                case .success(let user):
                    print("User registered: \(user)")
                    // Переход на следующий экран или уведомление пользователя
                case .failure(let error):
                    print("Registration failed: \(error)")
                    // Показать ошибку пользователю
                }
            }
            .store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Embed Views
private extension RegistrationView {
    func embedViews() {
        addSubview(titleLabel)
        addSubview(screenObjectsStackView)
        addSubview(registrationButton)
        addSubview(skipButton)
    }
}

// MARK: - Constraints
private extension RegistrationView {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            screenObjectsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            screenObjectsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            screenObjectsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            registrationButton.topAnchor.constraint(equalTo: screenObjectsStackView.bottomAnchor, constant: 40),
            registrationButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            skipButton.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 30),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
