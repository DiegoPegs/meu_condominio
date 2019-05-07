//
//  PrestadorCell.swift
//  MCondominio
//
//  Created by ROMEU PILON FILHO on 05/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit
import Cosmos

class PrestadorCell: UITableViewCell {

    @IBOutlet weak var lbService: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTel: UILabel!
    @IBOutlet weak var cvRating: CosmosView!
    
    var prestador: PrestadoresItem!
    
    func configureCell(_ prestador: PrestadoresItem){
        self.prestador = prestador
        self.lbService.text = self.prestador.service
        self.lbName.text = self.prestador.name
        self.lbTel.text = self.prestador.tel
        self.cvRating.rating = Double(self.prestador.rating)
        
    }
    
}
