//
//  FilterTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didSelect(filterOption: CGAModels.FilterOptions)
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

    func setup(filterOptions: [CGAModels.FilterOptions], selectedOption: CGAModels.FilterOptions, delegate: FilterDelegate?) {
        self.delegate = delegate

        let menus: [UIAction] = filterOptions.map { filterOption in
            UIAction(title: filterOption.title ?? "",
                     state: filterOption == selectedOption ? .on : .off) { [weak self] _ in
                guard let self else { return }
                self.delegate?.didSelect(filterOption: filterOption)
            }
        }

        filterButton?.menu = UIMenu(children: menus)
        filterButton?.setAttributedTitle(getAttributedText(filterName: selectedOption.title ?? ""), for: .normal)
    }

    // MARK: - Private Methods

    private func setupViews() {
        filterButton?.showsMenuAsPrimaryAction = true
    }

    private func getAttributedText(filterName: String) -> NSAttributedString {
        let filterNameFont: UIFont = .compactDisplay(withStyle: .semibold, size: 17)
        let titleFont: UIFont = .compactDisplay(withStyle: .medium, size: 17)
        let textColor: UIColor = .label1 ?? .clear

        let titleString = NSAttributedString(string: "\(LocalizedTable.filteredBy.localized) ",
                                             attributes: [.font: titleFont, .foregroundColor: textColor])
        let filterNameString = NSAttributedString(string: filterName,
                                                  attributes: [.font: filterNameFont, .foregroundColor: textColor])

        return titleString + filterNameString
    }
}
