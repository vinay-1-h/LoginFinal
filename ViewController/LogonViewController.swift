//
//  LogonViewController.swift
//  LoginFinal
//
//  Created by Vinay on 18/12/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestoreInternal
import FirebaseFirestore
import Firebase
import FirebaseCore
import FirebaseFirestore


class LogonViewController: UIViewController {
    
    @IBOutlet weak var sendCodeBtn: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendCodeBtn.isHidden = true
    }
    
    @IBAction func sendCodeAction(_ sender: Any) {
        let alert = UIAlertController(title: "SentCode", message: "Login_Back", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] action in
            
            logonScreen()
            
            
        }))
        self.present(alert, animated: true, completion: nil)
      
    }
    
    func setUpUI(){
        Helper.styleTextField(email)
        Helper.styleTextField(password)
        Helper.styleHollowButton(loginBtn)
        
        
    }
   
    @IBAction func forgotpassword(_ sender: Any) {
        loginBtn.isHidden = true
        password.isHidden = true
        email.placeholder = "Enter email to send code"
        forgetBtn.isHidden = true
        sendCodeBtn.isHidden = false
        
        Auth.auth().sendPasswordReset(withEmail: email.text!) { error in
            if error == nil {
                print("sent")
            } else {
                print("\(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        navigateToLoginLogic()
    }
}



extension LogonViewController {
    
    func welcomeScreen() {
        let vc = (UIStoryboard(name: "WelcomeScreenViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "WelcomeScreenViewController") as? WelcomeScreenViewController)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func creationAccount() {
        let vc = (UIStoryboard(name: "SignUpViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    func navigateToLoginLogic() {
       
        
        let pass_word =  password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mail_id =  email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: mail_id, password: pass_word) { res, err in
            if err != nil {
                let alert = UIAlertController(title: "User_Dosn't Exist", message: "Login with Proper UserCredentials", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Create_Account", style: .default, handler: { action in
                    self.creationAccount()
                    
                }))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                /* Fetch all the collection from FirebaseCloud
                let r = Firestore.firestore()
                r.collection("logonFinal").getDocuments { res, err in
                    if err == nil {
                        if let snap = res {
                            snap.documents.map { d in
                 
                                let r = d["first_name"] as? String ?? "nil"
                                print(r)
                            }
                        }
                        
                    }
                    
                }
                 */

                // Fetch particular all the collection from FirebaseCloud
                
                let r = Firestore.firestore()
                var use = Auth.auth().currentUser
              
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                r.collection("logonFinal").document(uid).getDocument { res, err in
                    print("1")
                    
                   
                    if let err = err {
                        print("error")
                    }
                    
                    guard let data = res?.data() else {
                        print("no dtaa")
                        return
                    }
                 
                    let name = data["first_name"] as? String ?? "nil"
                    let res = User(name: name)
                    print(res.name)
                }
                self.welcomeScreen()
            }
        }
    }
    
    func logonScreen() {
        let vc = (UIStoryboard(name: "LogonViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogonViewController") as? LogonViewController)!
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        var db = Firestore.firestore()
        db.collection("logonFinal").document("7chqpLVMHM2cKuEXySJ8").getDocument { res, err in
            print("1")
            guard let error = err else {
               print("error")
                print("2")
                return
            }
            
            print("3")
            guard let data = res?.data() else {
                print("4")
                return
            }
            
            let name = data["first_name"] as? String ?? "no data"
            print("]]]]]\(name)")
            var res = User(name: name)
            print(res.name)
        }
    }
}

struct User {
    var name: String
}
