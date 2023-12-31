//
//  StopwatchTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import UIKit

protocol StopwatchDelegate: AnyObject {
    func didStopCounting(elapsedTime: TimeInterval, identifier: String?)
}

class StopwatchTableViewCell: UITableViewCell {

    @IBOutlet private weak var leftButtonView: UIView?
    @IBOutlet private weak var leftButtonLabel: UILabel?
    @IBOutlet private weak var rightButtonView: UIView?
    @IBOutlet private weak var rightButtonLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?

    // Label to display the stopwatch time
    @IBOutlet private weak var stopwatchLabel: UILabel?

    // Timer object to track elapsed time
    private var stopwatchTimer: Timer?

    // Variable to keep track of elapsed time
    private var elapsedTime: TimeInterval = 0

    // Variable to keep track if stopwatch is ascending or descending
    private var isAscending: Bool = true

    // Delegate to send elapsed time frontwards
    private weak var delegate: StopwatchDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setupViews()
        setupGestures()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        elapsedTime = 0
        stopwatchLabel?.text = "00:00,00"
    }

    // MARK: - Public Methods

    func setup(delegate: StopwatchDelegate?, description: String? = nil, elapsedTime: TimeInterval? = nil, isAscending: Bool = true) {
        descriptionLabel?.text = description
        descriptionLabel?.isHidden = description == nil
        leftButtonLabel?.text = isAscending ? LocalizedTable.reset.localized : LocalizedTable.clear.localized

        self.delegate = delegate
        self.isAscending = isAscending

        if let elapsedTime {
            self.elapsedTime = elapsedTime
            setupElapsedTimeFormatting()
        }
    }

    // MARK: - Private Methods

    private func setupViews() {
        stopwatchLabel?.text = "00:00,00"

        leftButtonView?.layer.borderWidth = 1
        leftButtonView?.layer.borderColor = UIColor.label1?.cgColor
        leftButtonView?.layer.cornerRadius = (leftButtonView?.frame.size.width ?? 0) / 2

        rightButtonLabel?.text = LocalizedTable.start.localized
        rightButtonView?.layer.borderWidth = 1
        rightButtonView?.layer.borderColor = UIColor.label1?.cgColor
        rightButtonView?.layer.cornerRadius = (rightButtonView?.frame.size.width ?? 0) / 2
    }

    private func setupGestures() {
        let leftButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLeftButton))
        let rightButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRightButton))

        leftButtonView?.addGestureRecognizer(leftButtonTapGesture)
        rightButtonView?.addGestureRecognizer(rightButtonTapGesture)
    }

    @objc private func didTapLeftButton() {
        // If the timer is running
        guard stopwatchTimer == nil else { return }

        elapsedTime = isAscending ? 0 : 60
        stopwatchLabel?.text = isAscending ? "00:00,00" : "01:00,00"

        delegate?.didStopCounting(elapsedTime: elapsedTime, identifier: descriptionLabel?.text)
    }

    @objc private func didTapRightButton() {
        // If the timer is running, stop it
        if let timer = stopwatchTimer {
            timer.invalidate()
            stopwatchTimer = nil

            // Update the button text
            rightButtonLabel?.text = LocalizedTable.start.localized
            rightButtonView?.backgroundColor = .background7
            leftButtonView?.alpha = 1

            // Send to delegate
            delegate?.didStopCounting(elapsedTime: elapsedTime, identifier: descriptionLabel?.text)
        } else {
            // Start the timer
            elapsedTime = !isAscending && elapsedTime <= 0 ? 60 : elapsedTime

            stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
                guard let self else { return }

                // Update the elapsed time
                self.elapsedTime = isAscending ? self.elapsedTime + timer.timeInterval : self.elapsedTime - timer.timeInterval

                self.setupElapsedTimeFormatting()
                self.leftButtonView?.alpha = 0.4

                if elapsedTime <= 0, !isAscending {
                    didTapRightButton()
                }
            }

            // Update the button text
            rightButtonLabel?.text = LocalizedTable.stop.localized
            rightButtonView?.backgroundColor = .background14
        }
    }

    private func setupElapsedTimeFormatting() {
        // Format the elapsed time as a stopwatch time
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        let milliseconds = Int(elapsedTime * 100) % 100

        // Update the label with the formatted time
        stopwatchLabel?.text = String(format: "%02d:%02d,%02d", minutes, seconds, milliseconds)
    }
}
