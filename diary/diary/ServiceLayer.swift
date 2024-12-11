//
//  ServiceLayer.swift
//  diary
//
//  Created by bocal on 12/10/24.
//

import Foundation
class TaskServise {
    
   private var allTasks: [Task] = []
    
    func getAllTasks() -> [Task] {
        return allTasks
    }
    
    func getAllTasksQuantity() -> Int {
        return allTasks.count
    }
    
    func addTask(_ task: Task) {
        allTasks.append(task)
    }
    
    func deleteTask(_ task: Task) {
        if let index = allTasks.firstIndex(where: {$0.id == task.id}) {
            allTasks.remove(at: index)
        }
    }
    
    func getTaskWithSpecificDate(_ selectedDate: Date) -> [Task] {
        return allTasks.filter { Calendar.current.isDate($0.date_start, inSameDayAs: selectedDate) }
    }
    func updateExtistingTask(_ existingTask: Task, _ newTask: Task) {

        if let index = allTasks.firstIndex(where: { $0.id == existingTask.id}) {
            
            allTasks[index] = newTask
            
        }
        
    }
}
