//
//  PostagemViewController.swift
//  Instagram
//
//  Created by Rafaella Rodrigues Santos on 18/11/23.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class PostagemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descricao: UITextField!
    var imagePicker = UIImagePickerController()
    var storage: Storage!
    var auth: Auth!
    var firestore: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        storage = Storage.storage()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        imagePicker.delegate = self
    }
    
    @IBAction func selecionarImagem(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.imagem.image = imagemRecuperada
        imagePicker.dismiss(animated: true)
    }
    
    @IBAction func salvarPostagem(_ sender: Any) {
        
        let imagens = storage.reference()
            .child("imagens")
        
        let imagemSelecionada = self.imagem.image
        if let imagemUpload = imagemSelecionada?.jpegData(compressionQuality: 0.3) {
            
            let identificadorUnico = UUID().uuidString
            let imagemPostadaRef = imagens
                .child("postagens")
                .child("\(identificadorUnico).jpg")
            
            imagemPostadaRef.putData(imagemUpload, metadata: nil) { metaData, erro in
                if erro == nil{
                    
                    imagemPostadaRef.downloadURL { url, erro in
                        if let urlImagem = url?.absoluteString{
                            if let descricao = self.descricao.text{
                                if let usuarioLogado = self.auth.currentUser{
                                    let idUsuario = usuarioLogado.uid
                                    
                                    self.firestore
                                        .collection("postagens")
                                        .document(idUsuario)
                                        .collection("postagens_usuario")
                                        .addDocument(data: [
                                            "descricao" : descricao,
                                            "url" : urlImagem
                                        ]) { erro in
                                            if erro == nil{
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    print("sucesso")
                }else{
                    print("Erro ao fazer upload")
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
