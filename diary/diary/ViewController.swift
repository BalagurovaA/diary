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
        createSampleTasks()
   

    }
    
   private func createSampleTasks() {
      // Установка форматирования даты
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

      // Создание задач для 9 декабря
    if let dateStart1 = dateFormatter.date(from: "2024-12-09 09:00"),
         let dateFinish1 = dateFormatter.date(from: "2024-12-09 10:00") {
           let task1 = Task(id: 1, date_start: dateStart1, date_finish: dateFinish1, name: "Задача 1", description: "Полотно отличается не только большой красочностью, но и разнообразием техники. Работая над картиной в несколько приёмов, Левитан делал неоднократные повторные прописки по сухому. Применение лессировок и полулессировок по белому грунту усиливает чистоту и интенсивность голубого тона неба. На большей части поверхности полотна красочный слой относительно тонок, так что видна структура холста. При этом по контрасту заметно выделяются массивные светлые корпусные прописки парохода, лодки и отдельных частей барж, а также мачт, чаек и облаков. Для повышения интенсивности цветов художник использовал киноварь и оранжевый кадмий. Рябь на воде передана чёткими мазками синего и лиловатого цветов на общем голубом фоне, а для отражения ярких цветов барж использованы красные, оранжевые, белые и синие мазки")
            allTasks.append(task1)
      }

       if let dateStart2 = dateFormatter.date(from: "2024-12-09 10:00"),
            let dateFinish2 = dateFormatter.date(from: "2024-12-09 11:00") {
            let task2 = Task(id: 2, date_start: dateStart2, date_finish: dateFinish2, name: "Задача 2", description: "Описание задачи 2")
              allTasks.append(task2)
        }
 
        if let dateStart3 = dateFormatter.date(from: "2024-12-09 11:00"),
            let dateFinish3 = dateFormatter.date(from: "2024-12-09 12:00") {
           let task3 = Task(id: 3, date_start: dateStart3, date_finish: dateFinish3, name: "Задача 3", description: "Описание задачи 3")
             allTasks.append(task3)
       }
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
        calendar.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }
    
    //передаю новую дату
    @objc func dateChanged(_ send: UIDatePicker) {
        selectedDate = send.date
        updateTaskForSelectedDate()
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
        
        cell.textLabel?.font = cell.textLabel?.font.withSize(16)
        cell.textLabel?.numberOfLines = 0
        
        //если дату не выбрали по дефолту слоты
        guard let selectedDate = selectedDate else {
            cell.textLabel?.text = timeSlots[indexPath.row]
            return cell
        }
        
        
        let timeSlot = timeSlots[indexPath.row]
        
        let hour = indexPath.row
        
        let startDate = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate)
        
        
        let tasksInSlot = tasks.filter { task in
            let dateToCompare = startDate ?? Date.distantPast // или любое другое значение по умолчанию
            return task.date_start >= dateToCompare && task.date_start < Calendar.current.date(byAdding: .hour, value: 1, to: dateToCompare)!
        }

        
        if let task = tasksInSlot.first {
            cell.textLabel?.text = "\(timeSlot)\n\(task.name)\n\(task.description)"
     } else {
       cell.textLabel?.text = "\(timeSlot)"
       }
   
        
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    


    
    
}


