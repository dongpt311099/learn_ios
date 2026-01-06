import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var lbName: UILabel!
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbName.text = name
    }

}
