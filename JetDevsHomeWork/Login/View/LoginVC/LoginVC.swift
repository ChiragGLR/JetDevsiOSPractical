//
//  LoginVC.swift
//  JetDevsHomeWork
//
//  Created by Chirag on 23/2/2024.
//

import UIKit
import RxSwift
import RxCocoa
import MaterialComponents

class LoginVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var btnCloseOutlet: UIButton!
    @IBOutlet weak var btnLoginOutlet: UIButton!
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtPassword: MDCOutlinedTextField!
    
    // MARK: - Variables
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
        bindViewModel()
    }

    // MARK: - Custom Methods
    
    /// Set Textfields with animation
    private func setTextFields() {
        txtEmail.label.text = emailStr
        txtEmail.placeholder = emailStr
        
        txtPassword.label.text = passwordStr
        txtPassword.placeholder = passwordStr
        
        txtEmail.setOutlineColor(.lightGray, for: .editing)
        txtEmail.setOutlineColor(.lightGray, for: .normal)
        txtPassword.setOutlineColor(.lightGray, for: .editing)
        txtPassword.setOutlineColor(.lightGray, for: .normal)
    }
    
    /// Binding ViewModel
    private func bindViewModel() {
        
        /// Email Binding
        txtEmail.rx.text
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        /// Password Binding
        txtPassword.rx.text
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        /// Login Button BInding
        viewModel.isValidCredentials()
            .bind(to: btnLoginOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValidCredentials().map { isValid in
            return isValid ? UIColor(named: "btnEnableColor") : .lightGray
        }.bind(to: btnLoginOutlet.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        /// Observers handle loader
        viewModel.loadView
            .asObserver()
            .subscribe(onNext: { isLoading in
                DispatchQueue.main.async {
                    isLoading ? AppLoader.showLoading(loadingStr, disableUI: true) : AppLoader.hide()
                }
            })
            .disposed(by: disposeBag)
        
        /// Observers handle result
        viewModel.resultSubject
            .asObservable()
            .subscribe(onNext: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let response):
                        // User info needs to be saved locally.
                        if let user = response.data?.user {
                            UserDefaultManager.shared.saveJson(user, forKey: loggedInUserStr)
                        }
                        self?.dismissVC()
                        
                    case .failure(let errorMessage):
                        if let self = self {
                            AlertManager.shared.showAlert(title: "OOPS!", message: errorMessage, from: self)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @IBAction func btnLoginAction(_ sender: UIButton) {
        viewModel.performLogin()
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
