//
//  TaskController.swift
//  diary
//
//  Created by bocal on 12/7/24.
//

import Foundation
import UIKit

class TaskController: UIViewController, UITextViewDelegate {
    
    let buttonExit = UIButton(type: .system)
    let buttonSave = UIButton(type: .system)
    let nameText = UITextView()
    let placeholderText = "task name"
    let startDate = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        configureExitButton()
        configureSaveButton()
        configureNameTask()
        
        ttryMyfunc()
  
        
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
    
    @objc func exitFromCreatingTaskController() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //кнопка сохранения
    private func configureSaveButton() {
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonSave)
        buttonSave.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 340).isActive = true
        buttonSave.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        buttonSave.setTitle("Save", for: .normal)
        
        buttonSave.addTarget(self, action: #selector(exitFromCreatingTaskController), for: .touchUpInside)          //заменить здесь на функцию сохранения заметки
    }
    
    //название задачи
    private func configureNameTask() {
        view.addSubview(nameText)
        nameText.backgroundColor = UIColor.white
        nameText.layer.cornerRadius = 12
        nameText.font = .systemFont(ofSize: 14)
        nameText.delegate = self
        setUpPlaceHoldText()

        
        nameText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameText.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            nameText.heightAnchor.constraint(equalToConstant: 50)
        ])
       

    }
    
    private func setUpPlaceHoldText() {
        nameText.text = placeholderText
        nameText.textColor = .systemGray4
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if nameText.text == placeholderText {
            nameText.text = ""
            nameText.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setUpPlaceHoldText()
        }
    }

    // дата старта
    private func ttryMyfunc() {
        startDate.locale = .current
        startDate.datePickerMode = .dateAndTime
        startDate.preferredDatePickerStyle = .compact
        startDate.center = view.center
        view.addSubview(startDate)

    }
    
    
        
        

    
    
}
