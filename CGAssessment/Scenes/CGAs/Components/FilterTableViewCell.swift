//
//  FilterTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didSelect(filterOption: CGAsModels.FilterOptions)
}

class FilterTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var filterButton: UIButton?
    private weak var delegate: FilterDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(filterOptions: [CGAsModels.FilterOptions], selectedOption: CGAsModels.FilterOptions, delegate: FilterDelegate?) {
        self.delegate = delegate

        let menus: [UIAction] = filterOptions.map { filterOption in
            UIAction(title: filterOption.title ?? "",
                     state: filterOption == selectedOption ? .on : .off) { [weak self] _ in
                guard let self else { return }
                self.delegate?.didSelect(filterOption: filterOption)
            }
        }

        filterButton?.menu = UIMenu(children: menus)
        filterButton?.setTitle("\(LocalizedTable.filteredBy.localized) \(selectedOption.title ?? "")", for: .normal)
    }

    // MARK: - Private Methods

    private func setupViews() {
        filterButton?.titleLabel?.font = .compactDisplay(withStyle: .medium, size: 15)
    }
}
