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

    

}
