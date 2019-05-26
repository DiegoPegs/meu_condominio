//
//  AjustesVC.swift
//  MCondominio
//
//  Created by ROMEU PILON FILHO on 26/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AjustesVC: UIViewController {
    
    @IBOutlet weak var tfLatitude: UITextField!
    @IBOutlet weak var tfLongitude: UITextField!
    @IBOutlet weak var lbNomeUsuario: UILabel!
    
    let ud = UserDefaults.standard
    var handle: AuthStateDidChangeListenerHandle?
    
    var lat: String = "-23.520361"
    var long: String = "-46.680801"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let defaults = UserDefaults.standard
                defaults.set("logged", forKey: "logged")
                self.logOut()
            }
        })
        setupKeyboardDismissRecognizer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let dLat: String = ud.string(forKey: "latitude") ?? "",let dLong: String = ud.string(forKey: "longitude") ?? ""  else {return}
        if dLat != "" && dLong != "" {
            lat = dLat
            long = dLong
        }
        tfLatitude.text = lat
        tfLongitude.text = long
        lbNomeUsuario.text = Auth.auth().currentUser?.displayName ?? ""
    }
    
    func logOut(){
        
        let loginController: LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.tabBarController?.present(loginController, animated: false, completion: nil)
        
        
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
    
    
    @IBAction func btAlterar(_ sender: UIButton) {
        ud.set(tfLatitude.text, forKey: "latitude")
        ud.set(tfLongitude.text, forKey: "longitude")
        let alert = UIAlertController(title: "Sucesso", message: "Coordanedas atualizadas.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default,handler: nil)
        alert.addAction(okAction)
    }
    
    @IBAction func btnLogOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
}




