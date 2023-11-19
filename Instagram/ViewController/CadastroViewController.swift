//
//  CadastroViewController.swift
//  Instagram
//
//  Created by Rafaella Rodrigues Santos on 18/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CadastroViewController: UIViewController {
    
    @IBOutlet weak var campoNome: UITextField!
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    
    var auth: Auth!
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        firestore = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
   
    @IBAction func cadastrar(_ sender: Any) {
        
        if let nome = campoNome.text{
            if let email = campoEmail.text{
                if let senha = campoSenha.text{
                    auth.createUser(withEmail: email, password: senha) { dadosResultado, erro in
                        if erro == nil{
                            
                            if let idUsuario = dadosResultado?.user.uid{
                                //salvar dados do usuario
                                self.firestore.collection("usuarios")
                                    .document(idUsuario)
                                    .setData([
                                        "nome" : nome,
                                        "email" : email,
                                        "id" : idUsuario
                                    ])
                            }
                        }else{
                            print("Erro ao cadastrar o usuario")
                        }
                    }
                }else{
                    print("Preencha a senha")
                }
            }else{
                print("Preencha o email")
            }
        }else{
            print("Preencha o nome")
        }
    }
    
}
