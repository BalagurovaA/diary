import UIKit

class ViewController: UIViewController {
    
    //инициаллизация
    @IBOutlet var tableView: UITableView!
    private let calendar = UIDatePicker()
    private var viewModelController = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModelController.setSelectedDate(Date())
        viewModelController.updateTaskForSelectedDate()
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
        
        configureCalendar()
        configureTable()
        tableView.reloadData()
        print(viewModelController.getAllTasks())
    }
    
    //работа с кнопкой плюс
    @IBAction func createTask(_ sender: Any) {
        let taskController = TaskController(viewModel: viewModelController)
        taskController.modalPresentationStyle = .fullScreen

        taskController.onTaskDeleted = { [weak self] in
             self?.tableView.reloadData()
         }
        present(taskController, animated: true, completion: nil)
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
            calendar.heightAnchor.constraint(equalToConstant: 350) //  фикс высота
        ])
        calendar.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    //передача значения в selectedDate
    @objc func dateChanged(_ send: UIDatePicker) {
        viewModelController.setSelectedDate(send.date)
        viewModelController.updateTaskForSelectedDate()
        tableView.reloadData()
    }

    
    //ТАБЛИЦА
    private func configureTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoTaskCell")
        
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
        return viewModelController.getTimeSlotsWithTasks().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let timeSlot = viewModelController.getTimeSlotsWithTasks()[section]
        return timeSlot.tasks.count > 0 ? timeSlot.tasks.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeSlot = viewModelController.getTimeSlotsWithTasks()[indexPath.section]
    
        if timeSlot.tasks.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoTaskCell", for: indexPath)
            return cell
        } else {
            let task = timeSlot.tasks[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
            cell.textLabel?.text = "\(task.getName())\n \(task.getDescription())"
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let timeSlot = viewModelController.getTimeSlotsWithTasks()[section]
        return timeSlot.time
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let timeSlot = viewModelController.getTimeSlotsWithTasks()[indexPath.section]
        let selectedTask = timeSlot.tasks[indexPath.row]
        
        let taskController = TaskController(viewModel: viewModelController)
        taskController.selectedTask = selectedTask

        //замыкание для обновления таблицы
        taskController.onTaskDeleted = { [weak self] in
            self?.tableView.reloadData()
        }
   
        taskController.modalPresentationStyle = .fullScreen
        present(taskController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let timeSlot = viewModelController.getTimeSlotsWithTasks()[indexPath.section]
        
        // Проверяем, есть ли задача в ячейке
        if timeSlot.tasks.indices.contains(indexPath.row) {
            return indexPath
        } else {
            return nil
        }
    }

    
}
