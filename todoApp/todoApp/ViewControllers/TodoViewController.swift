//
//  ViewController.swift
//  todoApp
//
//  Created by Goutham on 7/17/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    var todoList = [ToDoItems]() //["Exercise","Tutorial", "Solve Problem", "Prepare for Interview", "Speak to Harish", "Get Inputs"]
//    let itemListDir = try
    let itemListFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        if let todoItems = userDefaults.array(forKey: "ToDoListItems") as? [ToDoItems] {
//            todoList = todoItems
//        }
//        if let todoItems = userDefaults.
        self.readItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellItem", for: indexPath)
        let item = todoList[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.selection ? .checkmark : .none
//        tableView.reloadData()
        return cell
    }

    
    // Pragma Mark -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected TodoItem : \(todoList[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
        todoList[indexPath.row].selection = !(todoList[indexPath.row].selection)
        self.tableView.reloadData()
    }
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        print("User Needs a Todo item. Present the available options")
        var userInputText = UITextField()
        let userInputAlert = UIAlertController(title: "Add a ToDoItem", message: "If you want a new ToDo Task Please enter below", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add new Task", style: .default) { (addAction) in
            print("Adding new Todo Task")
            let newToDoItem = ToDoItems()
            newToDoItem.title = userInputText.text!
            self.todoList.append(newToDoItem)
            self.saveItems()
            //Reload table views
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        userInputAlert.addTextField { (inputText) in
            inputText.placeholder = "Enter the new Task"
            userInputText = inputText
        }
        userInputAlert.addAction(addAction)
        userInputAlert.addAction(cancelAction)
        present(userInputAlert, animated: true, completion: nil)
    }
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let dataToStore = try encoder.encode(self.todoList)
            try dataToStore.write(to: self.itemListFile!)
        }catch{
            print("Error Encodign Values \(error)")
        }
    }
    func readItems() {
        if let data = try? Data(contentsOf: itemListFile!) {
            let decoder = PropertyListDecoder()
            do{
                todoList = try decoder.decode([ToDoItems].self, from: data)
            } catch {
                print("Error Decoding Values \(error)")
            }
        }
    }
}

