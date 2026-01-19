import UIKit

extension ApiManage {
    func getDataHome(completion: @escaping ApiCompletion) {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let url = "\(baseUrl)/api/v2/home?v=\(appVersion ?? "\(Date().timeIntervalSince1970)")"
        let params: FlixDictionary = [:]
        let headers: [String: String]? = [:]
        request(urlString: url, param: params, headers: headers, method: .get) { (response) in
            if response.success == false {
                let res = Response(error: "")
                completion(res)
            } else {
                if let data = response.data as? FlixDictionary {
                    if data["data"] != nil {
                        let homeData = HomeData()
                        let allData = data["data"] as! FlixDictionary
                        
                        let listCategories = allData["categories"] as! [FlixDictionary]
                        var templates = [Templates]()
                        for item in listCategories {
                            let category = item["category"] as! String
                            let listTemplates = item["templates"] as! [FlixDictionary]
                            for template in listTemplates {
                                let value = Templates(data: template)
                                value.category = category
                                if templates.filter({$0.code == value.code}).isEmpty {
                                    templates.append(value)
                                } else {
                                    let listExist = templates.filter({$0.code == value.code})
                                    for exist in listExist {
                                        var cate = exist.category.components(separatedBy: ";")
                                        if cate.filter({$0 == value.category}).isEmpty {
                                            cate.append(value.category)
                                        }
                                        exist.category = cate.joined(separator: ";")
                                    }
                                }
                            }
                        }
                        
                        homeData.templates = templates
                        let listPrompts = allData["prompts"] as! [String]
                        homeData.prompts = listPrompts
                        let res = Response(true, data: homeData)
                        completion(res)
                    } else {
                        let res = Response(error: data["message"] as? String ?? "")
                        completion(res)
                    }

                } else {
                    let res = Response(error: "")
                    completion(res)
                }
            }
        }
    }
}
