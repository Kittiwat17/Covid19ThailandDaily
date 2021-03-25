//
//  MainViewController.swift
//  Covid19ThailandDaily
//
//  Created by Kittiwat Eamkijkarn on 20/3/2564 BE.
//  Copyright © 2564 Kittiwat Eamkijkarn. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var countriesPicker: UIPickerView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var pinButton: UIButton!
    
    @IBOutlet weak var toDayCaseLabel: UILabel!
    @IBOutlet weak var toDayDeathsLabel: UILabel!
    @IBOutlet weak var toDayRecoveredLabel: UILabel!
    
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var recoveredLablel: UILabel!
    var viewModel = MainViewModel()
    
    var pickerData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.countriesPicker.delegate = self
        self.countriesPicker.dataSource = self
        viewModel.loadPin()
        viewModel.fecthData { (data, row) in
            self.pickerData = data
            self.countriesPicker.reloadAllComponents()
            self.viewModel.loadDetail { detail in
                self.setCountryDetail(detail: detail)
            }
            self.countriesPicker.selectRow(row, inComponent: 0, animated: true)
        }
        pinButton.backgroundColor = UIColor.green
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCountryDetail(detail: CMOneResponse){
        self.countryNameLabel.text = "name: \(detail.country)"
        self.toDayCaseLabel.text = "to day case: \(detail.todayCases)"
        self.toDayDeathsLabel.text = "to day case: \(detail.todayCases)"
        self.toDayRecoveredLabel.text = "to day recovered: \(detail.todayRecovered)"
        self.casesLabel.text = "cases: \(detail.cases)"
        self.deathsLabel.text = "deaths: \(detail.deaths)"
        self.recoveredLablel.text = "recovered: \(detail.recovered)"
    }
    
    @IBAction func pinButton(_ sender: UIButton) {
        viewModel.savePin(pin: viewModel.selectedCountry)
        self.pinButton.backgroundColor = UIColor.green
    }
}
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedCountry = pickerData[row]
        viewModel.loadDetail { detail in
            self.setCountryDetail(detail: detail)
        }
        self.pinButton.backgroundColor = UIColor.lightGray
        guard viewModel.pin == pickerData[row] else{ return }
        self.pinButton.backgroundColor = UIColor.green
    }
}

