//
//  LugaresTVC.swift
//  MCondominio
//
//  Created by Compila  on 09/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit

class LugaresTVC: UITableViewController {

    var lugares: [String] = ["Restaurante", "Hospital", "Escola", "Academia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lugares.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LugaresCell {
            let titulo = lugares[indexPath.row]
            cell.ivLugar.image = UIImage(named: titulo.lowercased())
            cell.lbTitulo.text = titulo
            
            return cell
        }else {
            return UITableViewCell()
        }
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lugar = lugares[indexPath.row]
        var poi = ""
        switch lugar {
        case "Restaurante":
            poi = "Restaurant"
            break
        case "Escola":
            poi = "School"
            break
        default:
            poi = lugar
        }
        
        
        performSegue(withIdentifier: "MapVc", sender: poi)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MapVc" {
            if let poi = sender as? String {
                if let vc = segue.destination as? MapVC {
                    vc.pointOfInterest = poi
                }
            }
        }
    }
 

}
