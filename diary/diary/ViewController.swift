import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    //инициаллизация

    var allTasks: [Task] = []
    var tasks: [Task] = []
    var timeSlots: [String] = []
    var selectedDate: Date?
    

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
        let calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.locale = .current
        
        calendarView.visibleDateComponents = DateComponents(calendar: .current, year: 2024, month: 12)
        calendarView.fontDesign = .rounded
        calendarView.backgroundColor = .systemGray5
        calendarView.layer.cornerRadius = 12
        
        let dateSelection = UICalendarSelectionMultiDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            calendarView.heightAnchor.constraint(equalToConstant: 370)
        ])
        
    }
    
    //ТАБЛИЦА
    private func configureTable() {

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 450),
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

//это расширение для выбора дат и отмены выбора дат
extension ViewController: UICalendarViewDelegate, UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        if let date = Calendar.current.date(from: dateComponents) {
            selectedDate = date
            updateTaskForSelectedDate()
        }
        
        
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        
        
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
        cell.textLabel?.text = timeSlot
        
        
        return cell
    }
}


