//
//  Lokalizator.swift
//  Udalosti
//
//  Created by Bence Mate on 8/9/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Lokalizator: UIViewController, UITableViewDataSource, UITableViewDelegate, KommunikaciaOdpoved, KommunikaciaData{
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    
    private var udalostiUdaje : UdalostiUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    
    private var pouzivatelskeUdaje: NSDictionary!
    private var udalostiPodlaPozicie = [Udalost]()
    
    @IBOutlet weak var zoznamUdalostiPodlaPozicie: UITableView!
    @IBOutlet weak var titul: UINavigationItem!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    @IBOutlet weak var ziadneUdalosti: UIImageView!
    
    @IBAction func odhlasitSa(_ sender: UIBarButtonItem) {
        print("Metoda odhlasitSa - UdalostiPodlaPozacie bola vykonana")

        self.udalostiUdaje.odhlasenie(email: self.pouzivatelskeUdaje.value(forKey: "email") as! String)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("Metoda preferredStatusBarStyle - UdalostiPodlaPozacie bola vykonana")

        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        print("Metoda didReceiveMemoryWarning - UdalostiPodlaPozacie bola vykonana")

        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        print("Metoda viewDidLoad - UdalostiPodlaPozacie bola vykonana")

        super.viewDidLoad()        
        inicializacia()
    }
    
    func inicializacia (){
        print("Metoda inicializacia - UdalostiPodlaPozacie bola vykonana")
        
        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self, kommunikaciaData: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
        self.pouzivatelskeUdaje = self.uvodnaObrazovkaUdaje.prihlasPouzivatela()
        self.miestoPrihlasenia()
    }
    
    func miestoPrihlasenia(){
        print("Metoda miestoPrihlasenia bola vykonana")
        
        let miesto: NSDictionary = self.udalostiUdaje.miestoPrihlasenia()
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
            self.nacitajZoznamUdalostiPodlaPozicie(miesto: miesto)
        }
    }
    
    func nacitajZoznamUdalostiPodlaPozicie(miesto: NSDictionary){
        print("Metoda nacitajZoznamUdalostiPodlaPozicie bola vykonana")
        
        self.nacitavanie.isHidden = false
        self.udalostiUdaje.zoznamUdalostiPodlaPozicie(
            email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
            stat: miesto.value(forKey: "stat") as! String,
            okres: miesto.value(forKey: "okres") as! String,
            mesto: miesto.value(forKey: "pozicia") as! String,
            token: self.pouzivatelskeUdaje.value(forKey: "token") as! String)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Metoda tableView - numberOfRowsInSection - UdalostiPodlaPozacie bola vykonana")

        return self.udalostiPodlaPozicie.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Metoda tableView - willDisplay - UdalostiPodlaPozacie bola vykonana")

        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.8) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Metoda tableView - cellForRowAt - UdalostiPodlaPozacie bola vykonana")

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
    
    func dataZoServera(odpoved: String, od: String, data: NSArray?) {
        print("Metoda dataZoServera - UdalostiPodlaPozacie bola vykonana")

        switch od {
        case Nastavenia.UDALOSTI_PODLA_POZICIE:
            if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                ziadneUdalosti.isHidden = true
                ziadneUdalosti.image = UIImage(named: "ziadne_udalosti")
                
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
                    ziadneUdalosti.isHidden = false
                    ziadneUdalosti.image = UIImage(named: "ziadne_spojenie")
                }
            }else if (odpoved == Nastavenia.CHYBA) {
                ziadneUdalosti.isHidden = false
            }
            break;
        default: break
        }
        self.zoznamUdalostiPodlaPozicie.reloadData()
        self.nacitavanie.isHidden = true
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - UdalostiPodlaPozacie bola vykonana")

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
        default: break
        }
    }
}
