//
//  AddEditPrestadorVC.swift
//  MCondominio
//
//  Created by ROMEU PILON FILHO on 06/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit
import Cosmos
import Firebase

class AddEditPrestadorVC: UIViewController {

    var prestadorItem: PrestadoresItem?
    
    @IBOutlet weak var tfService: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfTel: UITextField!
    @IBOutlet weak var cvRating: CosmosView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let prestador = prestadorItem {
            tfService.text = prestador.service
            tfName.text = prestador.name
            tfTel.text = prestador.tel
            cvRating.rating = prestador.rating
            btnSave.title = "Editar"
        }
        
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        guard let service = tfService.text, service != "", let name = tfName.text, name != "", let tel = tfTel.text, tel != "" else {
            self.showAlertWIthOk(title: "Atenção", message: "O Anuncio não pode estar vazio")
            return
        }
        
        var item = prestadorItem ?? PrestadoresItem()
        item.service = service
        item.name = name
        item.tel = tel
        item.rating = cvRating.rating
        addItem(item)
    }
    
    
    
    
    
    var service: String = ""
    
    func addItem(_ item: PrestadoresItem) {
        let data: [String: Any] = [
            "name": item.name,
            "tel": item.tel,
            "rating": item.rating,
            "id": Auth.auth().currentUser!.uid,
            "service": item.service,
            "date": Date()
        ]
        
        if item.id.isEmpty {
            //Criar
            firestore.collection(PRESTADOR_COLLECTION).addDocument(data: data) { (error) in
                if error != nil {
                    self.showAlertWIthOk(title: "Erro Adicionar Item", message: error?.localizedDescription ?? "")
                }else{
                    self.showAlertWIthCallBack(title: "Sucesso", message: "Prestador gravado com sucesso!", onComplete: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
            }
        } else {
            //Editar
            firestore.collection(PRESTADOR_COLLECTION).document(item.id).updateData(data) { (error) in
                if error != nil {
                    self.showAlertWIthOk(title: "Erro Editar Item", message: error?.localizedDescription ?? "")
                }else{
                    self.showAlertWIthCallBack(title: "Sucesso", message: "Prestador editado com sucesso!", onComplete: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
            }
        }
    }
    

}
