//
//  LogInViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - Elements of interface
    private let activiteIndecator = UIActivityIndicatorView(hidenWhenStoped: true)
    
    private let mainLabel = UILabel(text: "Welcome back!", font: .avenir26())
    private let loginLabel = UILabel(text: "Login with")
    private let orLabel = UILabel(text: "or")
    private let emailLabel = UILabel(text: "Email")
    private let passwordLabel = UILabel(text: "Password")
    private let needAnAccountLabel = UILabel(text: "Need an account?")
    
    private let googleButtom = UIButton(titel: "Google", backgroundColor: .white, titleColor: .buttonDark(), isShadow: true)
    private let logInButtom = UIButton(titel: "Login", backgroundColor: .buttonDark(), titleColor: .mainWhite())
    private let signUpButtom = UIButton(titel: "Sign Up", backgroundColor: .clear, titleColor: .buttonRed(), cornerRadius: 0)
    private let backButton = UIButton(titel: "Go to back", backgroundColor: .clear, titleColor: .buttonDark(), cornerRadius: 0)
    
    private let emailTextField = OneLineTextField()
    private let passwordTextField = OneLineTextField()
    
    private var keyboardObserver: KeyboardObserver?
    
    // MARK: - viewDidLaod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        googleButtom.customGoogleButton()
        
        settingDelegateAndObserver()
        setupConstraints()
        addTargetButtons()
    }
    
    deinit {
        keyboardObserver?.cancelForKeybourdNotification()
    }
}

// MARK: - Private method
extension LogInViewController {
    
    private func settingDelegateAndObserver() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        
        keyboardObserver = KeyboardObserver(viewController: self, lastViewInViewController: backButton)
        keyboardObserver?.registerForKeybourdNotification()
    }
    
    private func setupConstraints() {
        
        view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
        
        let googleStackView = UIStackView(arrangedSubviews: [loginLabel, googleButtom], axis: .vertical, spacing: 15)
        googleButtom.translatesAutoresizingMaskIntoConstraints = false
        googleButtom.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.addSubview(googleStackView)
        googleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleStackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 100),
            googleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        
        let stackView = UIStackView(arrangedSubviews: [orLabel, emailStackView, passwordStackView, logInButtom], axis: .vertical, spacing: 40)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        logInButtom.translatesAutoresizingMaskIntoConstraints = false
        logInButtom.heightAnchor.constraint(equalToConstant: 60).isActive = true
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: googleStackView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        let footerStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButtom], axis: .horizontal, spacing: 10)
        view.addSubview(footerStackView)
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpButtom.contentHorizontalAlignment = .leading
        footerStackView.alignment = .firstBaseline
        NSLayoutConstraint.activate([
            footerStackView.topAnchor.constraint(equalTo: logInButtom.bottomAnchor, constant: 5),
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backButton.topAnchor.constraint(equalTo: footerStackView.bottomAnchor)
        ])
        
        view.addSubview(activiteIndecator)
        activiteIndecator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activiteIndecator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activiteIndecator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activiteIndecator.heightAnchor.constraint(equalToConstant: 90),
            activiteIndecator.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func addTargetButtons() {
        logInButtom.addTarget(self, action: #selector(logInButtonPress), for: .touchUpInside)
        signUpButtom.addTarget(self, action: #selector(signUpButtonPress), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        googleButtom.addTarget(self, action: #selector(googleButtonPress), for: .touchUpInside)
    }
}


// MARK: - @objc method
extension LogInViewController {
    
    @objc private func logInButtonPress() {
        activiteIndecator.startAnimating()
        AuthService.shered.signIn(email: emailTextField.text, password: passwordTextField.text) { result in
            switch result {
            case .success(let user):
                FirebaseService.shered.getUserData(with: user.uid) { [unowned self] result in
                    self.showAlert(title: "Completion", message: "Email: \(user.email ?? "none")")
                    switch result {
                    case .success(let user):
                        self.activiteIndecator.stopAnimating()
                        SceneDelegate.shared.rootViewController.goToMainTabBarController(user: user)
                    case .failure:
                        self.activiteIndecator.stopAnimating()
                        SceneDelegate.shared.rootViewController.goToSetupProfileViewController()
                    }
                }
            case .failure(let error):
                self.activiteIndecator.stopAnimating()
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
    }
    
    @objc private func signUpButtonPress() {
        SceneDelegate.shared.rootViewController.goToSignUpViewController()
    }
    
    @objc private func backButtonPress() {
        SceneDelegate.shared.rootViewController.goToAuthViewController()
    }
    
    @objc private func googleButtonPress() {
        activiteIndecator.startAnimating()
        AuthService.shered.signInWithGoogle(viewController: self) { [unowned self] result in
            switch result {
            case .success(let user):
                FirebaseService.shered.getUserData(with: user.uid) { result in
                    switch result {
                    case .success(let user):
                        activiteIndecator.stopAnimating()
                        SceneDelegate.shared.rootViewController.goToMainTabBarController(user: user)
                    case .failure:
                        activiteIndecator.stopAnimating()
                        SceneDelegate.shared.rootViewController.goToSetupProfileViewController()
                    }
                }
            case .failure:
                activiteIndecator.stopAnimating()
            }
        }
    }
}


// MARK: - UITextFieldDelegate
extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK: - Override function
extension LogInViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}
