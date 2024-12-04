//
//  AlertManager.swift
//  FileManager
//
//  Created by KOДИ on 15.04.2024.
//

import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    enum AlertType {
        case folder
        case file
    }
    
    private init() {}
    
    func showAlert(
        type: AlertType,
        from controller: UIViewController,
        completion: @escaping (String?) -> Void
    ) {
        switch type {
        case .folder:
            showFolderCreationAlert(
                from: controller,
                completionHandler: completion
            )
        case .file:
            showFileCreationAlert(
                from: controller,
                completionHandler: completion
            )
        }
    }
    
    func failedLogin(
        from controller: UIViewController,
        title: String,
        message: String?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        )
        alertController.addAction(okAction)
        controller.present(alertController, animated: true)
    }
    
    func showFileContent(
        from controller: UIViewController,
        at url: URL
    ) {
        let alertController = UIAlertController(
            title: url.lastPathComponent,
            message: FileManagerAdapter().loadTextFromFile(at: url),
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        )
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func showTextInsideFileAlert(
        from controller: UIViewController,
        at url: URL,
        message: String?,
        completionHandler: @escaping (Data?) -> Void
    ) {
        let alertController = UIAlertController(
            title: url.lastPathComponent,
            message: message,
            preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(
            title: "Сохранить",
            style: .default
        ) { _ in
            guard let textField = alertController.textFields?.first,
                  let text = textField.text else {
                completionHandler(nil)
                return
            }
            completionHandler(text.data(using: .utf8))
        }
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(
            title: "Выйти",
            style: .cancel
        ) { _ in
            completionHandler(nil)
        }
        alertController.addAction(cancelAction)
        alertController.addTextField { textField in
            textField.placeholder = "Записать данные"
        }
        controller.present(alertController, animated: true)
    }
    
    func showFolderCreationAlert(
        from controller: UIViewController,
        completionHandler: @escaping (String?) -> Void
    ) {
        let alertController = UIAlertController(
            title: "Создание папки",
            message: "Введите имя папки",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "Имя папки"
        }
        
        let createAction = UIAlertAction(
            title: "Создать",
            style: .default
        ) { _ in
            if let folderName = alertController.textFields?.first?.text {
                completionHandler(folderName)
            } else {
                completionHandler(nil)
            }
        }
        
        let cancelAction = UIAlertAction(
            title: "Выйти",
            style: .cancel
        ) { _ in
            completionHandler(nil)
        }
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true)
    }
    
    func showFileCreationAlert(
        from controller: UIViewController,
        completionHandler: @escaping (String?) -> Void
    ) {
        let alertController = UIAlertController(
            title: "Создание файла",
            message: "Введите имя файла",
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.placeholder = "Имя файла"
        }
        
        let createAction = UIAlertAction(
            title: "Создать",
            style: .default
        ) { _ in
            if let fileName = alertController.textFields?.first?.text {
                completionHandler(fileName)
            } else {
                completionHandler(nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Выйти", style: .cancel) { _ in
            completionHandler(nil)
        }
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true)
    }
}
