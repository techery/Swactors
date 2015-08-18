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
    
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel){
        self.viewModel = viewModel
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()        
    }
    
    private func bindViewModel() {
        email.dynText ->> viewModel.email
        password.dynText ->> viewModel.password
        viewModel.error ->> error.dynText
        viewModel.loginInProccess ->> loader.dynIsAnimating
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func login(sender: AnyObject) {
        viewModel.login().thenOnMain({_ in
            let userViewController = UserViewController(viewModel: self.viewModel.userViewModel)
            self.presentViewController(userViewController, animated: true, completion: nil)
            return nil
        }, nil)
    }
}
