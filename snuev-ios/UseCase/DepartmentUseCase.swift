//
//  DepartmentUseCase.swift
//  snuev-ios
//
//  Created by 이동현 on 2019. 4. 20..
//  Copyright © 2019년 이동현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import KeychainSwift

protocol DepartmentUseCase {
    func fetchDepartments() -> Observable<Resource<[Department]>>
}

class DefaultDepartmentUseCase: DepartmentUseCase {
    let service: Service
    
    init(service: Service) {
        self.service = service
    }

    func fetchDepartments() -> Observable<Resource<[Department]>> {
        return service.get("/v1/departments", parameters: nil, responseArrayType: Department.self)
    }
}

