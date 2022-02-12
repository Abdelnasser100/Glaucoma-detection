//
//  SignViewController.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 18/11/2021.
//

import UIKit
import ProgressHUD

class SignViewController: UIViewController, UITextFieldDelegate {

    var isLogin:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundTap()
        
        swapMainView(button: signInBtnOutLit)
        
        emailTextField_Up.delegate = self
        passwordTextField_Up.delegate = self
        confiemPasswordTextField_Up.delegate = self
    }
    
//MARK: - OutoLay Out
    
    @IBOutlet weak var cardViewUnder_UP: UIView!
    @IBOutlet weak var cardViewUnder_In: UIView!
    @IBOutlet weak var cardViewMainUp: UIView!
    @IBOutlet weak var cardViewMainIn: UIView!
    
    @IBOutlet weak var emailTextField_Up: UITextField!
    @IBOutlet weak var passwordTextField_Up: UITextField!
    @IBOutlet weak var confiemPasswordTextField_Up: UITextField!
    
  
    @IBOutlet weak var emailTextField_In: UITextField!
    @IBOutlet weak var passwordTextField_In: UITextField!
    @IBOutlet weak var forgetPassword_In: UIButton!
    
    @IBOutlet weak var signUpBtuOutLit: UIButton!
    @IBOutlet weak var signInBtnOutLit: UIButton!
    
    
    //MARK: - OutLit Action
    
    
    
    @IBAction func regesterBtu(_ sender: UIButton) {
        if isDatainputFor(mode: "regester"){
             regesterUser()
        }else{
            ProgressHUD.showError("All field are requaird")
        }
    }
    
    
    @IBAction func loginBtu(_ sender: UIButton) {
        if isDatainputFor(mode: "login"){
             logInUser()
        }else{
            ProgressHUD.showError("All field are requaird")
        }
        
    }
    
    
    @IBAction func sendEmilVerfecationBtu(_ sender: UIButton) {
        
        resendEmailVerfication()
    }
    
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        
        if isDatainputFor(mode: "forgetPassword_In"){
            print("All data input correct")
            
            forgetPassword()
            
        }else{
            ProgressHUD.showError("all field are requird")
        }
    }
    
    
    @IBAction func signUpClick(_ sender: UIButton) {
        swapMainView(button: signUpBtuOutLit)
    }
    
    @IBAction func signInClick(_ sender: UIButton) {
         swapMainView(button: signInBtnOutLit)
    }
    
    
    //MARK: - swap betwen View
    
    func swapMainView(button:UIButton){
        switch button {
        case signUpBtuOutLit:
            cardViewMainUp.isHidden = false
            cardViewMainIn.isHidden = true
            UIView.animate(withDuration: 0.3) { [self] in
                cardViewUnder_UP.backgroundColor = #colorLiteral(red: 0.5569637418, green: 0.8388422132, blue: 0.6210408807, alpha: 1)
                cardViewUnder_In.backgroundColor = .clear
                signUpBtuOutLit.titleLabel?.font = UIFont(name: "Almarai Bold", size: 16)
                signInBtnOutLit.titleLabel?.font = UIFont(name: "Almarai", size: 16)
                view.layoutIfNeeded()
            }
        case signInBtnOutLit:
            cardViewMainUp.isHidden = true
            cardViewMainIn.isHidden = false
            UIView.animate(withDuration: 0.3) { [self] in
                cardViewUnder_UP.backgroundColor = .clear
                cardViewUnder_In.backgroundColor = #colorLiteral(red: 0.5569637418, green: 0.8388422132, blue: 0.6210408807, alpha: 1)
                signInBtnOutLit.titleLabel?.font = UIFont(name: "Almarai Bold", size: 16)
                signUpBtuOutLit.titleLabel?.font = UIFont(name: "Almarai", size: 16)
                view.layoutIfNeeded()
            }
        default:
            print("Select 1 Or 2")
        }
    }

    
    
    //MARK: - Utilities
    
    func isDatainputFor(mode:String)->Bool{
        
        switch mode{
        
        case "login":
            return emailTextField_In.text != "" && passwordTextField_In.text != ""
            
        case "regester":
            return emailTextField_Up.text != "" && passwordTextField_Up.text != "" && confiemPasswordTextField_Up.text != ""
            
        case "forgetPassword_In":
            return emailTextField_In.text != ""
            
            default:
            return false
        }
    }
    
    //MARK: - Regester User
    
    private func regesterUser(){
        if passwordTextField_Up.text! == confiemPasswordTextField_Up.text!{
            FUserListner.shared.regesterUserwith(email: emailTextField_Up.text!, password: passwordTextField_Up.text!) { (error) in
                if error == nil{
                    ProgressHUD.showSuccess("verifiction email send,please verfy your email and confirm the regester")
                }else{
                    ProgressHUD.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    
    
    //MARK: - login User
    
    private func logInUser(){
        FUserListner.shared.loginUserWith(email: emailTextField_In.text!, password: passwordTextField_In.text!) { (error, isEmailVerfied) in
            if error == nil{
                if isEmailVerfied{
                    self.goToApp()
                }else{
                    ProgressHUD.showFailed("Please check your email and verfiy your regestretion")
                }
            }else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    
    
    //MARK: - Navagation
    
    private func goToApp(){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBar")as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Resend email verfication
    
    func resendEmailVerfication(){
        FUserListner.shared.resendVerificationEmailWith(email: emailTextField_In.text!) { (error) in
            if error == nil{
                ProgressHUD.showSuccess("Verfication email send succesfuly")
            }else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    
    //MARK: -  forget Password
    
    func forgetPassword(){
        FUserListner.shared.resetPasswordFor(email: emailTextField_In.text!) { (error) in
            if error == nil{
                ProgressHUD.showSuccess("Reset password email has send")
            }else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    
    //MARK: - tap Qesture Recognized
    
    private func setupBackgroundTap(){
        
        let tapQesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapQesture)
    }
    @objc func hideKeyboard(){
        view.endEditing(false)
    }
}
