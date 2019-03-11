//
//  Prihlasenie.swift
//  Udalosti
//
//  Created by Bence Mate on 8/5/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import CoreLocation

class Prihlasenie: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, KommunikaciaOdpoved {
    
    private var autentifikaciaUdaje : AutentifikaciaUdaje!
    private var manazerPozicie:CLLocationManager!

    private var poziadavka = true
    private var server = false
    
    @IBOutlet weak var vstupEmailu: UITextField!
    @IBOutlet weak var vstupHesla: UITextField!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    
    @IBAction func prihlasitSa(_ sender: UIButton) {
        print("Metoda prihlasitSa bola vykonana")
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            let cas = 20.0
            DispatchQueue.main.asyncAfter(deadline: .now() + cas) {
                if(self.poziadavka){
                    self.autentifikaciaUdaje.miestoPrihlasenia(
                        email: self.vstupEmailu.text!,
                        heslo: self.vstupHesla.text!)
                    
                    self.nacitavanie.isHidden = false
                    self.manazerPozicie.stopUpdatingLocation()
                }
            }
            
            if CLLocationManager.locationServicesEnabled() {
                self.manazerPozicie.startUpdatingLocation()
            }
            
        }else{
            self.autentifikaciaUdaje.miestoPrihlasenia(
                email: self.vstupEmailu.text!,
                heslo: self.vstupHesla.text!)
            
            self.nacitavanie.isHidden = false
        }
    }
    
    @objc func klavesnica() {
        print("Metoda klavesnica - Prihlasenie bola vykonana")

        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        print("Metoda textFieldShouldReturn - Prihlasenie bola vykonana")

        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Metoda textFieldDidBeginEditing - Prihlasenie bola vykonana")

        posunVstupVyssie(textField, moveDistance: -100, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Metoda textFieldDidEndEditing - Prihlasenie bola vykonana")

        posunVstupVyssie(textField, moveDistance: -100, up: false)
    }
    
    override func didReceiveMemoryWarning() {
        print("Metoda didReceiveMemoryWarning - Prihlasenie bola vykonana")

        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        print("Metoda viewDidLoad - Prihlasenie bola vykonana")

        super.viewDidLoad()
        inicializacia()
    }
    
    private func inicializacia(){
        print("Metoda inicializacia - Prihlasenie bola vykonana")
        
        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        
        self.manazerPozicie = CLLocationManager()
        self.manazerPozicie.delegate = self
        self.manazerPozicie.desiredAccuracy = kCLLocationAccuracyBest
        self.manazerPozicie.requestWhenInUseAuthorization()
        
        self.vstupEmailu.delegate = self
        self.vstupHesla.delegate = self
        
        let vypnutKlavesnicu = UITapGestureRecognizer(target: self, action: #selector(klavesnica))
        view.addGestureRecognizer(vypnutKlavesnicu)
    }
    
    private func posunVstupVyssie(_ textField: UITextField, moveDistance: Int, up: Bool) {
        print("Metoda posunVstupVyssie - Prihlasenie bola vykonana")

        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Metoda locationManager - Prihlasenie bola vykonana")

        if(!self.server){
            self.server = true;
            let pozicia:CLLocation = locations[0] as CLLocation
            
            self.poziadavka = false;
            self.autentifikaciaUdaje.miestoPrihlasenia(
                email: self.vstupEmailu.text!,
                heslo: self.vstupHesla.text!,
                zemepisnaSirka: pozicia.coordinate.latitude,
                zemepisnaDlzka: pozicia.coordinate.longitude,
                aktualizuj: false)
            
            self.nacitavanie.isHidden = false
            self.manazerPozicie.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Metoda locationManager - Prihlasenie bola vykonana")
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - Prihlasenie bola vykonana")

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
                        self.server = false
                        
                        let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
                        let navigaciaUdalostiController = udalosti.instantiateViewController(withIdentifier: "NavigaciaUdalosti")
                        self.present(navigaciaUdalostiController, animated: true, completion: nil)
                    }else{
                        let chyba = UIAlertController(title: "Chyba", message: odpoved, preferredStyle: UIAlertController.Style.alert)
                        chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(chyba, animated: true, completion: nil)
                        self.server = false
                    }
                    break;
                
                default: break
            }
        }else{
            let chyba = UIAlertController(title: "Chyba", message: "Žiadne spojenie", preferredStyle: UIAlertController.Style.alert)
            chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertAction.Style.default, handler: nil))
            self.present(chyba, animated: true, completion: nil)
        }
        self.nacitavanie.isHidden = true
    }
}
