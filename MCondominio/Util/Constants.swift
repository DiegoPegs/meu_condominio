//
//  Constants.swift
//  MCondominio
//
//  Created by ROMEU PILON FILHO on 01/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import Foundation
import Firebase

let ANUNCIO_COLLECTION = "anuncios"
let PRESTADOR_COLLECTION = "prestadores"
typealias saveComplete = () -> ()

var firestore: Firestore = {
    let settings = FirestoreSettings()
    settings.isPersistenceEnabled = true
    var firestore = Firestore.firestore()
    firestore.settings = settings
    return firestore
}()

extension UIViewController {
    
    func showAlertWIthOk(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showAlertWIthCallBack(title: String, message: String, onComplete: @escaping saveComplete){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default,handler: {action in
            onComplete()
        })
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
