//
//  Objavuj.swift
//  Udalosti
//
//  Created by Bence Mate on 8/9/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Objavuj: UIViewController, UITableViewDataSource, UITableViewDelegate, KommunikaciaOdpoved, KommunikaciaData{
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    
    private var udalostiUdaje : UdalostiUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    
    var pouzivatelskeUdaje: NSDictionary!
    var udalosti = [Udalost]()
    
    @IBOutlet weak var titul: UINavigationItem!
    @IBOutlet weak var zoznamUdalosti: UITableView!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    @IBOutlet weak var ziadneUdalosti: UIImageView!
    
    @IBAction func odhlasitSa(_ sender: UIBarButtonItem) {
        print("Metoda odhlasitSa - Objavuj bola vykonana")

        udalostiUdaje.odhlasenie(email: pouzivatelskeUdaje.value(forKey: "email") as! String)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("Metoda preferredStatusBarStyle - Objavuj bola vykonana")

        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        print("Metoda didReceiveMemoryWarning - Objavuj bola vykonana")

        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        print("Metoda viewDidLoad - Objavuj bola vykonana")

        super.viewDidLoad()
        self.inicializacia()
    }
    
    func inicializacia (){
        print("Metoda inicializacia - Objavuj bola vykonana")
        
        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self, kommunikaciaData: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
        self.pouzivatelskeUdaje = uvodnaObrazovkaUdaje.prihlasPouzivatela()
        self.ziskajData()
    }
    
    func ziskajData(){
        print("Metoda ziskajData bola vykonana")

        let miesto: NSDictionary = udalostiUdaje.miestoPrihlasenia()
        self.titul.title = miesto.value(forKey: "stat") as? String
        
        if self.udalosti.count == 0 {
            self.nacitajZoznamUdalosti(miesto: miesto)
        }
    }
    
    func nacitajZoznamUdalosti(miesto: NSDictionary){
        print("Metoda nacitajZoznamUdalosti bola vykonana")
        
        self.nacitavanie.isHidden = false
        self.udalostiUdaje.zoznamUdalosti(
            email: pouzivatelskeUdaje.value(forKey: "email") as! String,
            stat: miesto.value(forKey: "stat") as! String,
            token: pouzivatelskeUdaje.value(forKey: "token") as! String)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Metoda tableView - Objavuj bola vykonana")
        
        let riadokUdalosti = tableView.dequeueReusableCell(withIdentifier: "udalosti", for: indexPath) as! UdalostiTableViewCell
        
        let udalost: Udalost
        udalost = udalosti[indexPath.row]
        
        riadokUdalosti.datum?.text = udalost.den
        riadokUdalosti.mesiac?.text = udalost.mesiac
        riadokUdalosti.nazov?.text = udalost.nazov
        riadokUdalosti.mesto?.text = udalost.mesto
        riadokUdalosti.miesto?.text = udalost.ulica
        riadokUdalosti.cas?.text = udalost.cas
        
        Alamofire.request(delegate.udalostiAdresa+udalost.obrazok!).responseImage { response in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Metoda tableView - Objavuj bola vykonana")

        return udalosti.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Metoda tableView - Objavuj bola vykonana")

        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.8) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func dataZoServera(odpoved: String, od: String, data: NSArray?) {
        print("Metoda dataZoServera - Objavuj bola vykonana")

        switch od {
        case Nastavenia.UDALOSTI_OBJAVUJ:
            if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                ziadneUdalosti.isHidden = true
                for i in 0..<data!.count{
                    self.udalosti.append(Udalost(
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
                self.zoznamUdalosti.reloadData()
            } else if(odpoved == Nastavenia.CHYBA){
                ziadneUdalosti.isHidden = false
            }
            break;
        default: break
        }
        self.zoznamUdalosti.reloadData()
        self.nacitavanie.isHidden = true
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - Objavuj bola vykonana")

        switch od {
        case Nastavenia.AUTENTIFIKACIA_ODHLASENIE:
            if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                print("Odhlasenie prebehlo uspesne")
                udalostiUdaje.automatickePrihlasenieVypnute(email: pouzivatelskeUdaje.value(forKey: "email") as! String)
                
                let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
                let autentifikaciaController = udalosti.instantiateViewController(withIdentifier: "Autentifikacia")
                self.present(autentifikaciaController, animated: true, completion: nil)
            }
            break;
        default: break
        }
    }
}