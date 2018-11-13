//
//  UvodnaObrazovka.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import CoreLocation

class UvodnaObrazovka: UIViewController, CLLocationManagerDelegate, KommunikaciaOdpoved {

    var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    var autentifikaciaUdaje: AutentifikaciaUdaje!
    
    var manazerPozicie:CLLocationManager!
    var pouzivatelskeUdaje: NSDictionary!
    
    var ipPozicia = true
    var spracovane = false
    
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        print("Metoda viewDidAppear - UvodnaObrazovka bola vykonana")

        self.nacitavanie.isHidden = false
        self.pristup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Metoda prepare - UvodnaObrazovka bola vykonana")

        if segue.identifier == "automatickePrihlasenie" {
            let automatickePrihlasenie = segue.destination as! Autentifikacia
            automatickePrihlasenie.chyba = sender as? Bool
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("Metoda preferredStatusBarStyle - UvodnaObrazovka bola vykonana")

        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        print("Metoda didReceiveMemoryWarning - UvodnaObrazovka bola vykonana")

        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        print("Metoda viewDidLoad - UvodnaObrazovka bola vykonana")

        super.viewDidLoad()
        self.inicializacia()
    }
    
    func inicializacia(){
        print("Metoda inicializacia - UvodnaObrazovka bola vykonana")
        
        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
        
        self.manazerPozicie = CLLocationManager()
        self.manazerPozicie.delegate = self
        self.manazerPozicie.desiredAccuracy = kCLLocationAccuracyBest
        self.manazerPozicie.requestWhenInUseAuthorization()
        
        self.pouzivatelskeUdaje = uvodnaObrazovkaUdaje.prihlasPouzivatela()
    }
    
    func pristup(){
        print("Metoda pristup bola vykonana")

        if Pripojenie.spojenieExistuje(){
            if(uvodnaObrazovkaUdaje.zistiCiPouzivatelExistuje()){
                if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                    
                    let cas = 20.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + cas) {
                        if(self.ipPozicia){
                            self.autentifikaciaUdaje.miestoPrihlasenia(
                                email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                                heslo: self.pouzivatelskeUdaje.value(forKey: "heslo")as! String)
                            
                            self.nacitavanie.isHidden = false
                            self.manazerPozicie.stopUpdatingLocation()
                        }
                    }
                    
                    if CLLocationManager.locationServicesEnabled() {
                        self.manazerPozicie.startUpdatingLocation()
                    }
                    
                }else{
                    self.autentifikaciaUdaje.miestoPrihlasenia(
                        email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                        heslo: self.pouzivatelskeUdaje.value(forKey: "heslo")as! String)
                    
                    self.nacitavanie.isHidden = false
                }
            }else{
                performSegue(withIdentifier: "automatickePrihlasenie", sender: nil)
            }
        }else{
            performSegue(withIdentifier: "automatickePrihlasenie", sender: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Metoda locationManager - UvodnaObrazovka bola vykonana")
        
        if(!spracovane){
            spracovane = true
            let pozicia:CLLocation = locations[0] as CLLocation
            
            self.ipPozicia = false;
            self.autentifikaciaUdaje.miestoPrihlasenia(
                email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                heslo: self.pouzivatelskeUdaje.value(forKey: "heslo")as! String,
                zemepisnaSirka: pozicia.coordinate.latitude,
                zemepisnaDlzka: pozicia.coordinate.longitude,
                aktualizuj: false)
            
            self.nacitavanie.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Metoda locationManager - UvodnaObrazovka bola vykonana")
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - UvodnaObrazovka bola vykonana")

        switch od {
        case Nastavenia.AUTENTIFIKACIA_PRIHLASENIE:
            self.manazerPozicie.stopUpdatingLocation()

            if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                let email =  udaje!.value(forKey: "email") as! String
                let heslo = udaje!.value(forKey: "heslo") as! String
                let token =  udaje!.value(forKey: "token") as! String
                
                self.autentifikaciaUdaje.ulozPrihlasovacieUdajeDoDatabazy(email: email, heslo: heslo, token: token)

                let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
                let navigaciaUdalostiController = udalosti.instantiateViewController(withIdentifier: "NavigaciaUdalosti")
                
                self.present(navigaciaUdalostiController, animated: true, completion: nil)
            }else{
                performSegue(withIdentifier: "automatickePrihlasenie", sender: true)
                autentifikaciaUdaje.ucetJeNePristupny(email: self.pouzivatelskeUdaje.value(forKey: "email") as! String)
            }
            break;
        default: break
        }
        nacitavanie.isHidden = true
    }
}
