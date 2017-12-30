//
//  SettingsViewController.swift
//  DarkCloudy
//
//  Created by Scott moon on 30/12/2017.
//  Copyright © 2017 Scott moon. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func controllerDidChangeTimeNotation(controller: SettingsViewController)
    func controllerDidChangeUnitsNotation(controller: SettingsViewController)
    func controllerDidChangeTemperatureNotation(controller: SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -
    var delegate: SettingsViewControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

private extension SettingsViewController {
    func setupView() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(UINib(nibName: SettingViewCell.nibName, bundle: nil), forCellReuseIdentifier: SettingViewCell.reuseIdetifier())
    }
}

private extension SettingsViewController {
    func setupNavigationBar() {
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissController))
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}

private extension SettingsViewController {
    enum Section: Int {
        case time
        case unit
        case temperature
        
        
        // MARK: - Properties
        var title: String {
            switch self {
            case .time: return "Time"
            case .unit: return "Unit"
            case .temperature: return "Temperature"
            }
        }
        
        var numberOfRows: Int {
            return 2
        }
        
        static var count: Int {
            return (Section.temperature.rawValue + 1)
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { fatalError("Unexpected Section") }
        return section.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.reuseIdetifier(), for: indexPath) as? SettingViewCell else {
            return UITableViewCell()
        }
        
        var viewModel: SettingsRepresentable?
        
        switch section {
        case .time:
            guard let timeNotaion = TimeNotation(rawValue: indexPath.row) else {
                fatalError("Unexpected Index Path")
            }
            
            viewModel = SettingsViewTimeViewModel(timeNotation: timeNotaion)
        case .unit:
            guard let unitsNotation = UnitsNotation(rawValue: indexPath.row) else {
                fatalError("Unexpected Index Path")
            }
            
            viewModel = SettingsViewUnitsViewModel(unitsNotation: unitsNotation)
        case .temperature:
            guard let temperatureNotation = TemperatureNotation(rawValue: indexPath.row) else {
                fatalError("Unexpected Index Path")
            }
            
            viewModel = SettingsViewTemperatureViewModel(temperatureNotation: temperatureNotation)
        }
        
        if let viewModel = viewModel {
            // Configure Cell
            cell.configure(viewModel: viewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { fatalError("Unexpected Section") }
        return section.title
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section  = Section(rawValue: indexPath.section) else { fatalError("Unexpected Section") }
        
        switch section {
        case .time:
            let timeNotation = UserDefaults.getTimeNotation()
            guard indexPath.row != timeNotation.rawValue else { return }
            guard let newTimeNotation = TimeNotation(rawValue: indexPath.row) else { return }
            
            // Update User Defaults
            UserDefaults.setTimeNotation(timeNotation: newTimeNotation)
            
            // Notify Delegate
            delegate?.controllerDidChangeTimeNotation(controller: self)
            break
        case .unit:
            let unitsNotation = UserDefaults.getUnitsNotation()
            guard indexPath.row != unitsNotation.rawValue else { return }
            guard let newUnitNotation = UnitsNotation(rawValue: indexPath.row) else { return }
            
            // Update User Defaults
            UserDefaults.setUnitsNotation(unitsNotation: newUnitNotation)
            
            // Notify Delegate
            delegate?.controllerDidChangeUnitsNotation(controller: self)
            
            break
        case .temperature:
            
            let temperatureNotation = UserDefaults.getTemperatureNotation()
            guard indexPath.row != temperatureNotation.rawValue else { return }
            guard let newTemperatureNotation = TemperatureNotation(rawValue: indexPath.row) else { return }
            
            // Update User Defaults
            UserDefaults.setTemperatureNotation(temperatureNotation: newTemperatureNotation)
            
            // Notify Delegate
            delegate?.controllerDidChangeTemperatureNotation(controller: self)
            
            break
        }
        
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
}


