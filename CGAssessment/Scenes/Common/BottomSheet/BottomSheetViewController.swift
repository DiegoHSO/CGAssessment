//
//  BottomSheetViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import UIKit

protocol PickerViewDelegate: AnyObject {
    func didSelectPickerRow(identifier: LocalizedTable?, row: Int)
}

protocol BottomSheetPresentationLogic: UIPickerViewDelegate, UIPickerViewDataSource {}

class BottomSheetViewController: UIViewController, BottomSheetPresentationLogic {

    // MARK: - Private Properties

    @IBOutlet private weak var pickerView: UIPickerView?
    private var pickerContent: [String] = []
    private var identifier: LocalizedTable?
    private var selectedRow: Int = 0
    private weak var delegate: PickerViewDelegate?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
    }

    // MARK: - Public Methods

    func setupArchitecture(viewModel: CGAModels.BottomSheetViewModel) {
        title = viewModel.identifier?.localized
        delegate = viewModel.delegate
        identifier = viewModel.identifier
        pickerContent = viewModel.pickerContent
        selectedRow = viewModel.selectedRow
    }

    // MARK: - Public Methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerContent.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectPickerRow(identifier: identifier, row: row)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerContent[safe: row] ?? nil
    }

    // MARK: - Private Methods

    private func setupPicker() {
        pickerView?.delegate = self
        pickerView?.dataSource = self
        pickerView?.selectRow(selectedRow, inComponent: 0, animated: true)
    }
}
