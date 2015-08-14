//
// Created by Anastasiya Gorban on 8/13/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var fullName: UILabel!
    
    let viewModel: UserViewModel
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "UserViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullName.text = viewModel.fullName
        email.text = viewModel.email
    }
    
    @IBAction func logout(sender: AnyObject) {
        viewModel.logout()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
