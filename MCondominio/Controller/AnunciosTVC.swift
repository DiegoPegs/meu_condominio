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
            if let anuncio = data["anuncio"] as? String, let author = data["author"] as? String, let title = data["title"] as? String {
                let anuncioItem = AnuncioItem(anuncio: anuncio, author: author, id: document.documentID, date: Date(), title: title)
                
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
        addEdit(anuncioItem: item)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = anuncios[indexPath.row]
            firestore.collection(ANUNCIO_COLLECTION).document(item.id).delete()
        }
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        addEdit()
        
    }
    
    func addAnuncio(_ item: AnuncioItem) {
        let data: [String: Any] = [
            "anuncio": item.anuncio,
            "author": Auth.auth().currentUser?.displayName ?? "",
            "title": item.title,
            "authorID": Auth.auth().currentUser!.uid,
            "date": Date()
        ]
        
        
        if item.id.isEmpty {
            //Criar
            firestore.collection(ANUNCIO_COLLECTION).addDocument(data: data) { (error) in
                if error != nil {
                    self.showAlertWIthOk(title: "Erro Adicionar Item", message: error?.localizedDescription ?? "")
                }else{
                    self.showAlertWIthOk(title: "Sucesso", message: "Anúncio gravado com sucesso!")
                    
                }
                
            }
        } else {
            //Editar
            firestore.collection(ANUNCIO_COLLECTION).document(item.id).updateData(data) { (error) in
                if error != nil {
                    self.showAlertWIthOk(title: "Erro Editar Item", message: error?.localizedDescription ?? "")
                }else{
                    self.showAlertWIthOk(title: "Sucesso", message: "Anúncio gravado com sucesso!")
                }
                
            }
        }
    }
    
    func addEdit(anuncioItem: AnuncioItem? = nil){
        if anuncioItem != nil {
            if anuncioItem?.author != Auth.auth().currentUser?.displayName {
                 return
            }
        }
        
        let title = anuncioItem == nil ? "Adicionar" : "Editar"
        let message = anuncioItem == nil ? "Adicionado" : "Editado"
        let alert = UIAlertController(title: title, message: "Digite abaixo os dados do item a ser \(message)", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Titulo"
            textfield.text = anuncioItem?.title
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Descrição"
            textfield.text = anuncioItem?.anuncio
            
        }
        
        let addAction = UIAlertAction(title: title, style: .default) { (_) in
            guard let title = alert.textFields?.first?.text,
                let anuncio = alert.textFields?.last?.text,
                !title.isEmpty,
                !anuncio.isEmpty else{return}
            
            var item = anuncioItem ?? AnuncioItem()
            item.title = title
            item.anuncio = anuncio
            
            self.addAnuncio(item)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
 

}
