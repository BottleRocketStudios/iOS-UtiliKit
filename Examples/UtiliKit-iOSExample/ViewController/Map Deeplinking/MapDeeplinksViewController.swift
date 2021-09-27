//
//  MapDeeplinksViewController.swift
//  UtiliKit-iOSTests
//
//  Created by Nathan Chiu on 9/26/21.
//  Copyright © 2021 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import UtiliKit

class MapDeeplinksViewController: UIViewController {

    // MARK: Type Alias

    typealias MapApp = ExternalMappingURLBuilder.MapApp

    // MARK: Properties

    let urlBuilder = ExternalMappingURLBuilder(apps: MapApp.allCases)

    // MARK: IBOutlets

    @IBOutlet private var enableMapTypeToggle: UISwitch!
    @IBOutlet private var mapTypePicker: UISegmentedControl!

    @IBOutlet private var locationLatitudeTextField: UITextField!
    @IBOutlet private var locationLatitudeNSButton: UIButton!
    @IBOutlet private var locationLongitudeTextField: UITextField!
    @IBOutlet private var locationLongitudeEWButton: UIButton!
    @IBOutlet private var locationEnableZoomToggle: UISwitch!
    @IBOutlet private var locationZoomSlider: UISlider!
    @IBOutlet private var locationBuildButton: UIButton!

    @IBOutlet private var searchQueryTextField: UITextField!
    @IBOutlet private var searchLatitudeTextField: UITextField!
    @IBOutlet private var searchLatitudeNSButton: UIButton!
    @IBOutlet private var searchLongitudeTextField: UITextField!
    @IBOutlet private var searchLongitudeEWButton: UIButton!
    @IBOutlet private var searchBuildButton: UIButton!

    @IBOutlet private var navigationToTextField: UITextField!
    @IBOutlet private var navigationFromTextField: UITextField!
    @IBOutlet private var navigationEnableNavTypeToggle: UISwitch!
    @IBOutlet private var navigationTypePicker: UISegmentedControl!
    @IBOutlet private var navigationBuildButton: UIButton!

    @IBOutlet private var appleButton: UIButton!
    @IBOutlet private var googleButton: UIButton!
    @IBOutlet private var wazeButton: UIButton!

    // MARK: UIViewController

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureAppButtons()
    }
}

// MARK: UITextFieldDelegate

extension MapDeeplinksViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.keyboardType == .decimalPad || textField.keyboardType == .numberPad {
            let doneButton = UIButton(type: .system)
            doneButton.translatesAutoresizingMaskIntoConstraints = false
            doneButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
            doneButton.setTitle("Done", for: .normal)
            doneButton.backgroundColor = .lightGray
            textField.inputAccessoryView = doneButton
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBuildButtons()
    }
}

// MARK: - Private

private extension MapDeeplinksViewController {

    var mapStyle: MapStyle? {
        guard enableMapTypeToggle.isOn else { return nil }
        return MapStyle(rawValue: (mapTypePicker.titleOfSelectedSegment ?? "").lowercased())
    }

    var locationCoordinate: MappingCoordinate? {
        guard var latitude = Float(locationLatitudeTextField.text ?? ""),
        var longitude = Float(locationLongitudeTextField.text ?? "")
        else { return nil }
        if locationLatitudeNSButton.title(for: .normal) == "South" { latitude *= -1 }
        if locationLongitudeEWButton.title(for: .normal) == "West" { longitude *= -1 }
        return MappingCoordinate(latitude: latitude, longitude: longitude)
    }
    var locationZoom: Float? {
        guard locationEnableZoomToggle.isOn else { return nil }
        return locationZoomSlider.value
    }

    var searchQueryString: String? { trimInput(text: searchQueryTextField.text) }
    var searchNearCoordinate: MappingCoordinate? {
        guard var latitude = Float(searchLatitudeTextField.text ?? ""),
        var longitude = Float(searchLongitudeTextField.text ?? "")
        else { return nil }
        if searchLatitudeNSButton.title(for: .normal) == "South" { latitude *= -1 }
        if searchLongitudeEWButton.title(for: .normal) == "West" { longitude *= -1 }
        return MappingCoordinate(latitude: latitude, longitude: longitude)
    }

