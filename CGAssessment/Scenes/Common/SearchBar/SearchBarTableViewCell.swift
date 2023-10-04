//
//  SearchBarTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import UIKit

protocol SearchBarDelegate: AnyObject {
    func didChange(searchText: String)
}

class SearchBarTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var searchBar: UISearchBar?
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint?
    private weak var delegate: SearchBarDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(title: String?, placeholder: String?, leadingConstraint: CGFloat = 32, trailingConstraint: CGFloat = 22, delegate: SearchBarDelegate?) {
        titleLabel?.text = title
        titleLabel?.isHidden = title == nil
        searchBar?.placeholder = placeholder

        self.leadingConstraint?.constant = leadingConstraint
        self.trailingConstraint?.constant = trailingConstraint
        self.delegate = delegate
    }

    // MARK: - Private Methods

    private func setupViews() {
        searchBar?.delegate = self
        searchBar?.isTranslucent = true
        searchBar?.searchTextField.backgroundColor = .background7?.withAlphaComponent(0.2)
        searchBar?.searchTextField.font = .compactDisplay(withStyle: .regular, size: 17)
    }
}

// MARK: - UISearchBarDelegate extension

extension SearchBarTableViewCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didChange(searchText: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}
