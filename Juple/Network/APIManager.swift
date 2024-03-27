//
//  APIManager.swift
//  Juple
//
//  Created by 박소진 on 2024/03/27.
//

import Foundation

struct APIManager {
    
    private init() { }
    
    static func fetchAllmarket(completion: @escaping ([Market])-> Void ) {
        
        guard let url = URL(string: "https://api.upbit.com/v1/market/all") else {
            print("url 에러")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data else {
                print("데이터 응답 없음")
                return
            }
            print("======Call!!!!!!!")
            do {
                let decodedData = try JSONDecoder().decode([Market].self, from: data)
                //print(decodedData) //구조체에 담았을 때의 출력 값
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            } catch {
                print(error)
            }
            
        }.resume()
        
    }
}