    var navigationToString: String? { trimInput(text: navigationToTextField.text) }
    var navigationFromString: String? { trimInput(text: navigationFromTextField.text) }
    var navigationMode: NavigationMode? {
        guard navigationEnableNavTypeToggle.isOn else { return nil }
        return NavigationMode(rawValue: (navigationTypePicker.titleOfSelectedSegment ?? "").lowercased())
    }

    var allAppButtons: [UIButton] {
        [appleButton, googleButton, wazeButton]
    }
    var allTextFields: [UITextField] {
        [locationLatitudeTextField, locationLongitudeTextField,
         searchQueryTextField, searchLatitudeTextField, searchLongitudeTextField,
         navigationToTextField, navigationFromTextField]
    }

    @objc func dismissKeyboard() {
        allTextFields.forEach { $0.resignFirstResponder() }
    }

    func trimInput(text: String?) -> String? {
        guard let text = text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        return text
    }

    func clampCoordinateTextFields() {
        if let latitude = Float(searchLatitudeTextField.text ?? "") {
            searchLatitudeTextField.text = "\((Float(0)...90).clamp(value: latitude))"
        }
        if let longitude = Float(searchLongitudeTextField.text ?? "") {
            searchLongitudeTextField.text = "\((Float(0)...180).clamp(value: longitude))"
        }
    }

    func configureAppButtons() {
        allAppButtons.forEach { $0.isEnabled = false }
        let mapUrls = urlBuilder.search(for: "", near: nil, style: nil)
        mapUrls.forEach {
            guard UIApplication.shared.canOpenURL($0.value) else { return }
            switch $0.key {
            case .apple:
                appleButton.isEnabled = true
            case .google:
                googleButton.isEnabled = true
            case .waze:
                wazeButton.isEnabled = true
            }
        }
    }

    func updateBuildButtons() {
        locationBuildButton.isEnabled = locationCoordinate != nil
        searchBuildButton.isEnabled = searchQueryString != nil
        navigationBuildButton.isEnabled = navigationToString != nil
    }

    func buildLocationURL() {
        guard let locationCoordinate = locationCoordinate else { return }
        buildAlert(from: urlBuilder.displayLocation(at: locationCoordinate, zoomPercent: locationZoom, style: mapStyle))
    }

    func buildSearchURL() {
        guard let searchQueryString = searchQueryString else { return }
        buildAlert(from: urlBuilder.search(for: searchQueryString, near: searchNearCoordinate, style: mapStyle))
    }

    func buildNavigationURL() {
        guard let navigationToString = navigationToString else { return }
        buildAlert(from: urlBuilder.navigate(to: navigationToString, from: navigationFromString, via: navigationMode, style: mapStyle))
    }

    func buildAlert(from mapUrls: [MapApp: URL]) {
        let actionSheet = UIAlertController(title: "Open in...", message: "Choose the map app to use", preferredStyle: .actionSheet)
        mapUrls.forEach {
            let url = $0.value
            let title = $0.key.title
            guard UIApplication.shared.canOpenURL(url) else { return }
            actionSheet.addAction(.init(title: title, style: .default) { _ in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
        }
        actionSheet.addAction(.init(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true, completion: nil)
    }

    // MARK: IBActions

    @IBAction func toggleEnableMapType(_ sender: UISwitch) {
        mapTypePicker.isEnabled = sender.isOn
    }

    @IBAction func toggleNorthSouth(_ sender: UIButton) {
        sender.setTitle(sender.currentTitle == "North" ? "South" : "North", for: .normal)
    }

    @IBAction func toggleEastWest(_ sender: UIButton) {
        sender.setTitle(sender.currentTitle == "East" ? "West" : "East", for: .normal)
    }

    @IBAction func toggleEnableLocationZoom(_ sender: UISwitch) {
        locationZoomSlider.isEnabled = sender.isOn
    }

    @IBAction func toggleEnableNavigationType(_ sender: UISwitch) {
        navigationTypePicker.isEnabled = sender.isOn
    }

    @IBAction func pressedBuildURLButton(_ sender: UIButton) {
        resignFirstResponder()
        switch sender {
        case locationBuildButton:
            buildLocationURL()
        case searchBuildButton:
            buildSearchURL()
        case navigationBuildButton:
            buildNavigationURL()
        default:
            break
        }
    }
}
