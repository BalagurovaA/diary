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
        return viewModelController.getQuantityTimeSlots()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        cell.textLabel?.font = cell.textLabel?.font.withSize(16)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = viewModelController.timeTextOfCell(indexPath.row)
        
        // Проверяем, есть ли задание в конкретной строке
        let tasks = viewModelController.selectTasks(indexPath.row)
        if !tasks.isEmpty {
            cell.backgroundColor = .systemGray6
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedTask = viewModelController.selectTasks(indexPath.row).first

        let taskController = TaskController(viewModel: viewModelController)
        taskController.selectedTask = selectedTask
        
        //Начало
        var dateComponentsStart = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: calendar.date)
        dateComponentsStart.hour = indexPath.row
        dateComponentsStart.minute = 0
    
        guard let dateStart = Calendar.current.date(from: dateComponentsStart) else {
            print("Не удалось создать дату")
            return
        }
        
        //Конец
        var dateComponentsFinish = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: calendar.date)

        dateComponentsFinish.hour = indexPath.row + 1
        dateComponentsFinish.minute = 0
    
        guard let dateFinish = Calendar.current.date(from: dateComponentsFinish) else {
            print("Не удалось создать дату")
            return
        }

        taskController.startDate.date = dateStart
        taskController.finishDate.date = dateFinish

        taskController.onTaskDeleted = { [weak self] in
            self?.tableView.reloadData()
        }

        taskController.modalPresentationStyle = .fullScreen
        present(taskController, animated: true, completion: nil)
    }

    
    
}
