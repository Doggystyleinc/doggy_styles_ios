//
//  ServiceSingleton.swift
//  DSGroomer
//
//  Created by Charlie Arcodia on 6/29/21.
//

/*
 
 FUNCTION CALL:
 request_for_pin - HERE WE ASK FOR A PIN TO BE SENT TO THE GIVEN PHONE NUMBER, RESPONSES ARE 'ok' || 'failed'
 request_for_authorization - HERE WE ASK TO VALIDATE THE USERS ENTERTED PIN, RESPONSES ARE 'ok' || 'failed'
 
 REQUIRED PARAMETERS
 request_for_pin:
 const users_country_code = req.body.users_country_code;
 const users_phone_number = req.body.users_phone_number;
 const delivery_method = req.body.delivery_method;
 
 request_for_authorization:
 const users_country_code = req.body.users_country_code; 
 onst users_phone_number = req.body.users_phone_number;
 const entered_code = req.body.entered_code;
 */

import Foundation

final class ServiceHTTP : NSObject {
    
    //MARK: - SINGLETON FOR SHARES SERVICE
    static let shared = ServiceHTTP()
    
    func twilioGetRequest(function_call: String, users_country_code: String, users_phone_number: String, delivery_method : String, entered_code : String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters : [String : Any] = ["function_call": function_call, "users_country_code": users_country_code, "users_phone_number" : users_phone_number, "delivery_method" : delivery_method, "entered_code" : entered_code]
        
        let slug = "twilio_auth"
        
        //create the url with NSURL
        let url = URL(string: "https://doggystyle-backend.herokuapp.com/\(slug)")!

        //create the session object
        let session = URLSession.shared
        
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            print("six:")

            completion(nil, error)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                
                completion(json, nil)
            } catch let error {

                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        task.resume()
    }
}
