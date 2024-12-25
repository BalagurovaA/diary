import Foundation
import UIKit

class TaskController: UIViewController {
    //инициализация
    //buttons
    let buttonExit = UIButton(type: .system)
    let buttonSave = UIButton(type: .system)
    let buttonDelete = UIButton(type: .system)
    
    //texts
    let nameText = UITextView()
    let descriptionText = UITextView()
    
    //Date Pickers
    let startDate = UIDatePicker()
    let finishDate = UIDatePicker()
    
    //Labels
    let labelStart = UILabel()
    let labelEnd = UILabel()
    let labelName = UILabel()
    let labelDescr = UILabel()
    
    var viewModelController: ViewModel
    var selectedTask: TaskModel?
    //замыкание для обновления таблицы
    var onTaskDeleted: (() -> Void)?
    
    init(viewModel: ViewModel) {
        self.viewModelController = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        configureExitButton()
        configureSaveButton()
        updateSaveButtonState()
        configureDeleteTask()
        configureNameTask()
        configureDateStart()
        configureFinish()
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
        updateSaveButtonState()
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonSave)
        buttonSave.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 340).isActive = true
        buttonSave.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.addTarget(self, action: #selector(savingTask), for: .touchUpInside)
    }
    
    @objc private func savingTask() {
        let newTask = TaskModel()
        newTask.setId(UUID().uuidString)
        newTask.setName(nameText.text ?? "")
        newTask.setDescription(descriptionText.text ?? "")
        newTask.setDateStart(startDate.date)
        newTask.setDateFinish(finishDate.date)
        
        if let existingTask = selectedTask {
            viewModelController.saveTask(newTask, existingTask)
            
        } else {
            viewModelController.saveTask(newTask, nil)
        }
        //обновление таблицы
        onTaskDeleted?()
        viewModelController.updateTaskForSelectedDate()
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSaveButtonState() {
        buttonSave.isEnabled =  startDate.date < finishDate.date
    }
    
    //удаление задачи
    private func configureDeleteTask() {
        buttonDelete.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonDelete)
        buttonDelete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 330).isActive = true
        buttonDelete.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 730).isActive = true
        buttonDelete.setTitle("Delete", for: .normal)
        buttonDelete.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
    }
    
    @objc private func deleteTask() {
        if let selectedTask = selectedTask  {
            viewModelController.deleteTask(selectedTask)
            //обновление таблицы
            onTaskDeleted?()
        }
        dismiss(animated: true, completion: nil)
    }
    
    //название задачи
    private func configureNameTask() {
        labelName.text = "Task name"
        labelName.textColor = .black
        labelName.frame = CGRect(x: 25, y: 80, width: 280, height: 50)
        view.addSubview(labelName)
        
        
        nameText.text = selectedTask?.getName()
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
        
        startDate.date = selectedTask?.getDateStart() ?? Date()
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
        
        startDate.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    
    //дата финиша
    private func configureFinish() {
        labelEnd.text = "Finish"
        labelEnd.textColor = .black
        labelEnd.frame = CGRect(x: 25, y: 230, width: 280, height: 50)
        view.addSubview(labelEnd)
        
        finishDate.date = selectedTask?.getDateFinish() ?? Date()
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
        finishDate.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }
    
    //сброс минут на 00
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: sender.date)
        
        if let roundedDate = calendar.date(from: components) {
            sender.setDate(roundedDate, animated: true)
        }
        updateSaveButtonState()
    }
    
    //описание задачи
    private func configureDescription() {
        labelDescr.text = "Description"
        labelDescr.textColor = .black
        labelDescr.frame = CGRect(x: 25, y: 270, width: 280, height: 50)
        view.addSubview(labelDescr)
        descriptionText.text = selectedTask?.getDescription()
        descriptionText.backgroundColor = UIColor.white
        descriptionText.layer.cornerRadius = 12
        descriptionText.font = .systemFont(ofSize: 14)
        view.addSubview(descriptionText)
        
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionText.topAnchor.constraint(equalTo: view.topAnchor, constant: 320),
            descriptionText.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
}
