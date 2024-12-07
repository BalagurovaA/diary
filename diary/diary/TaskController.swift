//
//  TaskController.swift
//  diary
//
//  Created by bocal on 12/7/24.
//

import Foundation
import UIKit

class TaskController: UIViewController {
    
    let buttonExit = UIButton(type: .system)
    let buttonSave = UIButton(type: .system)
    let nameText = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureExitButton()
        configureSaveButton()
        
  
       

    }
    
    //кнопка выход
    private func configureExitButton() {
        buttonExit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonExit)
        buttonExit.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        buttonExit.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        buttonExit.setTitle("Exit", for: .normal)
        
        buttonExit.addTarget(self, action: #selector(exitFromCreatingTaskController), for: .touchUpInside)
        
    }
    
    //кнопка сохранения
    private func configureSaveButton() {
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonSave)
        buttonSave.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 340).isActive = true
        buttonSave.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        buttonSave.setTitle("Save", for: .normal)
        
        buttonSave.addTarget(self, action: #selector(exitFromCreatingTaskController), for: .touchUpInside)
    }
    
    //название заметки
    private func configureNameTask() {
        
        
        
    }
    
    
        
        
    
    @objc func exitFromCreatingTaskController() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
