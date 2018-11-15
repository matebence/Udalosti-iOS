//
//  Lokalizator.swift
//  Udalosti
//
//  Created by Bence Mate on 8/9/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import AlamofireImage

class Lokalizator: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, KommunikaciaOdpoved, KommunikaciaData{
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    
    private var udalostiUdaje : UdalostiUdaje!
    private var autentifikaciaUdaje : AutentifikaciaUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    
    private var pouzivatelskeUdaje: NSDictionary!
    private var udalostiPodlaPozicie = [Udalost]()
    private var manazerPozicie:CLLocationManager!

    private var poziadavka = true
    private var server = false
    
    @IBOutlet weak var zoznamUdalostiPodlaPozicie: UITableView!
    @IBOutlet weak var titul: UINavigationItem!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    @IBOutlet weak var ziadneUdalosti: UIImageView!
    
    private var aktualizator = UIRefreshControl()
    
    @IBAction func odhlasitSa(_ sender: UIBarButtonItem) {
        print("Metoda odhlasitSa - Lokalizator bola vykonana")

        self.udalostiUdaje.odhlasenie(email: self.pouzivatelskeUdaje.value(forKey: "email") as! String)
    }
    
    @objc func aktualizuj(_ sender: Any) {
        print("Metoda aktualizuj - Lokalizator bola vykonana")
        
        if(Pripojenie.spojenieExistuje()){
            self.udalostiPodlaPozicie.removeAll()
            miestoPrihlasenia()
        }else{
            self.zoznamUdalostiPodlaPozicie.isHidden = true
            self.aktualizator.isHidden = true
            
            self.ziadneUdalosti.image = UIImage(named: "ziadne_spojenie")
            self.ziadneUdalosti.isHidden = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("Metoda preferredStatusBarStyle - Lokalizator bola vykonana")

        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        print("Metoda didReceiveMemoryWarning - Lokalizator bola vykonana")

        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        print("Metoda viewDidLoad - Lokalizator bola vykonana")

        super.viewDidLoad()        
        inicializacia()
    }
    
    private func inicializacia (){
        print("Metoda inicializacia - Lokalizator bola vykonana")
        
        self.manazerPozicie = CLLocationManager()
        self.manazerPozicie.delegate = self
        self.manazerPozicie.desiredAccuracy = kCLLocationAccuracyBest
        
       pristupKuPozicie()
        
        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self, kommunikaciaData: self)
        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
        
        miestoPrihlasenia()
        nastavAktualizator()
    }
    
