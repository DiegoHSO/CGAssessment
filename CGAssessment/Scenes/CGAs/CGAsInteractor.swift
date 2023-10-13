//
//  CGAsInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

protocol CGAsLogic: FilterDelegate {
    func controllerDidLoad()
    func controllerWillDisappear()
    func didSelect(cgaId: UUID?)
    func didTapToStartNewCGA()
}

class CGAsInteractor: CGAsLogic {

    // MARK: - Private Properties

    private var presenter: CGAsPresentationLogic?
    private var worker: CGAsWorker?
    private var patientId: UUID?
    private var patientName: String?
    private var selectedFilter: CGAModels.FilterOptions = .recent
    private var viewModelsByPatient: CGAsModels.CGAsByPatient?
    private var viewModelsByDate: CGAsModels.CGAsByDate?

    // MARK: - Init

    init(presenter: CGAsPresentationLogic, worker: CGAsWorker, patientId: UUID?, cgaId: UUID? = nil) {
        self.presenter = presenter
        self.worker = worker
        self.patientId = patientId
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        setupNotification()
        computeViewModelData()
        sendDataToPresenter()
    }

    func controllerWillDisappear() {
        // swiftlint:disable:next notification_center_detachment
        NotificationCenter.default.removeObserver(self)
    }

    func didSelect(cgaId: UUID?) {
        presenter?.route(toRoute: .cgaDomains(cgaId: cgaId))
    }

    func didSelect(filterOption: CGAModels.FilterOptions) {
        selectedFilter = filterOption
        computeViewModelData()
        sendDataToPresenter()
    }

    func didTapToStartNewCGA() {
        presenter?.route(toRoute: .newCGA)
    }

