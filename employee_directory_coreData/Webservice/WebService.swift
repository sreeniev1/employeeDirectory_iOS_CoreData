//
//  WebService.swift

//  Created by Sreeni E V on 16/09/22.
//

import Foundation

class WebService {
    
    var session = URLSession.shared

    func makeRequest(url: URL, completion: @escaping (HTTPURLResponse?, _ rawData: Data?, Error?) -> Void) {
        
        let task = session.dataTask(with: url) { data, response, error in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode
                else {
                    // handle invalid Http return code
                    completion(nil, nil, error)
                    return
                }
                completion(httpResponse, data, nil)
            }
        task.resume()
    }
}
