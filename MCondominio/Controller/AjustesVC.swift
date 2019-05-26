//
//  AjustesVC.swift
//  MCondominio
//
//  Created by ROMEU PILON FILHO on 26/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit

class AjustesVC: UIViewController {

    @IBOutlet weak var tfLatitude: UITextField!
    @IBOutlet weak var tfLongitude: UITextField!
    
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfLatitude.text = ud.string(forKey: "latitude")
        tfLongitude.text = ud.string(forKey: "longitude")
    }
    

    @IBAction func btAlterar(_ sender: UIButton) {
        ud.set(tfLatitude.text, forKey: "latitude")
        ud.set(tfLongitude.text, forKey: "longitude")
        let alert = UIAlertController(title: "Sucesso", message: "Coordanedas atualizadas.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default,handler: nil)
        alert.addAction(okAction)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
