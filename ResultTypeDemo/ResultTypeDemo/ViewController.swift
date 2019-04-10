//
//  ViewController.swift
//  ResultTypeDemo
//
//  Created by 洋蔥胖 on 2019/4/10.
//  Copyright © 2019 ChrisYoung. All rights reserved.
//

import UIKit

struct Course: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
    let number_of_lessons: Int
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchCoursesJson { (result) in
            
            switch result {
            case .success(let courses):
                courses.forEach({ (course) in
                    print(course.name)
                })
                
            case .failure(let error):
                print("failed 沒拿到courses", error)
                }
            
            }
            
            
        
        
//        fetchCoursesJson { (courses, error) in
//            //ambiguous situation here
//
//
//            if let err = error {
//                print("沒拿到courses", err)
//                return
//            }
//
//            courses?.forEach({ (course) in
//                print(course.name)
//            })
//        }
    }

    // 拿到課程的json 如果成功會是一個[Course] 失敗給個eroor
    //enum Result<Success, Failure> where Failure : Error
    // @escaping ([Course]?, Error?) 改成 @escaping (Result<[Course],Error>)
    fileprivate func fetchCoursesJson(completion: @escaping (Result<[Course],Error>) -> ()
        ){
        
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            
            if let err  = error {
//                completion(nil,err)
                completion(.failure(err))
                return
            }
            
            // successful
            do{
                let courses = try JSONDecoder().decode([Course].self, from: data!)
                
//                completion(courses, nil)
                completion(.success(courses))
                
            }catch let jsonError{
//                completion(nil, jsonError)
                completion(.failure(jsonError))
            }
            

        }.resume()
            
       
        
    }
}

