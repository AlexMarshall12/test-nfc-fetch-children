//
//  ViewController.swift
//  test-nfc-fetch-children
//
//  Created by Alex Marshall on 1/17/20.
//  Copyright © 2020 Alex Marshall. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext!

    @IBOutlet var itemTableView: UITableView!
    
    fileprivate lazy var itemFetchedResultsController: NSFetchedResultsController<Item> = {
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext =
            appDelegate?.persistentContainer.viewContext
        let request: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
        let timeSort = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [timeSort]
        let itemFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        itemFetchedResultsController.delegate = self
        return itemFetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            try itemFetchedResultsController.performFetch()
        } catch _ as NSError {
            print("SkillFetchError")
        }
    }

    @IBAction func createItemA(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let itemA = NSEntityDescription.insertNewObject(forEntityName: "ItemA", into: managedContext) as! ItemA
        itemA.timestamp = Date()
        try! managedContext.save()
    }
    @IBAction func createItemB(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let itemB = NSEntityDescription.insertNewObject(forEntityName: "ItemB", into: managedContext) as! ItemB
        itemB.timestamp = Date()
        try! managedContext.save()
    }
    func configure(cell: UITableViewCell,item:Item) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.textLabel?.text = dateFormatterGet.string(from: item.timestamp!)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemFetchedResultsController.object(at: indexPath)
        let cell = itemTableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        configure(cell: cell,item:item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = itemFetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        itemTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
       didChange anObject: Any,
              at indexPath: IndexPath?,
             for type: NSFetchedResultsChangeType,
             newIndexPath: IndexPath?){
        switch type {
        case .insert:
            itemTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            itemTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = itemTableView.cellForRow(at: indexPath!)!
            let item = itemFetchedResultsController.object(at: indexPath!)
            configure(cell: cell,item:item)
        case .move:
            itemTableView.deleteRows(at: [indexPath!], with: .automatic)
            itemTableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            print("Unexpected change")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        itemTableView.endUpdates()
    }

}
