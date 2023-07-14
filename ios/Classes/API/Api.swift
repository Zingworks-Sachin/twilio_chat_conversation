import Alamofire


class TwilioApi {
    
    static let baseUrl: String = "Enter your url to generate access token"
    
    static func requestTwilioAccessToken(identity: String,completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Basic your_base64_encoded_credentials" // Replace with your base64-encoded Twilio credentials
        ]
        
        let url:String = baseUrl+"?identity=\(identity)"
//        print("url-->\(url)")
        AF.request(url,method: .get, headers: headers).validate().responseString { response in
            switch response.result {
            case .success(let accessToken):
                let result = convertStringToJSON(string: accessToken)
                switch result {
                case .success(let json):
                    if (json["statusCode"] as! Int == 200){
                        completion(.success(json["token"] as! String))
                    }else {
                        completion(.success("Error"))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func convertStringToJSON(string: String) -> Result<[String: Any], Error> {
        // Convert the string to data
        guard let data = string.data(using: .utf8) else {
            return .failure(NSError(domain: "StringToDataConversionError", code: 0, userInfo: nil))
        }
        
        // Deserialize the data into a JSON object
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return .failure(NSError(domain: "JSONDeserializationError", code: 0, userInfo: nil))
            }
            return .success(jsonObject)
        } catch {
            return .failure(error)
        }
    }
}
