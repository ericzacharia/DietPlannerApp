//
//  FoodService.swift
//  DietPlanner
//
//  Created by Eric Zacharia on 4/9/21.
//

import Foundation

enum FoodCallingError: Error {
    case problemGeneratingURL
    case problemGettingDataFromAPI
    case problemDecodingData
}

class FoodService {
    private let urlString = "https://run.mocky.io/v3/d7923bf9-0d49-4a30-b6b5-5f0dc8bbf2d7"
//    private let urlString = "https://run.mocky.io/v3/9fc0d152-64f5-4507-a10a-0bd88ac939e6" // Empty API
    
    func getFood(completion: @escaping ([Food]?, Error?) -> ()) {
            guard let url = URL(string: self.urlString) else {
                DispatchQueue.main.async { completion(nil, FoodCallingError.problemGeneratingURL) }
                return
        }
        

            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async { completion(nil, FoodCallingError.problemGettingDataFromAPI) }
                    return
                }
                
                
                do {
                    let foodResult = try JSONDecoder().decode(FoodResult.self, from: data)
                    DispatchQueue.main.async { completion(foodResult.foods, nil) }
                } catch (let error) {
                    print(error)
                    DispatchQueue.main.async { completion(nil, FoodCallingError.problemDecodingData) }
                }
                                                        
            }
            task.resume()
        }
}





                
            
                
                
          
