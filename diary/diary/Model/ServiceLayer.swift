import Foundation
import RealmSwift

class TaskService {
    static let shared = TaskService()
     var realm: Realm
    private var tasks: [TaskModel]
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Can't initialize realm object")
        }
        tasks = []
    }
    
    //сохранение заметок
    func addNewTask(_ task: TaskModel) {
        let newTask = TaskModel()
        newTask.setId(task.getId())
        newTask.setName(task.getName())
        newTask.setDateStart(task.getDateStart())
        newTask.setDateFinish(task.getDateFinish())
        newTask.setDescription(task.getDescription())
        
        try! realm.write {
            realm.add(newTask)
        }
    }
    
    func updateExistingTask(_ existingTask: TaskModel, _ newTask: TaskModel) {
        let tasksToUpdate = realm.objects(TaskModel.self).filter {$0.getId() == existingTask.getId()}
        if let existingTaskRealm = tasksToUpdate.first {
            try! realm.write {
                existingTaskRealm.setName(newTask.getName())
                existingTaskRealm.setDateStart(newTask.getDateStart())
                existingTaskRealm.setDateFinish(newTask.getDateFinish())
                existingTaskRealm.setDescription(newTask.getDescription())
            }
        } else {
            print("there are no existing Task")
        }
   
    }
    
    
    //удаление заметок
    func deleteTask(_ task: TaskModel) {
        let tasksToDelete = realm.objects(TaskModel.self).filter {$0.getId() == task.getId()}
        
        if let taskToDelete = tasksToDelete.first {
            try! realm.write {
                realm.delete(taskToDelete)
            }
        }
    }
    
    func getAllTasks() -> [TaskModel] {
        let allTasks = realm.objects(TaskModel.self)
        return Array(allTasks)
    }
    
    func getAllTasksQuantity() -> Int {
        return realm.objects(TaskModel.self).count
    }
    
    func getTaskWithSpecificDate(_ selectedDate: Date) -> [TaskModel] {
        let dateStart = Calendar.current.startOfDay(for: selectedDate)
        let dateEnd = Calendar.current.date(byAdding: .day, value: 1, to: dateStart)!
        
        let tasksRealm = realm.objects(TaskModel.self).filter {
            $0.getDateStart() < dateEnd && $0.getDateFinish() > dateStart
        }
        
        return Array(tasksRealm)
    }

    

    func getDataFromJSON() {
        guard let url = Bundle.main.url(forResource: "firstData", withExtension: "json")
        else {
            print("file not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            let tasks = try jsonDecoder.decode([TaskModel].self, from: data)
            try realm.write {
                realm.add(tasks, update: .modified)
            }
        } catch {
            print("can't decode JSON")
        }
    }
    
    func setRealm(_ Nrealm: Realm) {
        realm = Nrealm
    }
    
    
}

