//
//  NoteEditorViewController.swift
//  QuickNotes
//
//  Created by Javier Galera Robles on 9/4/21.
//

import UIKit

class NoteEditorViewController: UIViewController {


    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var note: Note?
    var userDidSave: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryInput.layer.cornerRadius = 10
        
        if let note = self.note {
            titleInput.text = note.title
            categoryInput.text = note.category?.name
            noteBodyTextView.text = note.body
            navigationItem.title = "Edit QuickNote"
        }
    }

    // Make the Note Body to be editable as the View appears.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleInput.becomeFirstResponder()
    }
    
    @IBAction func didTapDone() {
        saveNote()
        navigationController?.popViewController(animated: true)
    }
    
    func saveNote() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              noteBodyTextView.text.isEmpty == false
        else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Check if we are updating a note or creating a new one.
        if let note = self.note {
            note.title = titleInput.text!
            note.category?.name = categoryInput.text!
            note.body = noteBodyTextView.text
        } else {
            let newNote = Note(context: context)
            let newCategory = Category(context: context)
            if titleInput.text == nil { newNote.title = titleInput.placeholder! } else { newNote.title = titleInput.text! }
            if categoryInput.text == nil { newCategory.name = categoryInput.placeholder! } else { newCategory.name = categoryInput.text! }
            newNote.body = noteBodyTextView.text
            newNote.category = newCategory
        }
        
        appDelegate.saveContext()
    }
}
