//
//  FirebaseMethods.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/22/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

struct LoginViewPosition {
    
    static let emailPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.30)
    static let passwordPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.40)
    static let firstnamePosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.40)
    static let lastnamePosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.40)
    
    static let loginPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55)
    static let newuserPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.65)
    static let signupPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.65)
    static let cancelPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.65)
}

struct NewUserViewPosition {
    
    static let emailPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.20)
    static let passwordPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.28)
    static let firstnamePosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.36)
    static let lastnamePosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.44)
    
    static let loginPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55)
    static let newuserPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55)
    static let signupPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55)
    static let cancelPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.65)
}

class LoginViewController: UIViewController {
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var nameTextField: UITextField!
    var usernameTextField: UITextField!
    
    var loginButton: UIButton!
    var newuserButton: UIButton!
    var signupButton: UIButton!
    var cancelButton: UIButton!
    
    var signupButtonState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.themeOrange
        loadViews()
        setPositions()
        emailTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    func animateSignupEntry(view: UIView) {
        
        UIView.animate(withDuration: 0.25, animations: {
            view.center.y = self.view.center.y
        }) { (success) in
            print(success)
        }
    }
    
    func createAlertWith(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
        
        return alert
    }
    
}


extension LoginViewController {
    
    func loginButtonAction() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        if email != "" && password != "" {
            UserFirebaseMethods.signInButton(email: email, password: password) { success in
                if success {
                    self.performSegue(withIdentifier: "landingSegue", sender: self)
                } else {
                    let alert = self.createAlertWith(title: "Couldn't Login", message: "Please Check Your Entries")
                    self.present(alert, animated: true, completion: {
                        
                    })
                }
            }
        } else if email == "" && password != "" {
            let alert = self.createAlertWith(title: "Oops", message: "You need an email.")
            self.present(alert, animated: true, completion: {
                
            })
        } else if password == "" && email != "" {
            let alert = self.createAlertWith(title: "Oops", message: "You need a password.")
            self.present(alert, animated: true, completion: {
                
            })
        } else {
            let alert = self.createAlertWith(title: "Oops", message: "You need to enter some info.")
            self.present(alert, animated: true, completion: {
                
            })
        }
    }
    
    func newuserButtonAction(_ sender: UIButton) {
        animateForSignup()
    }
    
    func signupButtonAction(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let name = nameTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        
        if email != "" && password != "" && name != "" && username != "" {
            
            if password.characters.count < 6 {
                let alert = self.createAlertWith(title: "Couldn't Signup", message: "Email must be at least 6 characters.")
                self.present(alert, animated: true, completion: {
                    
                })
                
            } else {
                
                UserFirebaseMethods.signUpButton(email: email, password: password, name: name, username: username) { success in
                    
                    if success {
                        self.performSegue(withIdentifier: "landingSegue", sender: self)
                    } else {
                        let alert = self.createAlertWith(title: "Couldn't Signup", message: "This email is already being used.")
                        self.present(alert, animated: true, completion: {
                            
                        })
                    }
                }
            }
        } else {
            let alert = self.createAlertWith(title: "Oops", message: "Please fill in all the fields.")
            self.present(alert, animated: true, completion: {
                
            })
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "landingSegue" {
            _ = segue.destination as! UITabBarController
            
        }
    }
    
    
    func cancelButtonAction(_ sender: UIButton) {
        
        animateForLogin()
        
    }
    
    
    
}


//MARK: -Animations
extension LoginViewController {
    
