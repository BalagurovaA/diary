import Foundation
import UIKit


protocol TaskControllerDelegate: AnyObject {
    func addNewTask(_ viewContr: TaskController, newTask: Task, extistingTask: Task?)
    func getAllTasksCount() -> Int
    func deleteTask(_ viewContr: TaskController, task: Task)
}


class TaskController: UIViewController {
    
    weak var taskControllerDelegate: TaskControllerDelegate?
    var selectedTask: Task?
    
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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        configureExitButton()
        configureSaveButton()
        configureDeleteTask()
        configureNameTask()
        configureDateStart()
        configureEndStart()
        configureDescription()
        transferTask()

    }
    
    //передача задачи в task controller
    func transferTask() {
        if let task = selectedTask {
             nameText.text = task.name
             descriptionText.text = task.description
             startDate.date = task.date_start
             finishDate.date = task.date_finish
         }
         else {
            
             nameText.text = " "
             descriptionText.text = " "
             startDate.date = Date()
             finishDate.date = Date()
         }
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
        
        buttonSave.isEnabled = false
        buttonSave.addTarget(self, action: #selector(savingNewTask), for: .touchUpInside)          //заменить здесь на функцию сохранения заметки
    }
    private func updateSaveButtonState() {
        if startDate.date < finishDate.date {
            buttonSave.isEnabled = true
        } else {
            buttonSave.isEnabled = false
        }
    }
    

    
    //функция сохранения заметки
    @objc private func savingNewTask() {
        
        if selectedTask != nil {


            selectedTask?.name = nameText.text ?? ""
            selectedTask?.date_start = startDate.date
            selectedTask?.date_finish = finishDate.date
            selectedTask?.description = descriptionText.text ?? ""
           
            taskControllerDelegate?.addNewTask(self, newTask: selectedTask!, extistingTask: selectedTask)


            
        } else {
           
            let savingTaskName = nameText.text ?? ""
            let savingStartTime = startDate.date
            let savingFinishDate = finishDate.date
            let savingDescr = descriptionText.text ?? ""
            let savingNewId = (taskControllerDelegate?.getAllTasksCount() ?? 00) + 1
            
            let newSavingtask = Task(id: savingNewId, date_start: savingStartTime, date_finish: savingFinishDate, name: savingTaskName, description: savingDescr)
            taskControllerDelegate?.addNewTask(self, newTask: newSavingtask, extistingTask: nil)
            
        }

        dismiss(animated: true, completion: nil)
    }
    
    //удаление задачи
    private func configureDeleteTask() {
        buttonDelete.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonDelete)
        buttonDelete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 330).isActive = true
        buttonDelete.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 730).isActive = true
        buttonDelete.setTitle("Delete", for: .normal)
        
        
        //проверить на nil
        if selectedTask != nil {
            taskControllerDelegate?.deleteTask(self, task: selectedTask!)
        }
        
        buttonDelete.addTarget(self, action: #selector(exitFromCreatingTaskController), for: .touchUpInside)
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
        
        startDate.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
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
