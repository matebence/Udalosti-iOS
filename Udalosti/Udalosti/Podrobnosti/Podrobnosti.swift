//
//  Podrobnosti.swift
//  Udalosti
//
//  Created by Bence Mate on 11/14/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import Alamofire

class Podrobnosti: UIViewController, KommunikaciaOdpoved, KommunikaciaData {

    private let delegate = UIApplication.shared.delegate as! AppDelegate
    
    private var udalostiUdaje : UdalostiUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
   
    private var pouzivatelskeUdaje: NSDictionary!
    private var stavTlacidla:Int!
    
    var udalost:Udalost!
    
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    
    @IBOutlet weak var tlacidlo: UIButton!
    @IBOutlet weak var obsahObrazka: UIImageView!
    @IBOutlet weak var nazovMiesto: UIStackView!
    @IBOutlet weak var oddelovac: UIView!
    @IBOutlet weak var zaujemcovia: UIStackView!
    @IBOutlet weak var vstupenka: UIStackView!
    @IBOutlet weak var cas: UIStackView!
    
    @IBOutlet weak var obrazokZvolenejUdalosti: UIImageView!
    @IBOutlet weak var denZvolenejUdalosti: UILabel!
    @IBOutlet weak var mesiacZvolenejUdalosti: UILabel!
    @IBOutlet weak var nazovZvolenejUdalosti: UILabel!
    @IBOutlet weak var miestoZvolenejUdalosti: UILabel!
    @IBOutlet weak var pocetZaujemcovZvolenejUdalosti: UILabel!
    @IBOutlet weak var vstupenkaZvolenejUdalosti: UILabel!
    @IBOutlet weak var casZvolenejUdalosti: UILabel!

    @IBAction func zaujem(_ sender: Any) {
        print("Metoda zaujem bola vykonana")
        
        if(self.stavTlacidla == 1){
            self.stavTlacidla = 0
            self.udalostiUdaje.odstranZaujem(
                email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                token: self.pouzivatelskeUdaje.value(forKey: "token") as! String,
                idUdalost: Int(self.udalost.idUdalost!)!)
        }else{
            self.stavTlacidla = 1
            self.udalostiUdaje.zaujem(
                email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                token: self.pouzivatelskeUdaje.value(forKey: "token") as! String,
                idUdalost: Int(self.udalost.idUdalost!)!)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("Metoda viewWillDisappear - Podrobnosti bola vykonana")
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        print("Metoda viewDidLoad - Podrobnosti bola vykonana")
        
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        inicializacia()
    }
    
    private func inicializacia (){
        print("Metoda inicializacia - Podrobnosti bola vykonana")
        
        self.stavTlacidla = Int(self.udalost.zaujem!)!
        
        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self, kommunikaciaData: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
        self.pouzivatelskeUdaje = self.uvodnaObrazovkaUdaje.prihlasPouzivatela()
        
        if(Pripojenie.spojenieExistuje()){
            self.udalostiUdaje.potvrdZaujem(
                email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                token: self.pouzivatelskeUdaje.value(forKey: "token") as! String,
                idUdalost: Int(self.udalost.idUdalost!)!)
        }else{
            self.denZvolenejUdalosti.text = self.udalost.den
            self.mesiacZvolenejUdalosti.text = self.udalost.mesiac
            self.nazovZvolenejUdalosti.text = self.udalost.nazov
            self.miestoZvolenejUdalosti.text = self.udalost.mesto!+self.udalost.ulica!
            self.pocetZaujemcovZvolenejUdalosti.text = self.udalost.zaujemcovia
            self.vstupenkaZvolenejUdalosti.text = self.udalost.vstupenka!+"€"
            self.casZvolenejUdalosti.text = self.udalost.cas
            
            nacitajObrazok(obrazok: self.udalost.obrazok!)
            
            nastavTlacidlo(stavTlacidla: Int(self.udalost.zaujem!)!)
            
            self.tlacidlo.isHidden = false
            self.obsahObrazka.isHidden = false
            self.nazovMiesto.isHidden = false
            self.oddelovac.isHidden = false
            self.zaujemcovia.isHidden = false
            self.vstupenka.isHidden = false
            self.cas.isHidden = false
            
            nacitavanie.isHidden = true
        }
    }
    
    private func nacitajObrazok(obrazok: String){
        print("Metoda nacitajObrazok bola vykonana")
        
        Alamofire.request(self.delegate.udalostiAdresa+obrazok).responseImage { response in
            debugPrint(response)
            
            if let obrazokUdalosti = response.result.value {
                self.obrazokZvolenejUdalosti.image = Obrazok.nastavObrazok(obrazokUdalosti, sirka: self.obrazokZvolenejUdalosti.frame.width)
            }else {
                self.obrazokZvolenejUdalosti.image = UIImage(named: "chyba_obrazka")!
                self.obrazokZvolenejUdalosti.contentMode = .scaleAspectFill;
            }
        }
    }
    
    private func nastavTlacidlo(stavTlacidla: Int){
        print("Metoda nastavTlacidlo bola vykonana")
        
        if(stavTlacidla == 1){
            self.tlacidlo.setTitle("Odstrániť zo záujmov", for: .normal)
            self.tlacidlo.backgroundColor = UIColor(red:0.67, green:0.15, blue:0.15, alpha:1.0)
        }else{
            self.tlacidlo.setTitle("Mám záujem", for: .normal)
            self.tlacidlo.backgroundColor = UIColor(red:0.00, green:0.36, blue:0.65, alpha:1.0)
        }
    }
    
    func dataZoServera(odpoved: String, od: String, data: NSArray?) {
        print("Metoda dataZoServera - Podrobnosti bola vykonana")

        switch od {
            case Nastavenia.ZAUJEM_POTVRD:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    if(data != nil){
                        if(data?.count == 1){
                            nacitajObrazok(obrazok: (data![0] as AnyObject).value(forKey: "obrazok") as! String)
                            
                            self.stavTlacidla = Int((data![0] as AnyObject).value(forKey: "zaujem") as! String)!
                            self.pocetZaujemcovZvolenejUdalosti.text = (data![0] as AnyObject).value(forKey: "zaujemcovia") as? String
                            self.denZvolenejUdalosti.text = (data![0] as AnyObject).value(forKey: "den") as! String+"."
                            self.mesiacZvolenejUdalosti.text = ((data![0] as AnyObject).value(forKey: "mesiac") as! String).castRetazca(doRetazca: 3)+"."
                            self.nazovZvolenejUdalosti.text = (data![0] as AnyObject).value(forKey: "nazov") as? String
                            self.miestoZvolenejUdalosti.text = ((data![0] as AnyObject).value(forKey: "mesto") as! String)+", "+((data![0] as AnyObject).value(forKey: "ulica") as! String)
                            self.vstupenkaZvolenejUdalosti.text = (data![0] as AnyObject).value(forKey: "vstupenka") as! String+"€"
                            self.casZvolenejUdalosti.text = (data![0] as AnyObject).value(forKey: "cas") as? String
                            
                            nastavTlacidlo(stavTlacidla: Int((data![0] as AnyObject).value(forKey: "zaujem") as! String)!)
                        }
                    }
                    
                    self.tlacidlo.isHidden = false
                    self.obsahObrazka.isHidden = false
                    self.nazovMiesto.isHidden = false
                    self.oddelovac.isHidden = false
                    self.zaujemcovia.isHidden = false
                    self.vstupenka.isHidden = false
                    self.cas.isHidden = false
                    
                    nacitavanie.isHidden = true
                }else{
                    
                    let chyba = UIAlertController(title: "Chyba", message: odpoved, preferredStyle: UIAlertController.Style.alert)
                    chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertAction.Style.default, handler: nil))
                    self.present(chyba, animated: true, completion: nil)
                }
                break;
                
