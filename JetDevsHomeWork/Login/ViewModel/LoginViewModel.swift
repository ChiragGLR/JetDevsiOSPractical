//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Chirag on 23/2/2024.
//

import Foundation
import RxSwift
import RxCocoa

enum LoginResult {
    case success(CommonResponse)
    case failure(String)
}

class
LoginViewModel {
    let email = BehaviorRelay<String?>(value: "")
    let password = BehaviorRelay<String?>(value: "")
    
    let loadView = PublishSubject<Bool>()
    let resultSubject = PublishSubject<LoginResult>()
    
    func isValidCredentials() -> Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), password.asObservable()) { (email, password) in
            guard let email = email, let password = password else {
                return false
            }
            return isValidEmail(email) && password.count > 4
        }
    }
    
    func performLogin() {
        loadView.onNext(true)
        if let email = email.value, let password = password.value {
            return APIManager.shared.callAPI(endPoint: .login, parameters: [APIManager.Parameters.email: email, APIManager.Parameters.password: password], methodType: .POST) {[weak self] (result: Result<CommonResponse, APIError>) in
                self?.loadView.onNext(false)
                
                switch result {
                case .success(let response):
                    if (response.result == true) {
                        self?.resultSubject.onNext(.success(response))
                    } else {
                        self?.resultSubject.onNext(.failure(response.errorMessage ?? unknownErrorStr))
                    }
                case .failure(let error):
                    switch error {
                    case .requestFailed(let message):
                        self?.resultSubject.onNext(.failure(message))
                    default:
                        self?.resultSubject.onNext(.failure(unknownErrorStr))
                    }
                }
            }
        }
    }
}
