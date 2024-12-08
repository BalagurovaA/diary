import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    //инициаллизация

    var allTasks: [Task] = []
    var tasks: [Task] = []
    var timeSlots: [String] = []
    var selectedDate: Date?
    let calendar = UIDatePicker()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureCalendar()
        configureTable()
        configTimeSlots()

    }
    
    //работа с кнопкой
    @IBAction func createTask(_ sender: Any) {
        let taskController = TaskController()
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
    

    private func updateTaskForSelectedDate() {
        guard let selectedDate = selectedDate else { return }
        
        tasks = allTasks.filter { Calendar.current.isDate($0.date_start, inSameDayAs: selectedDate) }
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
        
        if indexPath.row < tasks.count {
            let task = tasks[indexPath.row]
//            cell.textLabel?.text.DateFormatter.localizedString(from: task.date_start, dateStyle: .short, timeStyle: .short)
        }
        
        
        
        
        let timeSlot = timeSlots[indexPath.row]
        
        cell.textLabel?.font = cell.textLabel?.font.withSize(12)
        cell.textLabel?.text = timeSlot
        
        return cell
    }
}


