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
//private init() {
//    // Удаляем базу данных Realm
//    let fileManager = FileManager.default
//    let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
//
//    do {
//        try fileManager.removeItem(at: realmURL)
//        print("Realm database deleted successfully.")
//    } catch {
//        print("Ошибка удаления Realm: \(error)")
//    }
//
//    // Инициализируем Realm после удаления базы данных
//    do {
//        realm = try Realm()
//    } catch {
//        fatalError("Can't initialize Realm: \(error)")
//    }
//
//    // Инициализируем массив задач
//    tasks = []
//}

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
    

    
    
    
    //сохранение заметок
    func addNewTask(_ task: TaskModel) {
        let newTask = TaskModel()
        newTask.setId(UUID().uuidString)
        newTask.setName(task.getName())
        newTask.setDateStart(task.getDateStart())
        newTask.setDateFinish(task.getDateFinish())
        newTask.setDescription(task.getDescription())
        
        print("!!!!!!!!!")
        print("Saving task with ID: \(newTask.getId())")
        print("!!!!!!!!!")
        
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
        let tasksRealm = realm.objects(TaskModel.self).filter {$0.getDateStart() >= dateStart}.filter { $0.getDateFinish() < dateEnd }
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
            let tasks = try jsonDecoder.decode([TaskModel].self, from: data)
            try realm.write {
                realm.add(tasks, update: .modified)
            }
        } catch {
            print("error")
        }
    }
    
    
}

