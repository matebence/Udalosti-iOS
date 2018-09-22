//
//  UvodnaObrazovka.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//
import UIKit

class UvodnaObrazovka: UIViewController, KommunikaciaOdpoved {

    var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    var autentifikaciaUdaje: AutentifikaciaUdaje!
    var pouzivatelskeUdaje: NSDictionary!

    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        switch od {
            case Nastavenia.AUTENTIFIKACIA_PRIHLASENIE:
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
    
    func pristup(){
        print("Metoda pristup bola vykonana")

        if Pripojenie.spojenieExistuje(){
            if(uvodnaObrazovkaUdaje.zistiCiPouzivatelExistuje()){
                self.pouzivatelskeUdaje = uvodnaObrazovkaUdaje.prihlasPouzivatela()
                autentifikaciaUdaje.miestoPrihlasenia(email: self.pouzivatelskeUdaje.value(forKey: "email") as! String, heslo: self.pouzivatelskeUdaje.value(forKey: "heslo")as! String)
            }else{
                performSegue(withIdentifier: "automatickePrihlasenie", sender: nil)
            }
        }else{
            performSegue(withIdentifier: "automatickePrihlasenie", sender: nil)
        }
    }
    
    func inicializacia(){
        print("Metoda inicializacia-UvodnaObrazovka bola vykonana")
        
        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
    }
    
    override func viewDidLoad() {
        self.inicializacia()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.nacitavanie.isHidden = false
        self.pristup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "automatickePrihlasenie" {
            let automatickePrihlasenie = segue.destination as! Autentifikacia
            automatickePrihlasenie.chyba = sender as? Bool
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