    // MARK: - Private Methods

    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: nil)
    }

    @objc
    private func updateData() {
        DispatchQueue.main.async {
            self.computeViewModelData()
            self.sendDataToPresenter()
        }
    }

    private func computeViewModelData() {
        switch selectedFilter {
        case .recent, .older:
            guard var cgas = try? worker?.getCGAs(for: patientId) else { return }
            cgas = cgas.filter { $0.cgaId != nil }
            cgas.sort(by: { selectedFilter == .older ? ($0.lastModification ?? Date()) < ($1.lastModification ?? Date())
                        : ($0.lastModification ?? Date()) > ($1.lastModification ?? Date())})

            patientName = patientId == nil ? nil : cgas.first?.patient?.name

            let viewModels: [CGAsModels.CGAViewModel] = cgas.compactMap { cga in
                var domainsStatus: CGAsModels.DomainsStatus = [:]

                // MARK: - Mobility domain done check

                if let timedUpAndGo = cga.timedUpAndGo, let walkingSpeed = cga.walkingSpeed,
                   let calfCircumference = cga.calfCircumference, let gripStrength = cga.gripStrength,
                   let sarcopeniaAssessment = cga.sarcopeniaAssessment {
                    if timedUpAndGo.isDone, walkingSpeed.isDone, calfCircumference.isDone,
                       gripStrength.isDone, sarcopeniaAssessment.isDone {
                        domainsStatus.updateValue(.done, forKey: .mobility)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .mobility)
                    }
                } else if cga.timedUpAndGo == nil, cga.walkingSpeed == nil, cga.calfCircumference == nil,
                          cga.gripStrength == nil, cga.sarcopeniaAssessment == nil {
                    domainsStatus.updateValue(.notStarted, forKey: .mobility)
                } else {
                    domainsStatus.updateValue(.incomplete, forKey: .mobility)
                }

                // MARK: - Cognitive domain done check

                if let miniMentalStateExam = cga.miniMentalStateExam, let verbalFluency = cga.verbalFluency,
                   let clockDrawing = cga.clockDrawing, let moCA = cga.moCA,
                   let geriatricDepressionScale = cga.geriatricDepressionScale {
                    if miniMentalStateExam.isDone, verbalFluency.isDone, clockDrawing.isDone,
                       moCA.isDone, geriatricDepressionScale.isDone {
                        domainsStatus.updateValue(.done, forKey: .cognitive)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .cognitive)
                    }
                } else if cga.miniMentalStateExam == nil, cga.verbalFluency == nil, cga.clockDrawing == nil,
                          cga.moCA == nil, cga.geriatricDepressionScale == nil {
                    domainsStatus.updateValue(.notStarted, forKey: .cognitive)
                } else {
                    domainsStatus.updateValue(.incomplete, forKey: .cognitive)
                }

                // MARK: - Sensory domain done check

                if let visualAcuityAssessment = cga.visualAcuityAssessment,
                   let hearingLossAssessment = cga.hearingLossAssessment {
                    if visualAcuityAssessment.isDone, hearingLossAssessment.isDone {
                        domainsStatus.updateValue(.done, forKey: .sensory)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .sensory)
                    }
                } else if cga.visualAcuityAssessment == nil, cga.hearingLossAssessment == nil {
                    domainsStatus.updateValue(.notStarted, forKey: .sensory)
                } else {
                    domainsStatus.updateValue(.incomplete, forKey: .sensory)
                }

                // MARK: - Functional domain done check

                if let katzScale = cga.katzScale, let lawtonScale = cga.lawtonScale {
                    if katzScale.isDone, lawtonScale.isDone {
                        domainsStatus.updateValue(.done, forKey: .functional)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .functional)
                    }
                } else if cga.katzScale == nil, cga.lawtonScale == nil {
                    domainsStatus.updateValue(.notStarted, forKey: .functional)
                } else {
                    domainsStatus.updateValue(.incomplete, forKey: .functional)
                }

                // MARK: - Nutritional domain done check

                if let miniNutritionalAssessment = cga.miniNutritionalAssessment {
                    if miniNutritionalAssessment.isDone {
                        domainsStatus.updateValue(.done, forKey: .nutritional)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .nutritional)
                    }
                } else if cga.miniNutritionalAssessment == nil {
                    domainsStatus.updateValue(.notStarted, forKey: .nutritional)
                } else {
                    domainsStatus.updateValue(.incomplete, forKey: .nutritional)
                }

                // MARK: - Social domain done check

                if let apgarScale = cga.apgarScale, let zaritScale = cga.zaritScale {
                    if apgarScale.isDone, zaritScale.isDone {
                        domainsStatus.updateValue(.done, forKey: .social)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .social)
                    }
                } else if cga.apgarScale == nil, cga.zaritScale == nil {
                    domainsStatus.updateValue(.notStarted, forKey: .social)
                } else {
                    domainsStatus.updateValue(.incomplete, forKey: .social)
                }

                return .init(patientName: patientId == nil ? cga.patient?.name : nil,
                             lastEditedDate: cga.lastModification ?? Date(),
                             domainsStatus: domainsStatus, cgaId: cga.cgaId)

            }

            let cgasByDate = Dictionary(grouping: viewModels, by: { CGAsModels.DateFilter(month: $0.lastEditedDate.month, year: $0.lastEditedDate.year) })

            self.viewModelsByDate = cgasByDate.isEmpty ? nil : cgasByDate
            self.viewModelsByPatient = nil
        case .byPatient:
            guard let patients = try? worker?.getPatients() else { return }
            var patientCGAs: [String: [CGA]] = [:]
            var patientCGAsViewModel: CGAsModels.CGAsByPatient = [:]

            patients.forEach { patient in
                guard let name = patient.name, let cgas = patient.cgas?.allObjects as? [CGA] else { return }
                patientCGAs.updateValue(cgas, forKey: name)
            }

            patientCGAs.forEach { (patient, cgas) in
                let viewModels: [CGAsModels.CGAViewModel] = cgas.compactMap { cga in
                    var domainsStatus: CGAsModels.DomainsStatus = [:]

                    // MARK: - Mobility domain done check

                    if let timedUpAndGo = cga.timedUpAndGo, let walkingSpeed = cga.walkingSpeed,
                       let calfCircumference = cga.calfCircumference, let gripStrength = cga.gripStrength,
                       let sarcopeniaAssessment = cga.sarcopeniaAssessment {
                        if timedUpAndGo.isDone, walkingSpeed.isDone, calfCircumference.isDone,
                           gripStrength.isDone, sarcopeniaAssessment.isDone {
                            domainsStatus.updateValue(.done, forKey: .mobility)
                        } else {
                            domainsStatus.updateValue(.incomplete, forKey: .mobility)
                        }
                    } else if cga.timedUpAndGo == nil, cga.walkingSpeed == nil, cga.calfCircumference == nil,
                              cga.gripStrength == nil, cga.sarcopeniaAssessment == nil {
                        domainsStatus.updateValue(.notStarted, forKey: .mobility)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .mobility)
                    }

                    // MARK: - Cognitive domain done check

                    if let miniMentalStateExam = cga.miniMentalStateExam, let verbalFluency = cga.verbalFluency,
                       let clockDrawing = cga.clockDrawing, let moCA = cga.moCA,
                       let geriatricDepressionScale = cga.geriatricDepressionScale {
                        if miniMentalStateExam.isDone, verbalFluency.isDone, clockDrawing.isDone,
                           moCA.isDone, geriatricDepressionScale.isDone {
                            domainsStatus.updateValue(.done, forKey: .cognitive)
                        } else {
                            domainsStatus.updateValue(.incomplete, forKey: .cognitive)
                        }
                    } else if cga.miniMentalStateExam == nil, cga.verbalFluency == nil, cga.clockDrawing == nil,
                              cga.moCA == nil, cga.geriatricDepressionScale == nil {
                        domainsStatus.updateValue(.notStarted, forKey: .cognitive)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .cognitive)
                    }

                    // MARK: - Sensory domain done check

                    if let visualAcuityAssessment = cga.visualAcuityAssessment,
                       let hearingLossAssessment = cga.hearingLossAssessment {
                        if visualAcuityAssessment.isDone, hearingLossAssessment.isDone {
                            domainsStatus.updateValue(.done, forKey: .sensory)
                        } else {
                            domainsStatus.updateValue(.incomplete, forKey: .sensory)
                        }
                    } else if cga.visualAcuityAssessment == nil, cga.hearingLossAssessment == nil {
                        domainsStatus.updateValue(.notStarted, forKey: .sensory)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .sensory)
                    }

                    // MARK: - Functional domain done check

                    if let katzScale = cga.katzScale, let lawtonScale = cga.lawtonScale {
                        if katzScale.isDone, lawtonScale.isDone {
                            domainsStatus.updateValue(.done, forKey: .functional)
                        } else {
                            domainsStatus.updateValue(.incomplete, forKey: .functional)
                        }
                    } else if cga.katzScale == nil, cga.lawtonScale == nil {
                        domainsStatus.updateValue(.notStarted, forKey: .functional)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .functional)
                    }

                    // MARK: - Nutritional domain done check

                    if let miniNutritionalAssessment = cga.miniNutritionalAssessment {
                        if miniNutritionalAssessment.isDone {
                            domainsStatus.updateValue(.done, forKey: .nutritional)
                        } else {
                            domainsStatus.updateValue(.incomplete, forKey: .nutritional)
                        }
                    } else if cga.miniNutritionalAssessment == nil {
                        domainsStatus.updateValue(.notStarted, forKey: .nutritional)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .nutritional)
                    }

                    // MARK: - Social domain done check

                    if let apgarScale = cga.apgarScale, let zaritScale = cga.zaritScale {
                        if apgarScale.isDone, zaritScale.isDone {
                            domainsStatus.updateValue(.done, forKey: .social)
                        } else {
                            domainsStatus.updateValue(.incomplete, forKey: .social)
                        }
                    } else if cga.apgarScale == nil, cga.zaritScale == nil {
                        domainsStatus.updateValue(.notStarted, forKey: .social)
                    } else {
                        domainsStatus.updateValue(.incomplete, forKey: .social)
                    }

                    return .init(patientName: nil, lastEditedDate: cga.lastModification ?? Date(),
                                 domainsStatus: domainsStatus, cgaId: cga.cgaId)
                }

                patientCGAsViewModel.updateValue(viewModels, forKey: patient)
            }

            self.viewModelsByPatient = patientCGAsViewModel.isEmpty ? nil : patientCGAsViewModel
            self.viewModelsByDate = nil
        default:
            return
        }
    }

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: .init(viewModelsByPatient: viewModelsByPatient,
                                                viewModelsByDate: viewModelsByDate,
                                                filterOptions: patientId == nil ? [.recent, .older, .byPatient] : [.recent, .older],
                                                selectedFilter: selectedFilter, patientName: patientName))
    }
}
