//
//  CreateAccount.swift
//  zzonawaviOS
//
//  Created by ZZ on 2022-02-28.
//

import UIKit

class CreateAccount: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var verifyUserPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordsDoNotMatch: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    let gradient = CAGradientLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor(red: 25/255.0, green: 25/255.0, blue: 120/255.0,
                alpha: 1.0).cgColor,
            UIColor(red: 100/255.0, green: 10/255.0, blue: 150/255.0, alpha: 1.0).cgColor
            ]
        
        gradient.startPoint = CGPoint(x: 0 , y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(self.gradient)
        view.addSubview(userName)
        view.addSubview(userEmail)
        view.addSubview(userPassword)
        view.addSubview(verifyUserPassword)
        view.addSubview(signUpButton)
        view.addSubview(passwordsDoNotMatch)
        passwordsDoNotMatch.isHidden = true
        view.addSubview(logo)
        view.addSubview(backButton)
    }
    @IBAction func signUp(_ sender: Any) {
        let userNameInput =
        userName.text!
        let userNameString = String(userNameInput)
        
        let userEmailInput = userEmail.text!
        let userEmailString = String(userEmailInput)
        
        let userPasswordInput = userPassword.text!
        let userPasswordString = String(userPasswordInput)
        
        let userPasswordValidateInput = verifyUserPassword.text!
        let userPasswordValidateString = String(userPasswordValidateInput)
        
        if(userPasswordString == userPasswordValidateString && userEmailString != "" && userPasswordString != "" && userEmailString != ""){
            createAccount(email: userEmailString, password: userPasswordString, name: userNameString)
        }
        else{
            passwordsDoNotMatch.text = "please fill all fields with matching passwords"
            passwordsDoNotMatch.isHidden = false
        }
        //TODO add validation so input fields cannot be null...
    }
    func createAccount(email:String, password: String, name: String){
        var semaphore = DispatchSemaphore (value: 0)
        
        var callResult:String = ""
        
        let parameters = "{\r\n \"email\":\"" + email + "\"\r\n ,\"password\":\"" + password + "\"\r\n,\"name\":\"" + name + "\"}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://localhost:3000/create")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          callResult = (String(data: data, encoding: .utf8)!)
          print(callResult)	
          semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        switch callResult {
        case "insert-failed":
            //account create failed please try again..
            passwordsDoNotMatch.text = "something went wrong..."
            passwordsDoNotMatch.isHidden = false
        case "insert-successful":
            // store login info locally
            performSegue(withIdentifier: "createaccountsuccess", sender: nil)
        case "user-exists":
            passwordsDoNotMatch.text = "This email is already registered"
            passwordsDoNotMatch.isHidden = false
        default:
            passwordsDoNotMatch.text = "unknown issue please try again"
            passwordsDoNotMatch.isHidden = false
            //account create failed please try again.
        }
    }

    @IBAction func backButtonOnClick(_ sender: Any) {
        performSegue(withIdentifier: "createaccountaborted", sender: nil)
    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "createaccountsuccess"){
            let nextPage = segue.destination as! Login
            nextPage.userEmail = userEmail.text!
            nextPage.userPass = userPassword.text!
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
