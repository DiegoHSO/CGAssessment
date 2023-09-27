//
//  GripStrengthViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

protocol GripStrengthDisplayLogic: AnyObject {
    func route(toRoute route: GripStrengthModels.Routing)
    func presentData(viewModel: GripStrengthModels.ControllerViewModel)
}

class GripStrengthViewController: UIViewController, GripStrengthDisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = GripStrengthModels.Section
    private typealias Row = GripStrengthModels.Row

    private var viewModel: GripStrengthModels.ControllerViewModel?
    private var interactor: GripStrengthLogic?
    private var router: GripStrengthRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.controllerDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: GripStrengthLogic, router: GripStrengthRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: GripStrengthModels.Routing) {
        switch route {
        case .testResults(let test, let results):
            router?.routeToTestResults(test: test, results: results)
        }
    }

    func presentData(viewModel: GripStrengthModels.ControllerViewModel) {
        self.viewModel = viewModel

        tabBarController?.tabBar.isHidden = true
        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        title = LocalizedTable.gripStrength.localized

        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: InstructionsTableViewCell.self)
        tableView?.register(cellType: ImageTableViewCell.self)
        tableView?.register(cellType: TextFieldTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension GripStrengthViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentSection = Section(rawValue: section) else { return .leastNormalMagnitude }
        return currentSection == .done ? .leastNormalMagnitude : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension GripStrengthViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        switch currentSection {
        case .instructions:
            return viewModel.sections[.instructions]?.count ?? 0
        case .measurement:
            return viewModel.sections[.measurement]?.count ?? 0
        case .done:
            return viewModel.sections[.done]?.count ?? 0
        }
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section) else { return UITableViewCell(frame: .zero) }

        switch viewModel.sections[section]?[safe: indexPath.row] {
        case .instructions:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstructionsTableViewCell.className,
                                                           for: indexPath) as? InstructionsTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(instructions: viewModel.instructions))

            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.className,
                                                           for: indexPath) as? ImageTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(image: UIImage(named: viewModel.imageName ?? ""))

            return cell
        case .firstTextField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className,
                                                           for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: LocalizedTable.firstMeasurement.localized, text: viewModel.typedFirstMeasurement,
                                        placeholder: LocalizedTable.strengthPlaceholder.localized, delegate: interactor,
                                        keyboardType: .decimalPad, identifier: .firstMeasurement))

            return cell
        case .secondTextField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className,
                                                           for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: LocalizedTable.secondMeasurement.localized, text: viewModel.typedSecondMeasurement,
                                        placeholder: LocalizedTable.strengthPlaceholder.localized, delegate: interactor,
                                        keyboardType: .decimalPad, identifier: .secondMeasurement))

            return cell
        case .thirdTextField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.className,
                                                           for: indexPath) as? TextFieldTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: LocalizedTable.thirdMeasurement.localized, text: viewModel.typedThirdMeasurement,
                                        placeholder: LocalizedTable.strengthPlaceholder.localized, delegate: interactor,
                                        keyboardType: .decimalPad, identifier: .thirdMeasurement))

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

            return cell
        default:
            return UITableViewCell()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = Section(rawValue: section) else { return nil }

        if currentSection == .instructions || currentSection == .measurement {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            header.setup(title: currentSection == .instructions ? LocalizedTable.instructions.localized
                            : LocalizedTable.measurement.localized.capitalized, backgroundColor: .primary,
                         leadingConstraint: currentSection == .instructions ? 25 : 30)

            return header
        }

        return nil
    }
}
