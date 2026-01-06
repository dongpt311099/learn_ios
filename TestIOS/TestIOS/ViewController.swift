import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = TestVC()
        vc.someData = "ádasds"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

