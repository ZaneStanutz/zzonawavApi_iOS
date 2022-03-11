//
//  Login.swift
//  zzonawaviOS
//
//  Created by ZZ on 2022-02-28.
//

import UIKit
import Foundation

class Login: UIViewController {
    let gradient = CAGradientLayer()
    var userEmail:String?
    var userPass:String?
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBOutlet weak var createAccountBtnOutlet: UIButton!
    @IBOutlet weak var invalidCredentials: UILabel!
    
    
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
        view.addSubview(logo)
        view.addSubview(loginBtnOutlet)
        view.addSubview(emailInput)
        view.addSubview(passwordInput)
        view.addSubview(createAccountBtnOutlet)
        view.addSubview(invalidCredentials)
        invalidCredentials.isHidden = true
        // Do any additional setup after loading the view.
        
        if(userEmail != nil){
            emailInput.text = userEmail!
        }
        if(userPass != nil){
            passwordInput.text = userPass!
        }
    } // viewLoad()
    
    @IBAction func loginUser(_ sender: Any) {
       
        let emailInput = emailInput.text!
        let emailString = String(emailInput)
        let passwordInput = passwordInput.text!
        let passwordString = String(passwordInput)
        validateUser(email: emailString, password: passwordString)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradient.frame = view.layer.bounds
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        performSegue(withIdentifier: "createaccount", sender: nil)
    }
    func validateUser(email: String, password: String){
        
        var callResult:String = ""
        
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\r\n \"email\":\"" + email + "\"\r\n ,\"password\":\"" + password + "\"}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://localhost:3000/validate")!,timeoutInterval: Double.infinity)
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
            case "404-invalid-user":
                invalidCredentials.isHidden = false
            case "200-valid-user":
            performSegue(withIdentifier: "mediadownload", sender: self)
            default:
                invalidCredentials.isEnabled = true
        }
    
    } // validateUser()
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mediadownload"){
            let displayNext = segue.destination as! MediaDownload
            displayNext.userEmail  = emailInput.text!
            displayNext.userPassword = passwordInput.text!
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}  // class

