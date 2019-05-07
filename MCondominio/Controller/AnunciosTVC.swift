//
//  AnunciosTVC.swift
//  MCondominio
//
//  Created by Diego H C Correia on 29/04/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit
import Firebase

class AnunciosTVC: UITableViewController {

    var firestoreListener: ListenerRegistration!
    var anuncios: [AnuncioItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listItems()
    }
    
    func listItems() {
        firestoreListener = firestore.collection(ANUNCIO_COLLECTION).order(by: "date", descending: false).addSnapshotListener(includeMetadataChanges: true){ (snapshot, error) in
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
        anuncios.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let anuncio = data["anuncio"] as? String, let author = data["author"] as? String {
                let anuncioItem = AnuncioItem(anuncio: anuncio, author: author, id: document.documentID, date: Date())
                
                anuncios.append(anuncioItem)
            }
        }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return anuncios.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AnuncioCell {
            cell.configureCell(anuncios[indexPath.row])
            
            return cell
        }else {
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = anuncios[indexPath.row]
        performSegue(withIdentifier: "AnuncioEdit", sender: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = anuncios[indexPath.row]
            firestore.collection(ANUNCIO_COLLECTION).document(item.id).delete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnuncioEdit" {
            if let anuncio = sender as? AnuncioItem {
                if let vc = segue.destination as? AddEditAnuncioVC {
                    vc.anuncioItem = anuncio
                }
            }
        }
    }

}
