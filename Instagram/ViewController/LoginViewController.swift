//
//  LoginViewController.swift
//  Instagram
//
//  Created by Rafaella Rodrigues Santos on 18/11/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    
    var auth: Auth!

    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        
        auth.addStateDidChangeListener { autenticacao, usuario in
            if usuario != nil{
                self.performSegue(withIdentifier: "segueLoginAutomatico", sender: nil)
            }else{
                print("Usuario não está logado")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
    
        do {
            try auth.signOut()
        } catch  {
            print("Erro ao deslogar o usuario")
        }
    }

    @IBAction func logar(_ sender: Any) {
        
        if let email = campoEmail.text{
            if let senha = campoSenha.text{
                
                auth.signIn(withEmail: email, password: senha) { usuario, erro in
                    if erro == nil{
                        
                        print("Sucesso ao logar usuario")
                    }else{
                        print("Erro ao logar o usuario")
                    }
                }
                
            }else{
                print("Digite sua senha")
            }
        }else{
            print("Digite seu email")
        }
    }
}
