//
//  tasksStruct.swift
//  diary
//
//  Created by bocal on 12/6/24.
//

import Foundation
import RealmSwift


class TaskRealm: Object, Decodable {

    @objc dynamic var id: Int = 0
    @objc dynamic var date_start: Date = Date()
    @objc dynamic var date_finish: Date = Date()
    @objc dynamic var name: String = ""
    @objc dynamic var descrip: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

    
   enum CodingKeys: String, CodingKey {
        case id
        case date_start
        case date_finish
        case name
        case description
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        id = try container.decode(Int.self, forKey: .id)
        let jsonDateStart = try container.decode(Double.self, forKey: .date_start)
        date_start = Date(timeIntervalSince1970: jsonDateStart)
        let jsonDateFinish = try container.decode(Double.self, forKey: .date_finish)
        date_finish = Date(timeIntervalSince1970: jsonDateFinish)
        name = try container.decode(String.self, forKey: .name)
        descrip = try container.decode(String.self, forKey: .description)
    }
    
    required override init() {
        super.init()
    }
}

struct Task {
    var id: Int
    var date_start: Date
    var date_finish: Date
    var name: String
    var description: String
    
}
