//
// Created by Anastasiya Gorban on 8/13/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation
import UIKit
import Bond

class LoginViewController: UIViewController {
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    let loginViewModel: LoginViewModel
    
    init(loginViewModel: LoginViewModel){
        self.loginViewModel = loginViewModel
        super.init(nibName: "LoginViewController", bundle: nil)
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        email.dynText ->> loginViewModel.email
        password.dynText ->> loginViewModel.password
        loginViewModel.error ->> error.dynText
        loginViewModel.loginInProccess ->> loader.dynIsAnimating
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func login(sender: AnyObject) {
        loginViewModel.login()
    }
}
