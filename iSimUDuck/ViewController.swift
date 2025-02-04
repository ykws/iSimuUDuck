//
//  ViewController.swift
//  iSimUDuck
//
//  Created by KAWASHIMA Yoshiyuki on 2021/08/28.
//

import UIKit

// MARK: - Enumerations

enum TableSection: Int, CaseIterable {
    case duck
    case behavior
    case simulate

    func title() -> String {
        switch self {
        case .duck: return "Duck"
        case .behavior: return "Behavior"
        case .simulate: return "Simulate"
        }
    }
}

enum DuckBehavior: Int, CaseIterable {
    case quack
    case swim
    case fly

    func title() -> String {
        switch self {
        case .quack: return "Quack"
        case .swim: return "Swim"
        case .fly: return "Fly"
        }
    }
}

// MARK: - UIViewController

class ViewController: UIViewController {
    
    // MARK: - IBOutlet

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property

    let ducks = [MallardDuck(), RedheadDuck(), RubberDuck()]
    var selectedDuck: Duck?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let tableSection = TableSection(rawValue: section) else {
            return nil
        }

        return tableSection.title()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section) {
        case .duck:
            return ducks.count
        case .behavior:
            return DuckBehavior.allCases.count
        case .simulate:
            return 1
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch TableSection(rawValue: indexPath.section) {
        case .duck:
            guard let duck = ducks[indexPath.row] as? DuckDisplayable else {
                return cell
            }
            
            cell.textLabel?.text = duck.display()
        case .behavior:
            guard let duckBehavior = DuckBehavior(rawValue: indexPath.row) else {
                return cell
            }

            cell.textLabel?.text = duckBehavior.title()
        case .simulate:
            cell.textLabel?.text = "🚀"
        case .none:
            break
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableSection(rawValue: indexPath.section) {
        case .duck:
            selectedDuck = ducks[indexPath.row]
        case .behavior:
            guard let duck = selectedDuck else {
                return
            }

            switch DuckBehavior(rawValue: indexPath.row) {
            case .quack:
                showAlert(message: duck.performQuack())
            case .swim:
                showAlert(message: duck.swim())
            case .fly:
                showAlert(message: duck.performFly())
            case .none:
                break
            }
        case .simulate:
            if selectedDuck != nil {
                selectedDuck?.flyBehavior = FlyRocketPowered()
            }
        case .none:
            break
        }
    }
}

// MARK: - Alert

extension ViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                alert.dismiss(animated: true)
            }
        }
    }
}
