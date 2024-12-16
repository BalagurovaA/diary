//
//  ServiceLayer.swift
//  diary
//
//  Created by bocal on 12/10/24.
//

import Foundation
import RealmSwift


//удаление БД
//private init() {
//    // Удалите базу данных, если это необходимо
//    let fileManager = FileManager.default
//    let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
//
//    do {
//        try fileManager.removeItem(at: realmURL)
//    } catch {
//        print("Ошибка удаления Realm: $error)")
//    }
//
//    // Инициализация Realm с новой конфигурацией
//    realm = try! Realm()
//}
//




class TaskServise {
    static let shared = TaskServise()
    private var realm: Realm
    
    private init() {
        realm = try! Realm()
    }
    
    func getAllTasks() -> [Task] {
    
        let tasksRealm = realm.objects(TaskRealm.self)
        
               


       for object in tasksRealm {
          print("ID: \(object.id), Name: \(object.name)")
//           try! realm.write {
//               realm.delete(object)
//           }
       }
        return tasksRealm.map { Task(id: $0.id, date_start: $0.date_start, date_finish: $0.date_finish, name: $0.name, description: $0.descrip) }
    }
    
    func getAllTasksQuantity() -> Int {
        return realm.objects(TaskRealm.self).count
    }
    
    
    //сюда добавляется Realm!!!!
    
    func addTask(_ task: Task) {
        let taskRealm = TaskRealm()
        taskRealm.id = task.id
        taskRealm.date_start = task.date_start
        taskRealm.date_finish = task.date_finish
        taskRealm.name = task.name
        taskRealm.descrip = task.description
        
        try! realm.write {
            realm.add(taskRealm)
        }

    }
    
    func deleteTask(_ task: Task) {
        let realmTasks = realm.objects(TaskRealm.self).filter {$0.id == task.id}
        
        if let realmTask = realmTasks.first {
            try! realm.write {
                realm.delete(realmTask)
            }
        }
    }
    

    
    
    func getTaskWithSpecificDate(_ selectedDate: Date) -> [Task] {
        let dateStart = Calendar.current.startOfDay(for: selectedDate)
        let dateEnd = Calendar.current.date(byAdding: .day, value: 1, to: dateStart)!
        let tasksRealm = realm.objects(TaskRealm.self).filter { $0.date_start >= dateStart }.filter {$0.date_finish < dateEnd}
        return tasksRealm.map { Task(id: $0.id, date_start: $0.date_start, date_finish: $0.date_finish, name: $0.name, description: $0.descrip)}
    }
    

    
    
    func updateExtistingTask(_ existingTask: Task, _ newTask: Task) {
        
        let realmTasks = realm.objects(TaskRealm.self).filter {$0.id == existingTask.id}
        
        if let realmTask = realmTasks.first {
            try! realm.write {
                realmTask.name = newTask.name
                realmTask.date_start = newTask.date_start
                realmTask.date_finish = newTask.date_finish
                realmTask.descrip = newTask.description
            }
        }
        

    
    }
    
}
