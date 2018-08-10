//
//  Prihlasenie.swift
//  Udalosti
//
//  Created by Bence Mate on 8/5/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class Prihlasenie: UIViewController, KommunikaciaOdpoved, UITextFieldDelegate {
    
    var autentifikaciaUdaje : AutentifikaciaUdaje!

    @IBOutlet weak var vstupEmailu: UITextField!
    @IBOutlet weak var vstupHesla: UITextField!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    
    @IBAction func prihlasitSa(_ sender: UIButton) {
        print("Metoda prihlasitSa bola vykonana")
        
        self.nacitavanie.isHidden = false
        self.autentifikaciaUdaje.miestoPrihlasenia(
            email: vstupEmailu.text!,
            heslo: vstupHesla.text!)
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        if Pripojenie.spojenieExistuje(){
            switch od {
            case Nastavenia.AUTENTIFIKACIA_PRIHLASENIE:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    let email =  udaje!.value(forKey: "email") as! String
                    let heslo = udaje!.value(forKey: "heslo") as! String
                    let token =  udaje!.value(forKey: "token") as! String
                    
                    self.autentifikaciaUdaje.ulozPrihlasovacieUdajeDoDatabazy(
                        email: email,
                        heslo: heslo,
                        token: token)
                    
                    let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
                    let navigaciaUdalostiController = udalosti.instantiateViewController(withIdentifier: "NavigaciaUdalosti")
                    self.present(navigaciaUdalostiController, animated: true, completion: nil)
                }else{
                    let chyba = UIAlertController(title: "Chyba", message: odpoved, preferredStyle: UIAlertControllerStyle.alert)
                    chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertActionStyle.default, handler: nil))
                    self.present(chyba, animated: true, completion: nil)
                }
                break;
            default: break
            }
        }else{
            let chyba = UIAlertController(title: "Chyba", message: "Žiadne spojenie", preferredStyle: UIAlertControllerStyle.alert)
            chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertActionStyle.default, handler: nil))
            self.present(chyba, animated: true, completion: nil)
        }
        nacitavanie.isHidden = true
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
        print("Metoda inicializacia-Prihlasenie bola vykonana")

        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        self.vstupEmailu.delegate = self
        self.vstupHesla.delegate = self
        
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
        posunVstupVyssie(textField, moveDistance: -100, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        posunVstupVyssie(textField, moveDistance: -100, up: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
