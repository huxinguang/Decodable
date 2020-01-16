//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//struct Course: Decodable {
//    let id: Int
//    let name: String
//    let link: String
//    let imageUrl: String
//    let number_of_lessons: Int
//}

struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let number_of_lessons: Int?
}

struct WebsiteDescription: Decodable{
    let name: String?
    let description: String?
    let courses: [Course]?
}

private let course_url = "https://api.letsbuildthatapp.com/jsondecodable/course"
private let courses_url = "https://api.letsbuildthatapp.com/jsondecodable/courses"
private let website_description_url = "https://api.letsbuildthatapp.com/jsondecodable/website_description"
private let courses_missing_fields_url = "https://api.letsbuildthatapp.com/jsondecodable/courses_missing_fields"
private let urls = [course_url,courses_url,website_description_url,courses_missing_fields_url]

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        let titles = ["course","courses","website_description","courses_missing_fields"]
        for i in 0..<titles.count {
            let button = UIButton()
            button.tag = i
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        view.addSubview(stackView)
        NSLayoutConstraint.activate(
            [NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
             NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)]
        )
        self.view = view
    }
    
    @objc func onButtonClick(sender: UIButton) {
        print(urls[sender.tag])
        guard let url = URL(string: urls[sender.tag]) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                switch sender.tag {
                case 0:
                    let course = try JSONDecoder().decode(Course.self, from: data)
                    print(course.name ?? "")
                case 1:
                    let courses = try JSONDecoder().decode([Course].self, from: data)
                    print(courses[0].name ?? "")
                case 2:
                    let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                    print(websiteDescription.name ?? "")
                case 3:
                    let courses = try JSONDecoder().decode([Course].self, from: data)
                    print(courses[0].name ?? "")
                default:
                    break
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
