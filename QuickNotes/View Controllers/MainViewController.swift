//
//  ViewController.swift
//  QuickNotes
//
//  Created by Javier Galera Robles on 8/4/21.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var notesTable: UITableView!
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadNotes()
    }
    
    // Once we return from a View to this one, the TableView should update.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }
    
    // Functions that load notes from the stored data and show them on the TableView.
    func loadNotes() {
        // We create the connection to CoreData via AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        // We try to get the data and store it in our Note Array.
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            guard let notes = fetchedObjects as? [Note] else { return }
            
            self.notes = notes
            notesTable.reloadData()
        } catch {
            print(error)
        }
    }

    // When Tap Add Button, open the New Note View.
    @IBAction func didTapAdd(_ sender: Any) {
        performSegue(withIdentifier: "segue.Main.fromQuickNotesToNoteEditor", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteTableCell else { return UITableViewCell() }
        
        let currentNote = notes[indexPath.row]
        cell.populate(with: currentNote)
        
        return cell
    }
    
    // Function that runs once you select a Row and update the Note body.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Select the Note and send it to the new View to edit it.
        let note = notes[indexPath.row]
        performSegue(withIdentifier: "segue.Main.fromQuickNotesToNoteEditor", sender: note)
    }
    
    // Check if we send a Note, then if its true, the Note variable on the NoteEditor View will be the Note we are sending.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let noteEditorViewController = segue.destination as? NoteEditorViewController, let note = sender as? Note {
            noteEditorViewController.note = note
        }
    }
    
    // Function to delete a row and the note from the context.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(notes[indexPath.row])
            notes.remove(at: indexPath.row)
            
            notesTable.beginUpdates()
            notesTable.deleteRows(at: [indexPath], with: .automatic)
            notesTable.endUpdates()
            
            appDelegate.saveContext()
            
            loadNotes()
        }
    }
}

