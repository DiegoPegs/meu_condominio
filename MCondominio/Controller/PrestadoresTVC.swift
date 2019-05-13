//
//  PrestadoresTVC.swift
//  MCondominio
//
//  Created by ROMEU PILON FILHO on 05/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit
import Firebase

class PrestadoresTVC: UITableViewController {

    var firestoreListener: ListenerRegistration!
    var prestadores: [PrestadoresItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listItems()
    }

    
    func listItems() {
        firestoreListener = firestore.collection(PRESTADOR_COLLECTION).order(by: "date", descending: false).addSnapshotListener(includeMetadataChanges: true){ (snapshot, error) in
            if error != nil {
                print(error!)
            }
            guard let snapshot = snapshot else {return}
            print("Total de mudanças:", snapshot.documentChanges.count)
            
            if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                self.showItems(snapshot: snapshot)
            }
        }
    }
    
    func showItems(snapshot: QuerySnapshot) {
        prestadores.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let name = data["name"] as? String, let tel = data["tel"] as? String, let rating = data["rating"] as? Double, let service = data["service"] as? String {
                let prestadorItem = PrestadoresItem(id: document.documentID, date: Date(), name: name, tel: tel, rating: rating, service: service)
                
                prestadores.append(prestadorItem)
            }
        }
        tableView.reloadData()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.prestadores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PrestadorCell {
            cell.configureCell(prestadores[indexPath.row])
            
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = prestadores[indexPath.row]
        performSegue(withIdentifier: "PrestadoresEdit", sender: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = prestadores[indexPath.row]
            firestore.collection(PRESTADOR_COLLECTION).document(item.id).delete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PrestadoresEdit" {
            if let prestador = sender as? PrestadoresItem {
                if let vc = segue.destination as? AddEditPrestadorVC {
                    vc.prestadorItem = prestador
                }
            }
        }
    }

    

}
