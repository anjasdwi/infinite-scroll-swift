//
//  APICaller.swift
//  infinite_scroll
//
//  Created by Anjas Dwi on 11/08/20.
//  Copyright © 2020 Anjas Dwi. All rights reserved.
//

import Foundation

class APICaller {
    var isPagination = false
    func fetchData(pagination: Bool = false, completion: @escaping (Result<[String], Error>) -> Void) {
        if pagination {
            isPagination = true
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2), execute: {
            let originalData = [
                "Apple",
                "Google",
                "FaceBook",
                "Apple",
                "Google",
                "FaceBook",
                "Apple",
                "Google",
                "FaceBook",
                "Apple",
                "Google",
                "FaceBook",
                "Apple",
                "Google",
                "FaceBook",
                "Apple",
                "Google",
                "FaceBook",
                "Apple",
                "Google",
                "FaceBook",
            ]
            
            let newData = [
                "Banana", "Orange", "Grapes", "Food"
            ]
            
            completion(.success(pagination ? newData : originalData ))
            if pagination {
                self.isPagination = false
            }
        })
    }
}
