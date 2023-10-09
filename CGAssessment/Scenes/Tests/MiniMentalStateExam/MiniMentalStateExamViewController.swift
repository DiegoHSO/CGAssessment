//
//  MiniMentalStateExamViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import UIKit

protocol MiniMentalStateExamDisplayLogic: AnyObject {
    func route(toRoute route: MiniMentalStateExamModels.Routing)
    func presentData(viewModel: MiniMentalStateExamModels.ControllerViewModel)
}

class MiniMentalStateExamViewController: UIViewController, MiniMentalStateExamDisplayLogic {

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = MiniMentalStateExamModels.Section
    private typealias Row = MiniMentalStateExamModels.Row

    private var viewModel: MiniMentalStateExamModels.ControllerViewModel?
    private var interactor: MiniMentalStateExamLogic?
    private var router: MiniMentalStateExamRoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.miniMentalStateExamination.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: MiniMentalStateExamLogic, router: MiniMentalStateExamRouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: MiniMentalStateExamModels.Routing) {
        switch route {
        case .testResults(let test, let results, let cgaId):
            router?.routeToTestResults(test: test, results: results, cgaId: cgaId)
        }
    }

    func presentData(viewModel: MiniMentalStateExamModels.ControllerViewModel) {
        self.viewModel = viewModel

        tableView?.reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: TitleTableViewCell.self)
        tableView?.register(cellType: SelectableTableViewCell.self)
        tableView?.register(cellType: BinaryOptionsTableViewCell.self)
        tableView?.register(cellType: ImageTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension MiniMentalStateExamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let currentSection = Section(rawValue: section) else { return .leastNormalMagnitude }
        switch currentSection {
        case .secondQuestion, .thirdQuestion, .fourthQuestion, .fifthQuestion, .done:
            return CGFloat(20)
        case .seventhBinaryQuestion:
            return CGFloat(10)
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension MiniMentalStateExamViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        return viewModel.sections[currentSection]?.count ?? 0
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section),
              let row = viewModel.sections[section]?[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

        switch row {
        case .question:
            guard let questionViewModel = viewModel.questions[section] else { return UITableViewCell(frame: .zero) }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: questionViewModel.question, options: questionViewModel.options,
                                        delegate: interactor, selectedQuestion: questionViewModel.selectedOption,
                                        leadingConstraint: 35, textStyle: .regular))

            return cell
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

            return cell
        case .binaryQuestion:
            guard let questionViewModel = viewModel.binaryQuestions[section] else { return UITableViewCell(frame: .zero) }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: BinaryOptionsTableViewCell.className,
                                                           for: indexPath) as? BinaryOptionsTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: questionViewModel)

            return cell
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.className,
                                                           for: indexPath) as? TitleTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.miniMentalStateExamFifthQuestion.localized, leadingConstraint: 35, bottomConstraint: 0, fontStyle: .medium, fontSize: 16)

            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.className,
                                                           for: indexPath) as? ImageTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(image: UIImage(named: "miniMentalStateExam"), bottomConstraint: 0)

            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = Section(rawValue: section) else { return nil }

        if currentSection != .done {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            let headerTitle: String

            switch currentSection {
            case .firstQuestion:
                headerTitle = LocalizedTable.education.localized
            case .firstBinaryQuestion:
                headerTitle = LocalizedTable.timeOrientation.localized
            case .secondBinaryQuestion:
                headerTitle = LocalizedTable.spaceOrientation.localized
            case .thirdBinaryQuestion:
                headerTitle = LocalizedTable.immediateMemory.localized
            case .fourthBinaryQuestion:
                headerTitle = LocalizedTable.attentionAndCalculation.localized
            case .fifthBinaryQuestion:
                headerTitle = LocalizedTable.evocationMemory.localized
            case .sixthBinaryQuestion:
                headerTitle = LocalizedTable.language.localized
            default:
                headerTitle = ""
            }

            header.setup(title: headerTitle, backgroundColor: .primary, leadingConstraint: 25)

            return header
        }

        return nil
    }
}
