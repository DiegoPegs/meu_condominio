//
//  RegisterVC.swift
//  MCondominio
//
//  Created by Diego H C Correia on 29/04/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showMainScreen(user: User?, animated: Bool = true){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "mainTabBar")else{return}
        self.present(vc, animated: true, completion: nil)
    }
    
    func performUserChange(user: User?, name: String){
        guard let user = user else{return}
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { (error) in
            if error != nil {
                print(error!)
            }
            self.showMainScreen(user: user, animated: true)
        }
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        
        guard let email = tfEmail.text, email != "", let password = tfPassword.text, password != "", let nome = tfName.text, nome != "" else {
            
            let alert = UIAlertController(title: "Atenção", message: "O Campo Nome deve ser preenchido.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default,handler: nil)
            alert.addAction(okAction)
            
            
            present(alert, animated: true)
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if (error == nil) {
                self.performUserChange(user: result?.user, name: nome)
            }else{
                print(error!.localizedDescription)
            }
        }
        
        
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}



