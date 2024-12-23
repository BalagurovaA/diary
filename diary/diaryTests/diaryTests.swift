//
//  diaryTests.swift
//  diaryTests
//
//  Created by Kristofer Sartorial on 12/1/24.
//

import XCTest
import RealmSwift
@testable import diary

final class diaryTests: XCTestCase {

    var taskService: TaskService!
    var realm: Realm!
    
    override func setUpWithError() throws {
        super.setUp()
        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        realm = try Realm(configuration: config)
        taskService = TaskService()
        taskService.setRealm(realm)
    }

    override func tearDownWithError() throws {
        guard realm != nil else {
            super.tearDown()
            return
        }
        
        try! realm.write {
            realm.deleteAll()
        }
        super.tearDown()
    }

    func testAddNewTask1() throws {
        let task = TaskModel()
        task.setId("test-id-1")
        task.setName("test-1")
        task.setDateStart(Date())
        task.setDateFinish(Date().addingTimeInterval(3600))
        task.setDescription("Test Task 1")
        taskService.addNewTask(task)
       
        
        
        let tasks = realm.objects(TaskModel.self)
        let testTaskSaved = tasks.first
        //посчитать количество задач
        XCTAssertEqual(tasks.count, 1)
        //сравнить данные
        XCTAssertEqual(testTaskSaved?.getName(), "test-1", "Проблема с name")
        XCTAssertEqual(testTaskSaved?.getDateStart(), task.getDateStart(), "Проблема с date start")
        XCTAssertEqual(testTaskSaved?.getDateFinish(), task.getDateFinish(), "Проблема с date finish")
        XCTAssertEqual(testTaskSaved?.getDescription(), task.getDescription(), "Проблема с description")
    }

    func testAddNewTask2() throws {
        let task = TaskModel()
        task.setId("")
        task.setName("")
        task.setDateStart(Date())
        task.setDateFinish(Date().addingTimeInterval(7200)) //2 часа
        task.setDescription("")
        taskService.addNewTask(task)
        
        let tasks = realm.objects(TaskModel.self)
        let testTaskSaved = tasks.first
        //посчитать количество задач
        XCTAssertEqual(tasks.count, 1)
        //сравнить данные
        XCTAssertEqual(testTaskSaved?.getName(), "", "Проблема с name")
        XCTAssertEqual(testTaskSaved?.getDateStart(), task.getDateStart(), "Проблема с date start")
        XCTAssertEqual(testTaskSaved?.getDateFinish(), task.getDateFinish(), "Проблема с date finish")
        XCTAssertEqual(testTaskSaved?.getDescription(), task.getDescription(), "Проблема с description")
    }
    
    func testAddNewTask3() throws {
        let text: String = "Детство Анны и Михаила Врубелей проходило в переездах по местам служебного назначения отца: в 1859 году вдовца перевели обратно в Астрахань (где ему могли помогать родственники), в 1860 году назначили в Харьков. Там маленький Миша быстро научился читать и увлекался книжными иллюстрациями, особенно в журнале «Живописное обозрение»[6]. В 1863 году А. М. Врубель женился во второй раз на петербурженке Е. Х. Вессель, которая полностью посвятила себя детям своего мужа (первый собственный ребёнок родился у неё в 1867 году). В 1865 году семья переехала в Саратов, где подполковник Врубель принял командование губернским гарнизоном. Семья жила в казармах губернского батальона по адресу: ул. Университетская 59, Саратов. Вессели принадлежали к интеллигенции, сестра Елизаветы Христиановны — Александра — окончила Петербургскую консерваторию и очень много сделала для приобщения племянника к миру музыки. Елизавета Христиановна всерьёз занялась здоровьем Михаила, и хотя он впоследствии с иронией вспоминал «диеты сырого мяса и рыбьих жиров», нет сомнения, что будущей своей физической силой он обязан режиму, установленному мачехой[7]. Воспитанием детей занимался также дядя — профессиональный педагог Николай Христианович Вессель, увлечённый внедрением развивающих игр, домашних представлений. Несмотря на прекрасные отношения между всеми родственниками, Анна и Михаил держались несколько особняком, подчас сквозил и холодок в отношении к мачехе, которой они дали ироническое прозвище «Мадринька — перл матерей», и явно выражали желание начать самостоятельную жизнь вне дома, что огорчало отца[8]. К десятилетнему возрасту у Михаила проявлялись артистические способности, в том числе к рисованию, но театр и музыка занимали в его жизни не меньше места. По выражению Н. А. Дмитриевой, «мальчик был как мальчик, даровитый, но скорее обещающий разностороннего дилетанта, чем одержимого художника, которым потом стал»[9]."
        let task = TaskModel()
        task.setId("task1-longDescription")
        task.setName("")
        task.setDateStart(Date())
        task.setDateFinish(Date().addingTimeInterval(7200)) //2 часа
        task.setDescription(text)
        taskService.addNewTask(task)
        
        let tasks = realm.objects(TaskModel.self)
        let testTaskSaved = tasks.first
        //посчитать количество задач
        XCTAssertEqual(tasks.count, 1)

        XCTAssertEqual(testTaskSaved?.getName(), "", "Проблема с name")
        XCTAssertEqual(testTaskSaved?.getDateStart(), task.getDateStart(), "Проблема с date start")
        XCTAssertEqual(testTaskSaved?.getDateFinish(), task.getDateFinish(), "Проблема с date finish")
        XCTAssertEqual(testTaskSaved?.getDescription(), text, "Проблема с description")
    }
    
