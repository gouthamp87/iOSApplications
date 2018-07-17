//
//  ViewController.swift
//  todoApp
//
//  Created by Goutham on 7/17/18.
//  Copyright © 2018 Citrix. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    var todoList = ["Exercise","Tutorial", "Solve Problem", "Prepare for Interview", "Speak to Harish", "Get Inputs"]
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let todoItems = userDefaults.array(forKey: "ToDoListItems") as? [String] {
            todoList = todoItems
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellItem", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row]
        return cell
    }

    
    // Pragma Mark -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected TodoItem : \(todoList[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        print("User Needs a Todo item. Present the available options")
        var userInputText = UITextField()
        let userInputAlert = UIAlertController(title: "Add a ToDoItem", message: "If you want a new ToDo Task Please enter below", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add new Task", style: .default) { (addAction) in
            print("Adding new Todo Task")
            self.todoList.append(userInputText.text!)
            self.userDefaults.set(self.todoList, forKey: "ToDoListItems")
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
}

