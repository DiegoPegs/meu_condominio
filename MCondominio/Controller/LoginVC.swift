//
//  ViewController.swift
//  MCondominio
//
//  Created by Diego H C Correia on 29/04/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.showMainScreen(user: user, animated: false)
            }
        })
        
        setupKeyboardDismissRecognizer()
    }
    
    func showMainScreen(user: User?, animated: Bool = true){
        print("Indo para a proxima tela")
        
        let userDefaults = UserDefaults.standard
        let logged = userDefaults.array(forKey: "logged")
        if logged == nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "mainTabBar")else{return}
            self.present(vc, animated: true, completion: nil)
        }else{
            dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }

    
    @IBAction func btnLogin(_ sender: UIButton) {
        removeListener()
        guard let login = tfEmail.text, login != "", let password = tfPassword.text, password != "" else{
            self.showAlertWIthOk(title: "Alerta", message: "O Campo E-mail e Senha devem ser preenchidos.")
            
            return
        }
        
        Auth.auth().signIn(withEmail: login, password: password) { (result, error) in
            if (error == nil) {
                if let user = result?.user {
                    self.showMainScreen(user: user)
                }else{
                    print("else do error no login")
                }
                
            }else{
                self.showAlertWIthOk(title: "Atenção", message: "Usuário não localizado")
            }
        }
    }
    
    func removeListener(){
        
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    
    
}