    func testAddNewTask4() throws {
        let task1 = TaskModel()
        task1.setId("test-id-1")
        task1.setName("test-1")
        task1.setDateStart(Date())
        task1.setDateFinish(Date().addingTimeInterval(3600))
        task1.setDescription("Test Task 1")
        taskService.addNewTask(task1)
        
        let task2 = TaskModel()
        task2.setId("test-id-2")
        task2.setName("test-2")
        task2.setDateStart(Date().addingTimeInterval(3600))
        task2.setDateFinish(Date().addingTimeInterval(7200))
        task2.setDescription("Test Task 2")
        taskService.addNewTask(task2)
        
        let task3 = TaskModel()
        task3.setId("test-id-3")
        task3.setName("test-3")
        task3.setDateStart(Date().addingTimeInterval(7200))
        task3.setDateFinish(Date().addingTimeInterval(10800))
        task3.setDescription("Test Task 3")
        taskService.addNewTask(task3)
        
        let tasks = realm.objects(TaskModel.self)
        //посчитать количество задач
        XCTAssertEqual(tasks.count, 3)
       
    }
    
    func testUpdateExistingTask1() throws {
        let existingTask = TaskModel()
        existingTask.setName("test-1")
        existingTask.setDateStart(Date())
        existingTask.setDateFinish(Date().addingTimeInterval(3600))
        existingTask.setDescription("Test Task 1")
        taskService.addNewTask(existingTask)


        let newTask = TaskModel()
        newTask.setId(existingTask.getId())
        newTask.setName("newTask")
        newTask.setDateStart(Date().addingTimeInterval(3600))
        newTask.setDateFinish(Date().addingTimeInterval(7200))
        newTask.setDescription("После окончания гимназии с золотой медалью ни сам Врубель, ни его родители не помышляли о карьере художника")
        taskService.updateExistingTask(existingTask, newTask)

        let tasks = realm.objects(TaskModel.self)
        let testTaskSaved = tasks.first
        //считаю количество задач
        XCTAssertEqual(tasks.count, 1)
        //сравниваю данные
        XCTAssertEqual(testTaskSaved?.getName(), "newTask", "Проблема с name") // ожидание нового имени
        XCTAssertEqual(testTaskSaved?.getDateStart(), newTask.getDateStart(), "Проблема с date start")
        XCTAssertEqual(testTaskSaved?.getDateFinish(), newTask.getDateFinish(), "Проблема с date finish")
        XCTAssertEqual(testTaskSaved?.getDescription(), newTask.getDescription(), "Проблема с description")
    }

    func testUpdateExistingTask2() throws {
        let existingTask = TaskModel()
        existingTask.setName("test-1")
        existingTask.setDateStart(Date())
        existingTask.setDateFinish(Date().addingTimeInterval(3600))
        existingTask.setDescription("Test Task 1")
        taskService.addNewTask(existingTask)
        
        
        let newTask = TaskModel()
        newTask.setId(UUID().uuidString)
        newTask.setName("newTask")
        newTask.setDateStart(Date().addingTimeInterval(3600))
        newTask.setDateFinish(Date().addingTimeInterval(7200))
        newTask.setDescription("После окончания гимназии с золотой медалью ни сам Врубель, ни его родители не помышляли о карьере художника")
        
        taskService.updateExistingTask(existingTask, newTask)

        let tasks = realm.objects(TaskModel.self)
        let testTaskSaved = tasks.first
        //считаю количество задач
        XCTAssertEqual(tasks.count, 1)
        //сравниваю данные
        XCTAssertNotEqual(testTaskSaved?.getId(), newTask.getId(), "Проблема с ID")

        XCTAssertEqual(testTaskSaved?.getDateStart(), newTask.getDateStart(), "Проблема с date start")
        XCTAssertEqual(testTaskSaved?.getDateFinish(), newTask.getDateFinish(), "Проблема с date finish")
        XCTAssertEqual(testTaskSaved?.getDescription(), newTask.getDescription(), "Проблема с description")
    }
    
    func testDeleteTask1() throws {
        let existingTask = TaskModel()
        existingTask.setName("test-1")
        existingTask.setDateStart(Date())
        existingTask.setDateFinish(Date().addingTimeInterval(3600))
        existingTask.setDescription("Test Task 1")
        
        taskService.addNewTask(existingTask)
        taskService.deleteTask(existingTask)
        
        let tasks = realm.objects(TaskModel.self)
        let testTaskSaved = tasks.first
        
        XCTAssertEqual(tasks.count, 0)
        
    }
    
    func testDeleteTask2() throws {
        let existingTask = TaskModel()
        existingTask.setName("test-1")
        existingTask.setDateStart(Date())
        existingTask.setDateFinish(Date().addingTimeInterval(3600))
        existingTask.setDescription("Test Task 1")
        
 
        taskService.deleteTask(existingTask)
        
        let tasks = realm.objects(TaskModel.self)
        let testTaskSaved = tasks.first
        
        XCTAssertEqual(tasks.count, 0)
    }
    
    func testGetTasks1() throws {
        let existingTask = TaskModel()
        existingTask.setName("test-1")
        existingTask.setDateStart(Date())
        existingTask.setDateFinish(Date().addingTimeInterval(3600))
        existingTask.setDescription("Test Task 1")
        
        taskService.addNewTask(existingTask)
  
        let tasks = realm.objects(TaskModel.self)
        let testTaskSaved = tasks.first
        
        XCTAssertEqual(taskService.getAllTasks().count, 1)
        XCTAssertEqual(taskService.getAllTasksQuantity(), 1)
        
    }
}
