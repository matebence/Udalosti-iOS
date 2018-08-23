//
//  Registracia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/5/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class Registracia: UIViewController, KommunikaciaOdpoved, UITextFieldDelegate {
       
    var autentifikaciaUdaje : AutentifikaciaUdaje!
    
    @IBOutlet weak var vstupPouzivatelskeMena: UITextField!
    @IBOutlet weak var vstupEmailu: UITextField!
    @IBOutlet weak var vstupHesla: UITextField!
    @IBOutlet weak var vstupPotvrdenieHesla: UITextField!

    @IBOutlet weak var titulRegistracia: UILabel!
    @IBOutlet weak var titulObrazok: UIImageView!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    
    
    @IBAction func registrovatSa(_ sender: UIButton) {
        print("Metoda registrovatSa bola vykonana")

        self.nacitavanie.isHidden = false
        self.autentifikaciaUdaje.registracia(
            meno: vstupPouzivatelskeMena.text!,
            email: vstupEmailu.text!, heslo: vstupHesla.text!,
            potvrd: vstupPotvrdenieHesla.text!)
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {       
        if Pripojenie.spojenieExistuje(){
            switch od {
            case Nastavenia.AUTENTIFIKACIA_REGISRACIA:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    let chyba = UIAlertController(title: "Úspech", message: "Registrácia prebehla úspešne", preferredStyle: UIAlertControllerStyle.alert)
                    chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertActionStyle.default, handler: {
                        action in
                        self.spustiPrihlasenie()
                    }))
                    self.present(chyba, animated: true, completion: nil)
                }else{
                    let chyba = UIAlertController(title: "Chyba", message: odpoved, preferredStyle: UIAlertControllerStyle.alert)
                    chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertActionStyle.default, handler: nil))
                    self.present(chyba, animated: true, completion: nil)
                }
                break;
            default:
                break
            }
        }else{
            let chyba = UIAlertController(title: "Chyba", message: "Žiadne spojenie", preferredStyle: UIAlertControllerStyle.alert)
            chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertActionStyle.default, handler: nil))
            self.present(chyba, animated: true, completion: nil)
        }
        nacitavanie.isHidden = true
    }
    
    func spustiPrihlasenie(){
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func posunVstupVyssie(_ textField: UITextField, moveDistance: Int, up: Bool) {
        print("Metoda posunVstupVyssie bola vykonana")

        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    @objc func klavesnica() {
        print("Metoda klavesnica bola vykonana")
        
        view.endEditing(true)
    }

    func inicializacia(){
        print("Metoda inicializacia-Registracia bola vykonana")

        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        
        self.vstupPouzivatelskeMena.delegate = self
        self.vstupEmailu.delegate = self
        self.vstupHesla.delegate = self
        self.vstupPotvrdenieHesla.delegate = self
        
        let vypnutKlavesnicu = UITapGestureRecognizer(target: self, action: #selector(klavesnica))
        view.addGestureRecognizer(vypnutKlavesnicu)
    }
    
    override func viewDidLoad() {
        self.inicializacia()
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.posunVstupVyssie(textField, moveDistance: -100, up: true)
        self.titulRegistracia.isHidden = true
        self.titulObrazok.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        posunVstupVyssie(textField, moveDistance: -100, up: false)
        self.titulRegistracia.isHidden = false
        self.titulObrazok.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
