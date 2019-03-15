//
//  SearchDepartment.swift
//  snuev-ios
//
//  Created by easi6 on 2019. 3. 2..
//  Copyright © 2019년 김동욱. All rights reserved.


import SafariServices

import UIKit
import ObjectMapper
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class SearchDepartmentViewController: SNUEVBaseViewController, StoryboardView {
    typealias Reactor = SearchDepartmentViewReactor
    var departments: [Department]?
    @IBOutlet weak var searchQuery: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: SearchDepartmentViewReactor) {
        searchQuery.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}


