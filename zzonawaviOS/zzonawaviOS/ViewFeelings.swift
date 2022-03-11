//
//  ViewFeelings.swift
//  zzonawaviOS
//
//  Created by ZZ on 2022-03-07.
//

import UIKit

class ViewFeelings: UIViewController {
    let gradient = CAGradientLayer()
    var userEmail:String?
    var userPass:String?
    @IBOutlet weak var feelingsTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    var callResult:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feelingsTable.delegate = self
        self.feelingsTable.dataSource = self
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor(red: 25/255.0, green: 25/255.0, blue: 120/255.0,
                alpha: 1.0).cgColor,
            UIColor(red: 100/255.0, green: 10/255.0, blue: 150/255.0, alpha: 1.0).cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0 , y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(self.gradient)
        view.addSubview(backButton)
        view.addSubview(feelingsTable)
        callResult = showFeelings(email: userEmail!, password: userPass!)
        print(callResult!.password!)
        print(callResult!.email!)
    }// viewDidLoad()
    func numberOfSections(in feelingsTable: UITableView) -> Int {
        return 1
    }

    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "mediadownloadback", sender: nil)
        
    }
    func showFeelings(email: String, password: String) -> User {
        var userData:Data = Data()
        var decoded = User()
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\r\n \"email\":\"" + email + "\"\r\n ,\"password\":\"" + password + "\"}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://localhost:3000/showfeels")!,timeoutInterval: Double.infinity)
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
            print(data)
            userData = Data(data)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            decoded = try jsonDecoder.decode(User.self, from: userData)
           
        }catch{
            print("decodederr: " + "\(error.localizedDescription)")
        }
        return decoded
    }
    struct User: Codable{
        var _id: String?
        var email: String?
        var password: String?
        var name: String?
        var feelings: [String]?
        
        enum CodingKeys: String, CodingKey {
            case _id = "_id"
            case email
            case password
            case name
            case feelings
        }
    } // struct User
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mediadownloadback"){
            let displayNext = segue.destination as! MediaDownload
            displayNext.userEmail = userEmail
            displayNext.userPassword = userPass
        }
    } // prepare()
} // class

extension ViewFeelings: UITableViewDelegate{
    // todo
    // add interactivity with Table view here...

}
extension ViewFeelings: UITableViewDataSource{
    
    func tableView(_ feelingsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return callResult!.feelings!.count
    }
    func tableView(_ feelingsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feelingsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let feel = callResult!.feelings![indexPath.row]
        cell.textLabel?.text = feel
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
       
        return cell
    }
    func tableView(_ feelingsTable: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "Hi \(callResult!.name!)! Theses are your feels..."
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

} // View Feeling Data extention
