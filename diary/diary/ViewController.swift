import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var nums: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        tableView.delegate = self
        tableView.dataSource = self
//        configureCalendar()
    }
    
    private func configureCalendar() {
        let calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.locale = .current
        
        calendarView.visibleDateComponents = DateComponents(calendar: .current, year: 2024, month: 12)
        calendarView.fontDesign = .rounded
        calendarView.backgroundColor = .systemGray2
        calendarView.layer.cornerRadius = 12
        
        let dateSelection = UICalendarSelectionMultiDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        calendarView.delegate = self
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            calendarView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
    }
    
    private func configureTable() {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 310),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }
}

//это расширение для выбора дат и отмены выбора дат
extension ViewController: UICalendarViewDelegate, UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me")
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.text = String(nums[indexPath.row])
        return cell
    }
}