    func animateForSignup() {
        self.nameTextField.isHidden = false
        self.usernameTextField.isHidden = false
        self.signupButton.isHidden = false
        self.cancelButton.isHidden = false
        self.newuserButton.isUserInteractionEnabled = false
        self.cancelButton.isUserInteractionEnabled = false
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                self.emailTextField.center = NewUserViewPosition.emailPosition
                self.passwordTextField.center = NewUserViewPosition.passwordPosition
                self.nameTextField.center = NewUserViewPosition.firstnamePosition
                self.usernameTextField.center = NewUserViewPosition.lastnamePosition
                
                self.loginButton.center = NewUserViewPosition.loginPosition
                self.newuserButton.center = NewUserViewPosition.newuserPosition
                self.signupButton.center = NewUserViewPosition.signupPosition
                self.cancelButton.center = NewUserViewPosition.cancelPosition
                
            })
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.nameTextField.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                self.usernameTextField.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.nameTextField.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                self.usernameTextField.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.nameTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.usernameTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
        }) { (success) in
            self.loginButton.isHidden = true
            self.newuserButton.isHidden = true
            self.newuserButton.isUserInteractionEnabled = true
            self.cancelButton.isUserInteractionEnabled = true
        }
        
    }
    
    func animateForLogin() {
        
        self.loginButton.isHidden = false
        self.newuserButton.isHidden = false
        self.newuserButton.isUserInteractionEnabled = false
        self.cancelButton.isUserInteractionEnabled = false
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                self.emailTextField.center = LoginViewPosition.emailPosition
                self.passwordTextField.center = LoginViewPosition.passwordPosition
                self.nameTextField.center = LoginViewPosition.firstnamePosition
                self.usernameTextField.center = LoginViewPosition.lastnamePosition
                
                self.loginButton.center = LoginViewPosition.loginPosition
                self.newuserButton.center = LoginViewPosition.newuserPosition
                self.signupButton.center = LoginViewPosition.signupPosition
                self.cancelButton.center = LoginViewPosition.cancelPosition
                
            })
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 0.9, y: 1)
                self.nameTextField.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                self.usernameTextField.transform = CGAffineTransform.init(scaleX: 0.8, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 1.1, y: 1)
                self.nameTextField.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                self.usernameTextField.transform = CGAffineTransform.init(scaleX: 1.2, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: {
                self.emailTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.passwordTextField.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.nameTextField.transform = CGAffineTransform.init(scaleX: 0, y: 1)
                self.usernameTextField.transform = CGAffineTransform.init(scaleX: 0, y: 1)
                
                self.loginButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.newuserButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.signupButton.transform = CGAffineTransform.init(scaleX: 0, y: 1)
                self.cancelButton.transform = CGAffineTransform.init(scaleX: 0, y: 1)
            })
        }) { (success) in
            self.nameTextField.isHidden = true
            self.usernameTextField.isHidden = true
            self.signupButton.isHidden = true
            self.cancelButton.isHidden = true
            self.newuserButton.isUserInteractionEnabled = true
            self.cancelButton.isUserInteractionEnabled = true
        }
        
    }
    
    
}




//MARK: -Setup buttons
extension LoginViewController {
    
    func setPositions() {
        emailTextField.center = LoginViewPosition.emailPosition
        passwordTextField.center = LoginViewPosition.passwordPosition
        nameTextField.center = LoginViewPosition.firstnamePosition
        usernameTextField.center = LoginViewPosition.lastnamePosition
        
        nameTextField.transform = CGAffineTransform.init(scaleX: 0.0, y: 1)
        usernameTextField.transform = CGAffineTransform.init(scaleX: 0.0, y: 1)
        nameTextField.isHidden = true
        usernameTextField.isHidden = true
        
        loginButton.center = LoginViewPosition.loginPosition
        newuserButton.center = LoginViewPosition.newuserPosition
        signupButton.center = LoginViewPosition.signupPosition
        cancelButton.center = LoginViewPosition.cancelPosition
        
        signupButton.transform = CGAffineTransform.init(scaleX: 0.0, y: 1)
        cancelButton.transform = CGAffineTransform.init(scaleX: 0.0, y: 1)
        signupButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    func loadViews() {
        
        let borderWidth: CGFloat = 2
        let borderColor = UIColor.themeOrange.cgColor
        
        nameTextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.6, height: self.view.frame.size.height * 0.06))
        nameTextField.layer.cornerRadius = 7
        nameTextField.layer.borderWidth = borderWidth
        nameTextField.layer.borderColor = borderColor
        nameTextField.autocorrectionType = .no
        nameTextField.backgroundColor = UIColor.themeWhite
        nameTextField.font = UIFont.themeSmallBold
        nameTextField.attributedPlaceholder = NSAttributedString(string: " Enter name")
        self.view.addSubview(nameTextField)
        
        usernameTextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.6, height: self.view.frame.size.height * 0.06))
        usernameTextField.layer.cornerRadius = 7
        usernameTextField.layer.borderWidth = borderWidth
        usernameTextField.layer.borderColor = borderColor
        usernameTextField.autocorrectionType = .no
        usernameTextField.backgroundColor = UIColor.themeWhite
        usernameTextField.font = UIFont.themeSmallBold
        usernameTextField.attributedPlaceholder = NSAttributedString(string: " Enter desired username")
        self.view.addSubview(usernameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.6, height: self.view.frame.size.height * 0.06))
        emailTextField.backgroundColor = UIColor.themeWhite
        emailTextField.font = UIFont.themeSmallBold
        emailTextField.layer.cornerRadius = 7
        emailTextField.layer.borderWidth = borderWidth
        emailTextField.layer.borderColor = borderColor
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.attributedPlaceholder = NSAttributedString(string: " Enter email")
        self.view.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.6, height: self.view.frame.size.height * 0.06))
        passwordTextField.layer.cornerRadius = 7
        passwordTextField.font = UIFont.themeSmallBold
        passwordTextField.layer.borderWidth = borderWidth
        passwordTextField.layer.borderColor = borderColor
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = UIColor.themeWhite
        passwordTextField.attributedPlaceholder = NSAttributedString(string: " Enter password")
        self.view.addSubview(passwordTextField)
        
        
        loginButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.4, height: self.view.frame.size.height * 0.06))
        self.view.addSubview(loginButton)
        loginButton.layer.cornerRadius = 7
        loginButton.layer.borderWidth = borderWidth
        loginButton.layer.borderColor = borderColor
        loginButton.backgroundColor = UIColor.themeWhite
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.themeSmallBold
        loginButton.setTitleColor(UIColor.themeDarkBlue, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        
        newuserButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.4, height: self.view.frame.size.height * 0.06))
        self.view.addSubview(newuserButton)
        newuserButton.layer.cornerRadius = 7
        newuserButton.layer.borderWidth = borderWidth
        newuserButton.layer.borderColor = borderColor
        newuserButton.backgroundColor = UIColor.themeLightBlue
        newuserButton.setTitle("New User", for: .normal)
        newuserButton.titleLabel?.font = UIFont.themeSmallBold
        newuserButton.setTitleColor(UIColor.themeDarkBlue, for: .normal)
        newuserButton.addTarget(self, action: #selector(newuserButtonAction), for: .touchUpInside)
        
        signupButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.4, height: self.view.frame.size.height * 0.06))
        self.view.addSubview(signupButton)
        signupButton.layer.cornerRadius = 7
        signupButton.layer.borderWidth = borderWidth
        signupButton.layer.borderColor = borderColor
        signupButton.backgroundColor = UIColor.themeLightBlue
        signupButton.setTitle("Signup", for: .normal)
        signupButton.titleLabel?.font = UIFont.themeSmallBold
        signupButton.setTitleColor(UIColor.themeDarkBlue, for: .normal)
        signupButton.addTarget(self, action: #selector(signupButtonAction), for: .touchUpInside)
        
        cancelButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width * 0.4, height: self.view.frame.size.height * 0.06))
        cancelButton.layer.cornerRadius = 7
        cancelButton.layer.borderWidth = borderWidth
        cancelButton.layer.borderColor = borderColor
        self.view.addSubview(cancelButton)
        cancelButton.backgroundColor = UIColor.themeWhite
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.themeSmallBold
        cancelButton.setTitleColor(UIColor.themeDarkBlue, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
    }
}




