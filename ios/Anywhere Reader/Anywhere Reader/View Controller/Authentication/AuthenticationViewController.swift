//
//  AuthenticationViewController.swift
//  Anywhere Reader
//
//  Created by Conner on 11/6/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import GoogleSignIn

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        googleSignInButton.style = .wide

        updateViews()
    }


    // MARK: - Private properties

    private var isSignUp = true {
        didSet {
            updateCredentialsViewContents()
        }
    }

    private var selectedSegmentBarLeftAnchor: NSLayoutConstraint!


    // MARK: - IBOutlets

    @IBOutlet weak var credentialsView: UIView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var selectedSegmentBar: UIView!

    @IBOutlet weak var usernameStackView: UIStackView!
    @IBOutlet weak var emailStackView: UIStackView!

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBOutlet weak var usernameView: GradientMaskView!
    @IBOutlet weak var emailView: GradientMaskView!
    @IBOutlet weak var passwordView: GradientMaskView!

    @IBOutlet weak var authenticateButton: UIButton!
    @IBOutlet var googleSignInButton: GIDSignInButton!

    // MARK: - IBActions

    @IBAction private func toggleSignUp(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            isSignUp = true
        case 1:
            isSignUp = false
        default:
            fatalError("Segmented Control only has 2 segments")
        }
    }

    // Sign Up or Sign In tapped
    @IBAction func authenticateTapped(_ sender: Any) {
        switch isSignUp {
        case true:
            signUpUser()
        case false:
            loginUser()
        }
    }

    // MARK: - Private functions

    private func updateViews() {
        setUpCredentialsView()
        setUpAuthenticateButton()
        setUpSegmentedControl()
        setUpSelectedSegmentBar()
        setUpTextFields()
    }

    /// Makes sure the background is a solid color even if it happens to get layed out on top of the trapezoid gradient
    private func setUpCredentialsView() {
        credentialsView.layer.cornerRadius = 5.0
        credentialsView.layer.shadowColor = UIColor.white.cgColor
        credentialsView.layer.shadowRadius = 10.0
        credentialsView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        credentialsView.layer.shadowOpacity = 1.0
        credentialsView.layer.opacity = 0.75
    }

    /// Adds gradient to authenticateButton
    private func setUpAuthenticateButton() {
        authenticateButton.addGradient(primaryColor: .red, secondaryColor: .orange, startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 0.0))
        authenticateButton.layer.cornerRadius = authenticateButton.frame.height / 2
        authenticateButton.setTitleColor(.white, for: .normal)
        authenticateButton.clipsToBounds = true
        authenticateButton.contentMode = .redraw
    }

    /// Sets up segmented control
    private func setUpSegmentedControl() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 15.0)!], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20.0)!], for: .selected)
    }

    /// Sets up bar under selected segment
    private func setUpSelectedSegmentBar() {
        selectedSegmentBar = UIView()
        selectedSegmentBar.translatesAutoresizingMaskIntoConstraints = false
        selectedSegmentBar.backgroundColor = UIColor.orange
        view.addSubview(selectedSegmentBar)
        selectedSegmentBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 6.0).isActive = true
        selectedSegmentBar.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        // Constrain the button bar to the left side of the segmented control
        selectedSegmentBarLeftAnchor = selectedSegmentBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
        selectedSegmentBarLeftAnchor.isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        selectedSegmentBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
    }

    /// Sets up text fields
    private func setUpTextFields() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

        // Creates toolBar for done button above keyboards for text fields
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.autoresizingMask = .flexibleHeight
        toolBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)

        // Adds done button to right side of toolBar
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(dismissKeyboardForAllTextFields))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)

        // Sets the accessory views of the text fields to the toolBar
        usernameTextField.inputAccessoryView = toolBar
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
    }

    /// Dismisses all three textFields
    @objc private func dismissKeyboardForAllTextFields() {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    private func updateCredentialsViewContents() {
        switch isSignUp {
        case true:
            // Sets the left anchor of the selectedSegmentBar
            selectedSegmentBarLeftAnchor.isActive = false
            let anchorConstant: CGFloat = 0.0
            selectedSegmentBarLeftAnchor = selectedSegmentBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor, constant: anchorConstant)
            selectedSegmentBarLeftAnchor.isActive = true

            // Unhides emailStackView
            emailStackView.isHidden = false

            // Animates above changes
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.emailStackView.alpha = 1.0
            })

            // Changes authenticateButton title
            authenticateButton.setTitle("Sign Up", for: .normal)
            // Changes passwordTextField content type and keyboard return key
            passwordTextField.textContentType = .newPassword
            passwordTextField.returnKeyType = .join
        case false:
            // Sets the left anchor of the selectedSegmentBar
            selectedSegmentBarLeftAnchor.isActive = false
            let anchorConstant: CGFloat = segmentedControl.frame.width / 2.0
            selectedSegmentBarLeftAnchor = selectedSegmentBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor, constant: anchorConstant)
            selectedSegmentBarLeftAnchor.isActive = true
            emailStackView.alpha = 1.0

            // Hides emailStackView
            emailStackView.isHidden = true

            // Animates above changes
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.emailStackView.alpha = 0.0
            })

            // Changes authenticateButton title
            authenticateButton.setTitle("Log In", for: .normal)
            // Changes passwordTextField content type and keyboard return key
            passwordTextField.textContentType = .password
            passwordTextField.returnKeyType = .go
        }

        // Reloads keyboard return key
        passwordTextField.reloadInputViews()
    }
    
    private func showMainCollectionView() {
        let contentSb = UIStoryboard(name: "Main", bundle: nil)
        let contentCollectionView = contentSb.instantiateInitialViewController() as! UINavigationController
        
        self.present(contentCollectionView, animated: true, completion: nil)
    }

    private func signUpUser() {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            let email = emailTextField.text else { return }
        
        AuthService.shared.registerUser(withEmail: email, andPassword: password, andUsername: username) { (success, error, user) in
            if let error = error {
                NSLog("Error with registering user: \(error)")
                return
            }
            
            guard let user = user else { return }
            
            AuthService.shared.loginUser(withUsername: user.username, andPassword: password) { (success, error, user) in
                if let error = error {
                    NSLog("Error with logging in user: \(error)")
                    return
                }
                
                guard let user = user else { return }
                
                DispatchQueue.main.async {
                    self.didAuthenticate(user)
                }
            }
        }
    }

    private func loginUser() {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else { return }
        
        AuthService.shared.loginUser(withUsername: username, andPassword: password) { (success, error, user) in
            if let error = error {
                NSLog("Error with logging in user: \(error)")
                return
            }
            
            guard let user = user else { return }
            
            DispatchQueue.main.async {
                self.didAuthenticate(user)
            }
        }
    }

    private func didAuthenticate(_ user: User) {
        // Set current user
        User.current = user
        // Reset text fields to be empty
        usernameTextField.text = ""
        passwordTextField.text = ""
        // Show main collection view
        showMainCollectionView()
    }
}


// MARK: - UITextFieldDelegate

extension AuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            fatalError("No other textFields implemented")
        }
        return true
    }
}


// MARK: - GIDSignInDelegate

extension AuthenticationViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            NSLog("\(error.localizedDescription)")
        } else {
            // Operations for signed in user
            guard let username = user.profile.givenName,
                let token = user.authentication.accessToken else { return }
            let user = User(username: username, email: nil, password1: nil, password2: nil, key: Key(key: token))
            User.current = user
            // Present controller
            showMainCollectionView()
        }
    }
}
