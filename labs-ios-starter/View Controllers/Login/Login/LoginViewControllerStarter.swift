//
//  LoginViewController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth

class LoginViewControllerStarter: UIViewController {
    
    // MARK: - Properties
    let userController = UserController.shared
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationSuccessful,
                                               object: nil,
                                               queue: .main,
                                               using: checkForExistingUser)
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationExpired,
                                               object: nil,
                                               queue: .main,
                                               using: alertUserOfExpiredCredentials)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.numberOfLines = 0
        label.text = "EcoSoap-Bank"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "System", size: 17.0)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Saving, sanitizing, and supplying RECYCLED SOAP for the developing world"
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "ESB Blue")
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action:#selector(self.login), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var textfieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()

    private lazy var panelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(named: "Panel System Background")
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ESB Logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Actions
    @objc func login() {
        UIApplication.shared.open(UserController.shared.oktaAuth.identityAuthURL()!)
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        view.backgroundColor = UIColor(named: "ESB System Background")
        
        // ESB Logo
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.20).isActive = true
        
        // Labels
        infoLabelStackView.addArrangedSubview(titleLabel)
        infoLabelStackView.addArrangedSubview(descriptionLabel)
        view.addSubview(infoLabelStackView)
        infoLabelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        infoLabelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        infoLabelStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        // Panel View
        view.addSubview(panelView)
        panelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        panelView.topAnchor.constraint(equalTo: infoLabelStackView.bottomAnchor, constant: 20).isActive = true

        // Textfields
        panelView.addSubview(textfieldStackView)
        textfieldStackView.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
        textfieldStackView.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -20).isActive = true
        textfieldStackView.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 20).isActive = true
        
        // Login Button
        panelView.addSubview(loginButton)
        loginButton.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -20).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: panelView.bottomAnchor, constant: -20).isActive = true
        loginButton.topAnchor.constraint(equalTo: textfieldStackView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func alertUserOfExpiredCredentials(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presentSimpleAlert(with: "Your Okta credentials have expired",
                           message: "Please sign in again",
                           preferredStyle: .alert,
                           dismissText: "Dimiss")
        }
    }
    
    // MARK: Notification Handling
    private func checkForExistingUser(with notification: Notification) {
        checkForExistingUser()
    }
    
    // TODO: Modify
    private func checkForExistingUser() {
        userController.checkForExistingAuthenticatedUser { [weak self] (exists) in
            
            guard let self = self,
                self.presentedViewController == nil else { return }
            
            if exists {
                // TODO: Uncomment if-else statement after Production Reports Feature is merged with main.
                if BackendController.shared.loggedInUser.role == .HOTEL {
                    self.performSegue(withIdentifier: "ShowDetailProfileList", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "ShowHubDashboardSegue", sender: nil)
                }
            } else {
                NSLog("Invalid Login.")
            }
        }
    }
}
