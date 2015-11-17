//
//  MasterViewController.swift
//  SwiftExample06
//
//  Created by elif ece arslan on 11/16/15.
//  Copyright © 2015 elif ece arslan. All rights reserved.
//

import UIKit
import GameplayKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [String]()
    var words = [String]()

    override func loadView() {
        super.loadView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action:"promptForGuess")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialContent()
        startGame()
    }
    func loadInitialContent()  {
        if let initialContentPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
            if let initialContent = try? String(contentsOfFile: initialContentPath, usedEncoding: nil){
                words = initialContent.componentsSeparatedByString("\n")
            }
            else{
                
                words = ["initial"]
            }
        }
    }
    func promptForGuess(){
        let ac = UIAlertController(title: "Your guess?", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
//        use unowned to avoid strong references
        let submitAction = UIAlertAction(title: "hit", style: .Default) { [unowned self, ac] action in
            let guess = ac.textFields![0]
//            external call for submitAnswer(), controller's method is called w. self.
            
            self.submitAnswer(guess.text!)
            
        }
        ac.addAction(submitAction)
        presentViewController(ac, animated: true, completion: nil)
        
    }
    func submitAnswer(answer: String){
        let answer_ = answer.lowercaseString
        
        if answerIsValid(answer_) {
            if answerIsUnique(answer_) {
                if answerIsReal(answer_) {
                    objects.insert(answer, atIndex: 0)
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    func answerIsValid(answer: String) ->Bool{
        return true
    }
    
    func answerIsUnique(answer: String) ->Bool{
        return true
    }
    func answerIsReal(answer: String) ->Bool{
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    func startGame(){
//        we unwrap the return value because the contents of the array returns as Anyobject
        words = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(words) as! [String]
        title = words[0]
        objects.removeAll(keepCapacity: true)
        tableView.reloadData()
    }
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath){
        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

