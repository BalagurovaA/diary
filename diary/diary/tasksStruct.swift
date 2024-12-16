//
//  tasksStruct.swift
//  diary
//
//  Created by bocal on 12/6/24.
//

import Foundation
import RealmSwift






class TaskRealm: Object {

    @objc dynamic var id: Int = 0
    @objc dynamic var date_start: Date = Date()
    @objc dynamic var date_finish: Date = Date()
    @objc dynamic var name: String = ""
    @objc dynamic var descrip: String = ""
    
//    override class func primaryKey() -> String? {
//        return "id"
//   }
//    
    

    
    
    override init() {
        super.init()
    }

    convenience init(id: Int, date_start: Date, date_finish: Date, name: String, description: String) {
        self.init()
        self.id = id
        self.date_start = date_start
        self.date_finish = date_finish
        self.name = name
        self.descrip = description
    }
}




struct Task {
    var id: Int
    var date_start: Date
    var date_finish: Date
    var name: String
    var description: String
    
}
