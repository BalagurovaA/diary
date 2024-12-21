import Foundation

class ViewModel {
    
    var taskService = TaskServise.shared
    private var timeSlots: [String] = []
    var selectedDate: Date?
    private var tasks: [TaskModel] = []
    
    init() {
        configTimeSlots()
        taskService.getDataFromJSON()
        updateTaskForSelectedDate()
    }
    
    
    private func configTimeSlots() {
        for hour in 0..<24 {
            let startHour = String(format: "%02d:00", hour)
            let finishHour = String(format: "%02d:00", (hour + 1) % 24)
            timeSlots.append("\(startHour) - \(finishHour)")
        }
    }
    
    func updateTaskForSelectedDate() {
        guard let selectedDate = selectedDate else {
            print("Selected date is nil")
            return
        }
        tasks = taskService.getTaskWithSpecificDate(selectedDate)
    }
    
    func getAllTasks() -> [TaskModel] {
        return taskService.getAllTasks()
    }
    
    
    
    func selectTasks(_ index: Int) -> [TaskModel] {
        guard let selectedDate = selectedDate else {
           return []
        }

        guard let startDate = Calendar.current.date(bySettingHour: index, minute: 0, second: 0, of: selectedDate) else {
            return []
        }
    
        let endDate = startDate.addingTimeInterval(3600)
        
         let selectedTask = tasks.filter { task in
            let taskStartDate = task.getDateStart()
            let taskFinishDate = task.getDateFinish()

            return taskStartDate < endDate && taskFinishDate > startDate
        }
        
        return selectedTask
    }
    
 
    func timeTextOfCell(_ index: Int) -> String {
        let timeSlot = timeSlots[index]
        let tasksInSlot = selectTasks(index)
        
        if tasksInSlot.isEmpty {
            return timeSlot
        } else {
            let taskDescriptions = tasksInSlot.map { task in "\(task.getName())\n\(task.getDescription())" }
            return "\(timeSlot)\n" + taskDescriptions.joined(separator: "\n")
        }
    }
    
    //методы для делегатов
    func saveTask(_ newTask: TaskModel, _ exitingTask: TaskModel? ) {
        if let exitingTask = exitingTask {
            taskService.updateExistingTask(exitingTask, newTask)
        } else {
            taskService.addNewTask(newTask)
        }
        updateTaskForSelectedDate()
    }
    
    func getAllTasksCount() -> Int {
        return taskService.getAllTasksQuantity()
    }
    
    func deleteTask(_ task: TaskModel) {
        taskService.deleteTask(task)
        updateTaskForSelectedDate()
    }

//      геттеры
    func getQuantityTimeSlots() -> Int {
        return timeSlots.count
    }

//      сеттеры
    func setSelectedDate(_ newSelectedDate: Date) {
        selectedDate = newSelectedDate
    }
}
