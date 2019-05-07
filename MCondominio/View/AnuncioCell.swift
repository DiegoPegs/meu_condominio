//
//  AnuncioCell.swift
//  MCondominio
//
//  Created by ROMEU PILON FILHO on 01/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit

class AnuncioCell: UITableViewCell {
    
    
    @IBOutlet weak var lbAnuncio: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    
    var anuncio: AnuncioItem!
    
    
    
    func configureCell(_ anuncio: AnuncioItem){
        self.anuncio = anuncio
        self.lbAnuncio.text = self.anuncio.anuncio
        self.lbAuthor.text = self.anuncio.author
    }
    
}
