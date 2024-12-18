import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    //инициаллизация
    var taskService = TaskServise.shared
    var tasks: [Task] = []
    private var timeSlots: [String] = []
    var selectedDate: Date?
    private let calendar = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
       
        configureCalendar()
        configureTable()
        configTimeSlots()
        taskService.getDataFromJSON()
//        taskService.getAllTasks()
        
        // или установите любую дату по умолчанию
      updateTaskForSelectedDate() // Обновите таблицу с заданиями для выбранной даты
        tableView.reloadData()
        
    }
    
    //работа с кнопкой плюс
    @IBAction func createTask(_ sender: Any) {
        let taskController = TaskController()
        taskController.taskControllerDelegate = self
        taskController.modalPresentationStyle = .fullScreen
        present(taskController, animated: true, completion: nil)
    }
    
    
    //временной интервал
    private func configTimeSlots() {
        for hour in 0..<24 {
            let startHour = String(format: "%02d:00", hour)
            let finishHour = String(format: "%02d:00", (hour + 1) % 24)
            timeSlots.append("\(startHour) - \(finishHour)")
        }
    }
    
    
    //КАЛЕНДАРЬ
    private func configureCalendar() {
        calendar.locale = .current
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),   // Слева
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), // Справа
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), // Сверху
            calendar.heightAnchor.constraint(equalToConstant: 350) // Задайте фиксированную высоту, если это необходимо
        ])
        calendar.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    //передаю новую дату
    @objc func dateChanged(_ send: UIDatePicker) {
        selectedDate = send.date
        updateTaskForSelectedDate()
    }
    
    private func updateTaskForSelectedDate() {
        selectedDate = Date()
        guard let selectedDate = selectedDate else { return }
        
        tasks = taskService.getTaskWithSpecificDate(selectedDate)
        tableView.reloadData()
    }
    
    //ТАБЛИЦА
    private func configureTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 400),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75)
        ])
        tableView.reloadData()
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        cell.textLabel?.font = cell.textLabel?.font.withSize(16)
        cell.textLabel?.numberOfLines = 0
        
        //если дату не выбрали по дефолту слоты
        guard let selectedDate = selectedDate else {
            cell.textLabel?.text = timeSlots[indexPath.row]
            cell.backgroundColor = UIColor.white
            return cell
        }
        
        
        let timeSlot = timeSlots[indexPath.row]
        let hour = indexPath.row
        let startDate = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate)
        
        //!
        if let startDateNew = startDate {
            let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDateNew)!
            
            let tasksInSlot = tasks.filter { task in
                let taskEndDate = task.date_finish
                return task.date_start < endDate && taskEndDate > startDateNew
            }
            
            
            if !tasksInSlot.isEmpty {
                cell.backgroundColor = UIColor.systemGray6
            } else {
                cell.backgroundColor = UIColor.white
            }
            
            if let task = tasksInSlot.first {
                cell.textLabel?.text = "\(timeSlot)\n\(task.name)\n\(task.description)"
            } else {
                cell.textLabel?.text = "\(timeSlot)"
            }
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    //    выбор ячейки, открытие task controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let hour = indexPath.row
        let startDate = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate!)
        guard let validStartDate = startDate else {
            print("startDate could not be calculated")
            return
        }
        
        guard let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: validStartDate) else {
            return
        }
        
        let TimeTasks = tasks.filter { task in
            let startDateOfTask = task.date_start
            let endDateOfTask = task.date_finish
            return (startDateOfTask < endDate && endDateOfTask > validStartDate)
            }

        let selectedTask = TimeTasks.first
        
        let taskController = TaskController()
        taskController.taskControllerDelegate = self
        taskController.selectedTask = selectedTask
        
        taskController.modalPresentationStyle = .fullScreen
        present(taskController,animated: true, completion: nil)
        
    }
}

extension ViewController: TaskControllerDelegate {
    
    func addNewTask(_ viewContr: TaskController, newTask: Task, existingTask: Task?) {
        
        if let existingTask = existingTask {
            taskService.updateExtistingTask(existingTask, newTask)
        } else {
            taskService.addTask(newTask)
        }
        updateTaskForSelectedDate()
    }
    
    
    func getAllTasksCount() -> Int {
        return taskService.getAllTasksQuantity()
    }
    
    func deleteTask(_ viewContr: TaskController, task: Task) {
        taskService.deleteTask(task)
        updateTaskForSelectedDate()
    }
}
