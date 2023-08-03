//
//  ViewController.swift
//  Country-UiTable
//
//  Created by Laptop MCO on 02/08/23.
//

import UIKit
import SVGKit

class ViewController: UIViewController {

    @IBOutlet weak var tableViews: UITableView!
    
    
    var countries: [Country] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadCountries()
    }
    
    func setup(){
        tableViews.dataSource = self
        tableViews.delegate = self
    }
    
    func loadCountries(){
        self.countries = CountryProvider.shared.loadCountries()
    }
    
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void){
        DispatchQueue.global().async {
            if let imageUrl = URL(string: url),
               let data = try? Data(contentsOf: imageUrl){
                    
                let receivedimage: SVGKImage = SVGKImage(data: data)
                
                DispatchQueue.main.async {
                    completion(receivedimage.uiImage)
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL_ID", for: indexPath)

        let country = countries[indexPath.row]
        cell.textLabel?.text = country.emoji + " " + country.name + " (" + country.code + ")"
        cell.detailTextLabel?.text = country.unicode

        cell.imageView?.image = nil
        let tag = cell.tag + 1
        cell.tag = tag
        downloadImage(url: country.image) { receivedimage in
            if cell.tag == tag{
                cell.imageView?.image = receivedimage
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        let alert = UIAlertController(title: country.emoji + " " + country.name + " (" + country.code + ")" , message: country.unicode, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

extension UIImageView {
    func downloadedsvg(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let receivedicon: SVGKImage = SVGKImage(data: data),
                let image = receivedicon.uiImage
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}


