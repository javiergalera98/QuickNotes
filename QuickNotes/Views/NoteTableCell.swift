//
//  NoteTableViewCell.swift
//  QuickNotes
//
//  Created by Javier Galera Robles on 9/4/21.
//

import UIKit

class NoteTableCell: UITableViewCell {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(with note: Note) {
        titleLabel?.text = note.title
        categoryLabel?.text = note.category?.name?.uppercased()
        bodyLabel?.text = note.body
    }

}
