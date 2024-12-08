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
    let placeholderText = "task name"
    let startDate = UIDatePicker()
    let finishDate = UIDatePicker()
    let labelStart = UILabel()
    let labelEnd = UILabel()
    let descriptionText = UITextView()
    let labelName = UILabel()
    let labelDescr = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        configureExitButton()
        configureSaveButton()
        configureNameTask()
        configureDateStart()
        configureEndStart()
        configureDescription()
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
        labelName.text = "Task name"
        labelName.textColor = .black
        labelName.frame = CGRect(x: 25, y: 80, width: 280, height: 50)
        view.addSubview(labelName)
        
        nameText.backgroundColor = UIColor.white
        nameText.layer.cornerRadius = 12
        nameText.font = .systemFont(ofSize: 14)
        view.addSubview(nameText)
        
        nameText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameText.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            nameText.heightAnchor.constraint(equalToConstant: 50)
        ])
       

    }
    

    // дата старта
    private func configureDateStart() {
        //label start
        labelStart.text = "Start"
        labelStart.textColor = .black
        labelStart.frame = CGRect(x: 25, y: 180, width: 280, height: 50)
        view.addSubview(labelStart)
        
        
        startDate.locale = .current
        startDate.datePickerMode = .dateAndTime
        startDate.preferredDatePickerStyle = .compact
        startDate.center = view.center
        view.addSubview(startDate)
        startDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startDate.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            startDate.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    //дата финиша
    private func configureEndStart() {
        labelEnd.text = "Finish"
        labelEnd.textColor = .black
        labelEnd.frame = CGRect(x: 25, y: 230, width: 280, height: 50)
        view.addSubview(labelEnd)
        
        finishDate.locale = .current
        finishDate.datePickerMode = .dateAndTime
        finishDate.preferredDatePickerStyle = .compact
        finishDate.center = view.center
        view.addSubview(finishDate)
        finishDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            finishDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // Слева
            finishDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),  // Справа
            finishDate.topAnchor.constraint(equalTo: view.topAnchor, constant: 230),  // Сверху
            finishDate.heightAnchor.constraint(equalToConstant: 50) //фикс высота
        ])
        
    
    }
    //описание задачи
    private func configureDescription() {
        labelDescr.text = "Description"
        labelDescr.textColor = .black
        labelDescr.frame = CGRect(x: 25, y: 270, width: 280, height: 50)
        view.addSubview(labelDescr)
        descriptionText.backgroundColor = UIColor.white
        descriptionText.layer.cornerRadius = 12
        descriptionText.font = .systemFont(ofSize: 14)
        view.addSubview(descriptionText)
        
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionText.topAnchor.constraint(equalTo: view.topAnchor, constant: 320),
            descriptionText.heightAnchor.constraint(equalToConstant: 500)
        ])
       
        
    }
}
