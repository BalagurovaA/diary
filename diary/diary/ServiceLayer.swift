import Foundation
import RealmSwift

//удаление БД
//private init() {
//    let fileManager = FileManager.default
//    let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
//
//    do {
//        try fileManager.removeItem(at: realmURL)
//    } catch {
//        print("Ошибка удаления Realm: $error)")
//    }
//
//    realm = try! Realm()
//}
//


class TaskServise {
    static let shared = TaskServise()
    private var realm: Realm
    private var tasks: [TaskModel]
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Can't initialize realm object")
        }
        tasks = []
    }
    
    func addTask(_ task: TaskModel) {
        var newTask = TaskModel()
        newTask.setId(task.getId())
        newTask.setDateStart(task.getDateStart())
        newTask.setDateFinish(task.getDateFinish())
        newTask.setName(task.getName())
        newTask.setDescription(task.getDescription())
        try! realm.write {
            realm.add(newTask)
        }
        
    }
    
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
        let tasksRealm = realm.objects(TaskModel.self).filter {$0.getDateStart() >= dateStart}.filter { $0.getDateFinish() < dateEnd }
        return Array(tasksRealm)
    }
    
    func updateExistingTask(_ existingTask: TaskModel, _ newTask: TaskModel) {
        let existingRealmTasks = realm.objects(TaskModel.self).filter {$0.getId() == existingTask.getId()}
        
        if let existingTask = existingRealmTasks.first {
            try! realm.write {
                existingTask.setName(newTask.getName())
                existingTask.setDateStart(newTask.getDateStart())
                existingTask.setDateFinish(newTask.getDateFinish())
                existingTask.setDescription(newTask.getDescription())
            }
        }
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
            let tasks = try jsonDecoder.decode([TaskModel].self, from: data)
            try realm.write {
                realm.add(tasks, update: .modified)
            }
        } catch {
            print("error")
        }
    }
    
    
}

