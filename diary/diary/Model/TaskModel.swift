import Foundation
import RealmSwift


class TaskModel: Object, Decodable {
    
    @objc dynamic private var id: String = UUID().uuidString
    @objc dynamic private var date_start: Date = Date()
    @objc dynamic private var date_finish: Date = Date()
    @objc dynamic private var name: String = ""
    @objc dynamic private var descrip: String = ""
    
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
        
        let jsonId = try container.decode(Int.self, forKey: .id)
        id = try container.decode(String.self, forKey: .id)
        id = String(jsonId)
        
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
 
    
    //геттеры для данных
    func getId() -> String {
        return id
    }
    
    func getDateStart() -> Date {
        return date_start
    }
    
    func getDateFinish() -> Date {
        return date_finish
    }
    
    func getName() -> String {
        return name
    }
    
    func getDescription() -> String {
        return descrip
    }
    
    //сеттеры для данных
    func setId(_ newId: String) {
        id = newId
    }
    func setDateStart(_ newDateStart: Date) {
        date_start = newDateStart
    }
    
    func setDateFinish(_ newDateFinish: Date) {
        date_finish = newDateFinish
    }
    func setName(_ newName: String) {
        name = newName
    }
    func setDescription(_ newDescription: String) {
        descrip = newDescription
    }
    

    
}