            default: break
        }
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - Podrobnosti bola vykonana")

        switch od {
            case Nastavenia.ZAUJEM_ODSTRANENIE:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    
                    if(udaje?.value(forKey: "uspech") != nil){
                        var zaujemcovia: Int = Int(self.pocetZaujemcovZvolenejUdalosti.text!)!
                        zaujemcovia = zaujemcovia-1
                        self.pocetZaujemcovZvolenejUdalosti!.text = String (zaujemcovia)
                        
                        AktualizatorObsahu.zaujmy().hodnota()
                        nastavTlacidlo(stavTlacidla: 0)
                    }else{
                        
                        let chyba = UIAlertController(title: "Chyba", message: udaje!.value(forKey: "chyba") as? String, preferredStyle: UIAlertController.Style.alert)
                        chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertAction.Style.default, handler: nil))
                        self.present(chyba, animated: true, completion: nil)
                    }
                }else{
                    
                    let chyba = UIAlertController(title: "Chyba", message: odpoved, preferredStyle: UIAlertController.Style.alert)
                    chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertAction.Style.default, handler: nil))
                    self.present(chyba, animated: true, completion: nil)
                }
                break;
            
            case Nastavenia.ZAUJEM:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                
                    if(udaje?.value(forKey: "uspech") != nil){
                        var zaujemcovia: Int = Int(self.pocetZaujemcovZvolenejUdalosti.text!)!
                        zaujemcovia = zaujemcovia+1
                        self.pocetZaujemcovZvolenejUdalosti!.text = String (zaujemcovia)
                        
                        AktualizatorObsahu.zaujmy().hodnota()
                        nastavTlacidlo(stavTlacidla: 1)
                    }else{
                        
                        let chyba = UIAlertController(title: "Chyba", message: udaje!.value(forKey: "chyba") as? String, preferredStyle: UIAlertController.Style.alert)
                        chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertAction.Style.default, handler: nil))
                        self.present(chyba, animated: true, completion: nil)
                    }
                }else{
                    
                    let chyba = UIAlertController(title: "Chyba", message: odpoved, preferredStyle: UIAlertController.Style.alert)
                    chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertAction.Style.default, handler: nil))
                    self.present(chyba, animated: true, completion: nil)
                }
                break;
            
            default: break
        }
    }
}
