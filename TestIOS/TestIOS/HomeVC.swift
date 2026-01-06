import UIKit

class HomeVC: UIViewController {

    var titles: [String] = ["iOS", "Android"]
    var names: [[String]] =
           [
            ["Tí", "Tèo", "Hùng", "Lam", "Thuỷ", "Tuấn", "Trung", "Hạnh","Tí", "Tèo", "Hùng", "Lam", "Thuỷ", "Tuấn", "Trung", "Hạnh"],
            ["Bình", "Khánh", "Toàn", "Tâm", "An", "Hương", "Huy", "Quang", "Vân", "Đài", "Tiến","Bình", "Khánh", "Toàn", "Tâm", "An", "Hương", "Huy", "Quang", "Vân", "Đài", "Tiến"]
           ]
    
    @IBOutlet weak var tableView: UITableView!
    var viewmodel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        loadAPI()
        API.shared().request(url: URL(string: "https://fgios.aritek.app/api/v1/home")!) { result in
            switch result {
            case .failure(let error):
                print("API Error: \(error.localizedDescription)")
                
            case .success(let data):
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                // Parse JSON
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Failed to parse JSON")
                    return
                }
                
                print("JSON parsed successfully")
                
                // Parse response
                let response = HomeViewModel.HomeResponse(json: json)
                
                print("Success: \(response.success)")
                print("Templates count: \(response.data.templates.count)")
                print("Explores count: \(response.data.explores.count)")
                print("Prompts count: \(response.data.prompts.count)")
                
                // Update UI with parsed data
                DispatchQueue.main.async {
                    // Clear existing data
                    self.titles = []
                    self.names = []
                    
                    // Add templates section
                    if !response.data.templates.isEmpty {
                        self.titles.append("Templates")
                        let templateNames = response.data.templates.map { $0.name }
                        self.names.append(templateNames)
                    }
                    
                    // Add explores section
                    if !response.data.explores.isEmpty {
                        self.titles.append("Explores")
                        let exploreNames = response.data.explores.map { $0.name }
                        self.names.append(exploreNames)
                    }
                    
                    // Reload table view
                    self.updateUI()
                    
                    print("UI updated with \(self.titles.count) sections")
                }
            }
        }
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    @objc func loadAPI() {
        print("LOAD API")
        viewmodel.loadAPI3 { (done, msg) in
            if done {
                self.updateUI()
            } else {
                print("API ERROR: \(msg)")
            }
        }
    }

}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell: \( names[indexPath.section][indexPath.row])")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DetailVC()
        vc.name =  names[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
