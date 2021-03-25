//
//  MainViewModel.swift
//  Covid19ThailandDaily
//
//  Created by Kittiwat Eamkijkarn on 20/3/2564 BE.
//  Copyright © 2564 Kittiwat Eamkijkarn. All rights reserved.
//

import UIKit
import Alamofire

class MainViewModel {
    var pickerDataset: [String] = []
    var detailOfCountry: CMResponse?
    var selectedCountry: String = ""
    var pin: String = ""
    var row: Int = 0
    
    let defaults = UserDefaults.standard
    
    func savePin(pin: String) {
        defaults.set(pin, forKey: "keyPin")
        loadPin()
        print("save success \(pin)")
    }
    
    func loadPin() {
        if let stringOne = defaults.string(forKey: "keyPin") {
            self.pin = stringOne
            print(stringOne) // Some String Value
        }
        print("load fail")
    }
    
    func fecthData(pickerData: @escaping ([String], Int) -> ()) {
            AF.request("https://corona.lmao.ninja/v2/countries").responseDecodable(of: CMResponse.self) { (response) in
                guard let respon = response.value else{ return }
                respon.forEach{item in
                    guard let countryIso3 = item.countryInfo.iso3 else{ return }
                    self.pickerDataset.append(countryIso3)
                    guard countryIso3 == self.pin else{ return }
                    self.selectedCountry = self.pin
                    self.row = (self.pickerDataset.count - 1)
                }
                if self.selectedCountry == ""{
                    self.selectedCountry = self.pickerDataset[0]
                }
                pickerData(self.pickerDataset, self.row)
            }
        }
    func loadDetail(countryDetail: @escaping (CMOneResponse) -> ()) {
        AF.request("https://corona.lmao.ninja/v2/countries/\(selectedCountry)").responseDecodable(of: CMOneResponse.self ) { (countries) in
            guard let country = countries.value else{ return }
            print(country)
            countryDetail(country)
        }
    }
}
