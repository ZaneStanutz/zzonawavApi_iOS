//
//  MediaDownload.swift
//  zzonawaviOS
//
//  Created by ZZ on 2022-03-03.
//

import UIKit

class MediaDownload: UIViewController, URLSessionDelegate, UITextViewDelegate {
    var userEmail: String?
    var userPassword: String?
    let gradient = CAGradientLayer()
    @IBOutlet weak var LabelSalaam: UILabel!
    @IBOutlet weak var LabelGiraffe: UILabel!
    @IBOutlet weak var DownloadSalaam: UIButton!
    @IBOutlet weak var ProgressSalaam: UIProgressView!
    @IBOutlet weak var DownloadGiraffe: UIButton!
    @IBOutlet weak var InputFeeling: UITextView!
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var SubmitFeeling: UIButton!
    @IBOutlet weak var VIewFeeling: UIButton!
    @IBOutlet weak var Logout: UIButton!

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
        InputFeeling.text = "How are you feeling?"
        InputFeeling.textColor = UIColor.lightGray
        view.addSubview(LabelSalaam)
        view.addSubview(LabelGiraffe)
        view.addSubview(DownloadSalaam)
        view.addSubview(DownloadGiraffe)
        view.addSubview(InputFeeling)
        view.addSubview(Logo)
        view.addSubview(SubmitFeeling)
        view.addSubview(VIewFeeling)
        view.addSubview(ProgressSalaam)
        view.addSubview(Logout)
       
        ProgressSalaam.isHidden = true
        InputFeeling.delegate = self
    }
    @IBAction func dowloadSalaam(_ sender: Any) {
        print("File download comming soon")
        // Having issues with file download
        //ToDo
        //start download
        //unhide progessbar
        //hide progressbar when finished
        //pop up message saying download is completed
        
    }
    @IBAction func downloadGiraffe(_ sender: Any) {
        print("File download Comming soon")
        // Having issues with this file download..
        //ToDo
        //start download
        //unhide progessbar
        //hide progressbar when finished
        //pop up message saying download is completed
    }
    @IBAction func AddFeeling(_ sender: Any) {
        
        let feelingString = InputFeeling.text!
        if(feelingString == ""){
            popUpTime(title: "Please enter feeling", message: "Please enter a feeling so we can save it for you :)")
        }
        else{
            updateFeeling(email: userEmail!, password: userPassword!, feeling: feelingString )
        }
    }
    @IBAction func ViewFeelings(_ sender: Any) {
        
        performSegue(withIdentifier: "viewfeelings", sender: nil)
    }
    
    func updateFeeling(email: String, password: String, feeling: String){
        
        var callResult:String = ""
        
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\r\n \"email\":\"" + email + "\"\r\n ,\"password\":\"" + password + "\"\r\n,\"feeling\":\"" + feeling + "\"}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://localhost:3000/insertfeel")!,timeoutInterval: Double.infinity)
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
        case "could-not-connect":
            popUpTime(title: "bad connection", message: "Sorry, we could not connect to database.");
        case "find-one-fail":
            popUpTime(title: "Invalid User", message: "Please create account to use this functionality")
        case "update-one-fail":
            popUpTime(title: "Could not update", message: "Please try again later..")
        case "update-one-200":
            InputFeeling.text = ""
        default:
            popUpTime(title: "error 500", message:  "something exploded.. we are not sure what... please try again later");
        }
        
    } // viewFeelings()
    
    @IBAction func LogoutOnClick(_ sender: Any) {
        
        performSegue(withIdentifier: "logout", sender: nil)
    }
    
    func popUpTime(title: String, message: String ){
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: .none))
        present(alert, animated: true)
    }
    
    func textViewDidBeginEditing(_ input: UITextView) {
        if input.textColor == UIColor.lightGray {
            input.text = nil
            input.textColor = UIColor.black
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewfeelings"){
            let displayNext = segue.destination as! ViewFeelings
            displayNext.userEmail = userEmail
            displayNext.userPass = userPassword
        }
    }
} // class
