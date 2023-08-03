//
//  CountryProvider.swift
//  Country-UiTable
//
//  Created by Laptop MCO on 02/08/23.
//

import Foundation

class CountryProvider{
    static let shared: CountryProvider = CountryProvider()
    private init(){ }
    
    func loadCountries() -> [Country] {
        if let url = Bundle.main.url(forResource: "country-flag", withExtension: "json"){
            do {
                let data = try Data(contentsOf: url)
                let countries = try JSONDecoder().decode([Country].self, from: data)
                return countries
                
            } catch{
                
            }
            
        }
        return []
    }
}
