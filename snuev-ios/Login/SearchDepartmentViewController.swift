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
    @IBOutlet weak var searchQuery: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchQuery.becomeFirstResponder()
    }
    
    func bind(reactor: SearchDepartmentViewReactor) {
        searchQuery.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.departments }
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { indexPath, dept, cell in
                cell.textLabel?.text = dept.name
            }
            .disposed(by: disposeBag)
    
        // View
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self, weak reactor] indexPath in
                guard let `self` = self else { return }
                guard let department = reactor?.currentState.departments[indexPath.row] else { return }
                reactor!.popToSignup(department: department)
            })
            .disposed(by: disposeBag)
    }
}


