//
//  SignUpViewController.swift
//  LoginFinal
//
//  Created by Vinay on 18/12/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestoreInternal


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var pass_word: UITextField!
    @IBOutlet weak var mail_Id: UITextField!
    @IBOutlet weak var firstName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sigupAction(_ sender: Any) {
        accountCreationLogic()
    }
    
    func setUpUI() {
        Helper.styleHollowButton(signUp)
        Helper.styleTextField(pass_word)
        Helper.styleTextField(mail_Id)
        Helper.styleTextField(firstName)
    }
}


extension SignUpViewController {
    
    func validate() -> String? {
        if mail_Id.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines ) == "" || pass_word.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "plz enter manditory field"
        }
        
        let check = pass_word.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(check!) == false {
            return "password_invalid"
        }
        return nil
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func welcomeScreen() {
        let vc = (UIStoryboard(name: "WelcomeScreenViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "WelcomeScreenViewController") as? WelcomeScreenViewController)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func accountCreationLogic() {
        let first_name = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines )
        let pass_word =  pass_word.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mail_id =  mail_Id.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let res = validate()
        if res == nil {
            Auth.auth().createUser(withEmail: mail_id, password: pass_word) { fireBaseResult,error in
                if error != nil {
                    print("their is error")
                } else {
                    
                    let userInfo = Auth.auth().currentUser
                    _ = userInfo?.email
                    let db = Firestore.firestore()
                    db.collection("logonFinal").addDocument(data: ["first_name": first_name]) { err in
                        if let err = err {
                            print("error adding document\(err)")
                        } else{
                            self.welcomeScreen()
                            print("Success adding document")
                        }
                    }
                }
            }
        }
    }
}