    private func pristupKuPozicie(){
        print("Metoda pristupKuPozicie - Lokalizator bola vykonana")

        switch CLLocationManager.authorizationStatus() {
            case .denied:
                let alertController = UIAlertController(
                    title: "Zistenie pozície",
                    message: "Prístup ku aktuálnej pozície bol odmietnutý",
                    preferredStyle: .alert)
                
                let odmietnut = UIAlertAction(title: "Zatvoriť", style: .cancel, handler: nil)
                alertController.addAction(odmietnut)
                
                let nastavenia = UIAlertAction(title: "Zapnúť", style: .default) { (action) in
                    if let adresa = NSURL(string:UIApplication.openSettingsURLString) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(adresa as URL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(adresa as URL)
                        }
                    }
                }
                alertController.addAction(nastavenia)
                
                self.present(alertController, animated: true, completion: nil)
            
            default: break;
            }
    }
    
    private func miestoPrihlasenia(){
        print("Metoda miestoPrihlasenia bola vykonana")
        
        let miesto: NSDictionary = self.udalostiUdaje.miestoPrihlasenia()
        self.pouzivatelskeUdaje = self.uvodnaObrazovkaUdaje.prihlasPouzivatela()

        if miesto.value(forKey: "pozicia") as! String != "" {
            self.titul.title = "Okolie \(miesto.value(forKey: "pozicia") ?? "Pozícia neurčená")"
        }else if miesto.value(forKey: "okres") as! String != "" {
            self.titul.title = miesto.value(forKey: "okres") as? String
        }else if miesto.value(forKey: "kraj") as! String != "" {
            self.titul.title = miesto.value(forKey: "kraj") as? String
        }else{
            self.titul.title = "Pozícia neurčená"
        }
        
        if self.udalostiPodlaPozicie.count == 0{
            nacitajZoznamUdalostiPodlaPozicie(miesto: miesto)
        }
    }
    
    private func nastavAktualizator(){
        print("Metoda nastavAktualizator - Lokalizator bola vykonana")
        
        self.aktualizator.backgroundColor = UIColor(red:0.00, green:0.36, blue:0.65, alpha:1.0)
        self.aktualizator.tintColor = UIColor.white
        self.aktualizator.addTarget(self, action: #selector(aktualizuj(_:)), for: .valueChanged)
        
        self.zoznamUdalostiPodlaPozicie.addSubview(self.aktualizator)
    }
    
    private func nacitajZoznamUdalostiPodlaPozicie(miesto: NSDictionary){
        print("Metoda nacitajZoznamUdalostiPodlaPozicie bola vykonana")
        
        self.nacitavanie.isHidden = false
        
        if miesto.value(forKey: "pozicia") as! String == "" {
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                
                let cas = 20.0
                DispatchQueue.main.asyncAfter(deadline: .now() + cas) {
                    if(self.poziadavka){
                        self.udalostiUdaje.zoznamUdalostiPodlaPozicie(
                            email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                            stat: miesto.value(forKey: "stat") as! String,
                            okres: miesto.value(forKey: "okres") as! String,
                            mesto: miesto.value(forKey: "pozicia") as! String,
                            token: self.pouzivatelskeUdaje.value(forKey: "token") as! String)
                        
                        self.manazerPozicie.stopUpdatingLocation()
                    }
                }
                
                if CLLocationManager.locationServicesEnabled() {
                    self.manazerPozicie.startUpdatingLocation()
                }
                
            }else{
                self.udalostiUdaje.zoznamUdalostiPodlaPozicie(
                    email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                    stat: miesto.value(forKey: "stat") as! String,
                    okres: miesto.value(forKey: "okres") as! String,
                    mesto: miesto.value(forKey: "pozicia") as! String,
                    token: self.pouzivatelskeUdaje.value(forKey: "token") as! String)
            }
        }else{
            self.udalostiUdaje.zoznamUdalostiPodlaPozicie(
                email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                stat: miesto.value(forKey: "stat") as! String,
                okres: miesto.value(forKey: "okres") as! String,
                mesto: miesto.value(forKey: "pozicia") as! String,
                token: self.pouzivatelskeUdaje.value(forKey: "token") as! String)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Metoda tableView - numberOfRowsInSection - Lokalizator bola vykonana")

        return self.udalostiPodlaPozicie.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Metoda tableView - willDisplay - Lokalizator bola vykonana")

        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.8) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Metoda tableView - didSelectRowAt - Lokalizator bola vykonana")

        let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
        let podrobnostiUdalosti = udalosti.instantiateViewController(withIdentifier: "Podrobnosti") as! Podrobnosti
        podrobnostiUdalosti.udalost = self.udalostiPodlaPozicie[indexPath.row]
        self.navigationController?.pushViewController(podrobnostiUdalosti, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Metoda tableView - cellForRowAt - Lokalizator bola vykonana")

        let riadokUdalosti = tableView.dequeueReusableCell(withIdentifier: "udalostiPodlaPozicie", for: indexPath) as! UdalostiTableViewCell
        
        let udalost: Udalost
        udalost = self.udalostiPodlaPozicie[indexPath.row]

        riadokUdalosti.datum?.text = udalost.den
        riadokUdalosti.mesiac?.text = udalost.mesiac
        riadokUdalosti.nazov?.text = udalost.nazov
        riadokUdalosti.mesto?.text = udalost.mesto
        riadokUdalosti.miesto?.text = udalost.ulica
        riadokUdalosti.cas?.text = udalost.cas
        
        Alamofire.request(self.delegate.udalostiAdresa+udalost.obrazok!).responseImage { response in
            debugPrint(response)
            
            if let obrazokUdalosti = response.result.value {
                riadokUdalosti.obrazok?.image = Obrazok.nastavObrazok(obrazokUdalosti, sirka: riadokUdalosti.obrazok.frame.width)
            }else {
                riadokUdalosti.obrazok?.image = UIImage(named: "chyba_obrazka")!
                riadokUdalosti.obrazok.contentMode = .scaleAspectFill;
            }
        }
        
        return riadokUdalosti
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Metoda locationManager - Lokalizator bola vykonana")
        
        if(!self.server){
            self.server = true;
            self.poziadavka = false;

            let pozicia:CLLocation = locations[0] as CLLocation
            
            self.autentifikaciaUdaje.miestoPrihlasenia(
                email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                heslo: self.pouzivatelskeUdaje.value(forKey: "heslo") as! String,
                zemepisnaSirka: pozicia.coordinate.latitude,
                zemepisnaDlzka: pozicia.coordinate.longitude,
                aktualizuj: true)
            
            self.manazerPozicie.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Metoda locationManager - Lokalizator bola vykonana")
    }
    
    func dataZoServera(odpoved: String, od: String, data: NSArray?) {
        print("Metoda dataZoServera - Lokalizator bola vykonana")

        switch od {
            case Nastavenia.UDALOSTI_PODLA_POZICIE:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    
                    self.ziadneUdalosti.isHidden = true
                    self.zoznamUdalostiPodlaPozicie.isHidden = false
                    
                    self.ziadneUdalosti.image = UIImage(named: "ziadne_udalosti")
                    
                    if(data != nil){
                        for i in 0..<data!.count{
                            self.udalostiPodlaPozicie.append(Udalost(
                                idUdalost: (data![i] as AnyObject).value(forKey: "idUdalost") as? String,
                                obrazok: (data![i] as AnyObject).value(forKey: "obrazok") as? String,
                                nazov: (data![i] as AnyObject).value(forKey: "nazov") as? String,
                                den: ((data![i] as AnyObject).value(forKey: "den") as? String)!+".",
                                mesiac: ((data![i] as AnyObject).value(forKey: "mesiac") as? String)!.castRetazca(doRetazca: 3)+".",
                                cas: (data![i] as AnyObject).value(forKey: "cas") as? String,
                                mesto: ((data![i] as AnyObject).value(forKey: "mesto") as? String)!+", ",
                                ulica: (data![i] as AnyObject).value(forKey: "ulica") as? String,
                                vstupenka: ((data![i] as AnyObject).value(forKey: "vstupenka") as? String)!,
                                zaujemcovia: ((data![i] as AnyObject).value(forKey: "zaujemcovia") as? String)!,
                                zaujem: ((data![i] as AnyObject).value(forKey: "zaujem") as? String)!
                            ))
                        }
                        self.zoznamUdalostiPodlaPozicie.reloadData()
                    }else {
                        self.ziadneUdalosti.isHidden = false
                        self.zoznamUdalostiPodlaPozicie.isHidden = true

                        self.ziadneUdalosti.image = UIImage(named: "ziadne_spojenie")
                    }
                }else if (odpoved == Nastavenia.CHYBA) {
                    self.ziadneUdalosti.isHidden = false
                    self.zoznamUdalostiPodlaPozicie.isHidden = true
                } else {
                    self.ziadneUdalosti.isHidden = false
                    self.zoznamUdalostiPodlaPozicie.isHidden = true
                }
                break;
            
            default: break
        }
        
        self.zoznamUdalostiPodlaPozicie.reloadData()
        self.aktualizator.endRefreshing()
        self.nacitavanie.isHidden = true
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - Lokalizator bola vykonana")

        switch od {
            case Nastavenia.AUTENTIFIKACIA_ODHLASENIE:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    print("Odhlasenie prebehlo uspesne")
                    self.udalostiUdaje.automatickePrihlasenieVypnute(email: self.pouzivatelskeUdaje.value(forKey: "email") as! String)
                    
                    let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
                    let autentifikaciaController = udalosti.instantiateViewController(withIdentifier: "Autentifikacia")
                    self.present(autentifikaciaController, animated: true, completion: nil)
                }
                break;
            
            case Nastavenia.UDALOSTI_AKTUALIZUJ:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    miestoPrihlasenia()
                }else{
                    self.zoznamUdalostiPodlaPozicie.isHidden = true
                    self.aktualizator.isHidden = true
                    
                    self.ziadneUdalosti.image = UIImage(named: "ziadne_spojenie")
                    self.ziadneUdalosti.isHidden = false
                }
                break;
            
            default: break
        }
    }
}
