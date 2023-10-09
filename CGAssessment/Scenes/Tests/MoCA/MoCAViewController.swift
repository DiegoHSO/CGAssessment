//
//  MoCAViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit
import PhotosUI

protocol MoCADisplayLogic: AnyObject {
    func route(toRoute route: MoCAModels.Routing)
    func presentData(viewModel: MoCAModels.ControllerViewModel)
    func dismissPresentingController()
}

class MoCAViewController: UIViewController, MoCADisplayLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var tableView: UITableView?

    private typealias Section = MoCAModels.Section
    private typealias Row = MoCAModels.Row

    private var viewModel: MoCAModels.ControllerViewModel?
    private var interactor: MoCALogic?
    private var router: MoCARoutingLogic?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.controllerDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        title = LocalizedTable.moca.localized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        title = LocalizedTable.assessment.localized
    }

    // MARK: - Public Methods

    func setupArchitecture(interactor: MoCALogic, router: MoCARouter) {
        self.interactor = interactor
        self.router = router
    }

    func route(toRoute route: MoCAModels.Routing) {
        switch route {
        case .testResults(let test, let results, let cgaId):
            router?.routeToTestResults(test: test, results: results, cgaId: cgaId)
        case .imagePicker(let configuration, let delegate):
            router?.routeToImagePicker(configuration: configuration, delegate: delegate)
        case .camera:
            router?.routeToUserCamera(delegate: self)
        }
    }

    func presentData(viewModel: MoCAModels.ControllerViewModel) {
        self.viewModel = viewModel

        tableView?.reloadData()
    }

    func dismissPresentingController() {
        router?.dismissPresentingController()
    }

    // MARK: - Private Methods

    private func setupViews() {
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInsetAdjustmentBehavior = .never

        tableView?.register(headerType: TitleHeaderView.self)
        tableView?.register(cellType: TitleTableViewCell.self)
        tableView?.register(cellType: StepperTableViewCell.self)
        tableView?.register(cellType: ImageTableViewCell.self)
        tableView?.register(cellType: CentralizedTextTableViewCell.self)
        tableView?.register(cellType: GroupedButtonsTableViewCell.self)
        tableView?.register(cellType: SelectableTableViewCell.self)
        tableView?.register(cellType: BinaryOptionsTableViewCell.self)
        tableView?.register(cellType: ActionButtonTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource extensions

extension MoCAViewController: UITableViewDelegate {
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

extension MoCAViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSection = Section(rawValue: section), let viewModel else { return 0 }

        return viewModel.sections[currentSection]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel, let section = Section(rawValue: indexPath.section),
              let row = viewModel.sections[section]?[safe: indexPath.row] else { return UITableViewCell(frame: .zero) }

        switch row {
        case .done:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionButtonTableViewCell.className,
                                                           for: indexPath) as? ActionButtonTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.seeResults.localized, backgroundColor: .primary, delegate: interactor)

            return cell
        case .binaryQuestion:
            guard let questionViewModels = viewModel.binaryQuestions[section], let questionViewModel = questionViewModels[indexPath.row], let questionViewModel else { return UITableViewCell(frame: .zero) }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: BinaryOptionsTableViewCell.className,
                                                           for: indexPath) as? BinaryOptionsTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: questionViewModel)

            return cell
        case .instruction:
            guard let instructions = viewModel.instructions[section], let instruction = instructions[indexPath.row]??.localized else { return UITableViewCell(frame: .zero) }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.className,
                                                           for: indexPath) as? TitleTableViewCell else {
                return UITableViewCell()
            }

            let shouldChangeSpacing = section == .attention || section == .language || section == .delayedRecall

            cell.setup(title: instruction, leadingConstraint: 35, bottomConstraint: shouldChangeSpacing ? 0 : 20, fontStyle: .medium, fontSize: 16)

            return cell
        case .image, .circlesImage, .watchImage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.className,
                                                           for: indexPath) as? ImageTableViewCell else {
                return UITableViewCell()
            }

            switch row {
            case .circlesImage:
                cell.setup(image: viewModel.circlesImage, progress: viewModel.circlesProgress,
                           borderInImage: false)
            case .watchImage:
                cell.setup(image: viewModel.watchImage, bottomConstraint: 30, progress: viewModel.watchProgress,
                           borderInImage: false)
            default:
                guard let images = viewModel.images[section], let image = images[indexPath.row] else { return UITableViewCell(frame: .zero) }

                let keys = images.keys.sorted()
                if let index = keys.firstIndex(of: indexPath.row), index == keys.count - 1 {
                    cell.setup(image: image, bottomConstraint: 30)
                } else {
                    cell.setup(image: image)
                }
            }

            return cell
        case .selectionButtons:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupedButtonsTableViewCell.className,
                                                           for: indexPath) as? GroupedButtonsTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModels: viewModel.groupedButtons)

            return cell
        case .centralText:
            guard let centralTexts = viewModel.centralTexts[section], let centralText = centralTexts[indexPath.row]?.localized else { return UITableViewCell(frame: .zero) }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: CentralizedTextTableViewCell.className,
                                                           for: indexPath) as? CentralizedTextTableViewCell else {
                return UITableViewCell()
            }

            let shouldChangeSpacing = section != .memory && section != .language

            cell.setup(text: centralText, bottomConstraint: shouldChangeSpacing ? 40 : 20)

            return cell
        case .stepper:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StepperTableViewCell.className,
                                                           for: indexPath) as? StepperTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(title: LocalizedTable.mocaFifthSectionSecondInstruction.localized, value: Int(viewModel.countedWords), delegate: interactor, leadingConstraint: 35)

            return cell
        case .question:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableTableViewCell.className,
                                                           for: indexPath) as? SelectableTableViewCell else {
                return UITableViewCell()
            }

            cell.setup(viewModel: .init(title: viewModel.question.question, options: viewModel.question.options, delegate: interactor, selectedQuestion: viewModel.selectedOption, leadingConstraint: 35))

            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentSection = Section(rawValue: section) else { return nil }

        if currentSection != .done {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView
                                                                            .className) as? TitleHeaderView else {
                return nil
            }

            let headerTitle: LocalizedTable = switch currentSection {
            case .visuospatial:
                .visuospatial
            case .naming:
                .naming
            case .memory:
                .memory
            case .attention:
                .attention
            case .language:
                .language
            case .abstraction:
                .abstraction
            case .delayedRecall:
                .delayedRecall
            case .orientation:
                .orientation
            case .education:
                .education
            default:
                .none
            }

            header.setup(title: headerTitle.localized, backgroundColor: .primary, leadingConstraint: 25)

            return header
        }

        return nil
    }
}

extension MoCAViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        router?.dismissPresentingController()

        interactor?.didCaptureImage(image: info[.editedImage] as? UIImage)
    }
}
