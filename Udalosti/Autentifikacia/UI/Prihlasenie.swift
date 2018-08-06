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
    
    @IBAction func prihlasitSa(_ sender: UIButton) {
        self.autentifikaciaUdaje.miestoPrihlasenia(email: vstupEmailu.text!, heslo: vstupHesla.text!)
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        if Pripojenie.spojenieExistuje(){
            switch od {
            case Nastavenia.AUTENTIFIKACIA_PRIHLASENIE:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){

                }else{

                }
                break;
            default: break
            }
        }else{
            let chyba = UIAlertController(title: "Chyba", message: "Žiadne spojenie", preferredStyle: UIAlertControllerStyle.alert)
            chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertActionStyle.default, handler: nil))
            self.present(chyba, animated: true, completion: nil)
        }
    }
    
    @objc func klavesnica() {
        view.endEditing(true)
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
    
    
    func posunVstupVyssie(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    override func viewDidLoad() {
        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        
        self.vstupEmailu.delegate = self
        self.vstupHesla.delegate = self

        let vypnutKlavesnicu = UITapGestureRecognizer(target: self, action: #selector(klavesnica))
        view.addGestureRecognizer(vypnutKlavesnicu)
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
