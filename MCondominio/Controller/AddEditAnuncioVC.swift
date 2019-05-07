//
//  RegisterAnuncioVC.swift
//  MCondominio
//
//  Created by Diego H C Correia on 01/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit
import Firebase

class AddEditAnuncioVC: UIViewController {

    var anuncioItem: AnuncioItem?
    
    
    @IBOutlet weak var tvAnuncio: UITextView!
    @IBOutlet weak var barBtnSave: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvAnuncio.layer.borderWidth = 1
        tvAnuncio.layer.borderColor = UIColor.black.cgColor
        
        if let anuncio = anuncioItem {
            tvAnuncio.text = anuncio.anuncio
            barBtnSave.title = "Editar"
        }
    }
    
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        guard let anuncio = tvAnuncio.text, anuncio != "" else {
            self.showAlertWIthOk(title: "Atenção", message: "O Anuncio não pode estar vazio")
            return
        }
        
        var item = anuncioItem ?? AnuncioItem()
        item.anuncio = anuncio
        item.author = Auth.auth().currentUser?.displayName ?? ""
        addItem(item)
    }
    
    
    func addItem(_ item: AnuncioItem) {
        let data: [String: Any] = [
            "anuncio": item.anuncio,
            "author": item.author,
            "authorID": Auth.auth().currentUser!.uid,
            "date": Date()
        ]
        
        if item.id.isEmpty {
            //Criar
            firestore.collection(ANUNCIO_COLLECTION).addDocument(data: data) { (error) in
                if error != nil {
                    self.showAlertWIthOk(title: "Erro Adicionar Item", message: error?.localizedDescription ?? "")
                }else{
                    self.showAlertWIthCallBack(title: "Sucesso", message: "Anúncio gravado com sucesso!", onComplete: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
            }
        } else {
            //Editar
            firestore.collection(ANUNCIO_COLLECTION).document(item.id).updateData(data) { (error) in
                if error != nil {
                    self.showAlertWIthOk(title: "Erro Editar Item", message: error?.localizedDescription ?? "")
                }else{
                    self.showAlertWIthCallBack(title: "Sucesso", message: "Anúncio editado com sucesso!", onComplete: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
            }
        }
    }

}


