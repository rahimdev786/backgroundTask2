//
//  ViewController.swift
//  backgroundTask2
//
//  Created by arshad on 5/7/22.
//


struct models:Codable{
    let id:Int?
    let title:String?
}


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        NotificationCenter.default.addObserver(forName: .postData, object: nil, queue: nil) { notication in
           print(notication.userInfo as? [Any])
        }
    }
}

class NetworkManagerService
{
    static let shared:NetworkManagerService = NetworkManagerService()
    private init(){}
    func PaserAnyData<T:Codable>(HttpUrlName:String,method:String ,EncodeData:Data? ,_ result:T.Type ,handler:@escaping (Result<T,APIError>)->Void)
    {
        guard let url = URL(string: HttpUrlName) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        URLSession.shared.dataTask(with: urlRequest) { data, responce, err in
            
          if err != nil
            {
              handler(.failure(.ErrorInUrl))
            }
            
            guard let data = data else {
               
                handler(.failure(.ErrorInData))
                return
            }
            
            guard let responce = responce as? HTTPURLResponse else {
                handler(.failure(.ResponceIncorrect))
                return
            }
            
            guard (200...299).contains(responce.statusCode) else {
                handler(.failure(.ResponceCode(responce.statusCode)))
              return
            }
            
            do {
              let Result =   try JSONDecoder().decode(T.self, from: data)
                handler(.success(Result))
            } catch  {
                handler(.failure(.SeesionOut))
            }
       
    
        }.resume()
    }
}





enum APIError:Error {
case ErrorInEncodeData,ErrorInUrl,ResponceIncorrect,SeesionOut,ErrorInData
    case ResponceCode(Int)
    
    var errorDEc:String{
        switch self {
        case .ErrorInEncodeData:
            return "Oppps Datalast"
        case .ErrorInUrl:
            return "Oppps Datalast"
        case .ResponceIncorrect:
            return "Oppps Datalast"
        case .SeesionOut:
            return "Oppps Datalast"
        case .ErrorInData:
            return "Oppps Datalast"
        case .ResponceCode(let int):
            return "Oppps Datalast \(int) "
        }
    }
}
