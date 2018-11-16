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
    
    private var pouzivatelskeUdaje: NSDictionary!
    private var udalosti = [Udalost]()
    
    @IBOutlet weak var zoznamUdalosti: UITableView!
    @IBOutlet weak var titul: UINavigationItem!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    @IBOutlet weak var ziadneUdalosti: UIImageView!
    
    private var aktualizator = UIRefreshControl()
    
    @IBAction func odhlasitSa(_ sender: UIBarButtonItem) {
        print("Metoda odhlasitSa - Objavuj bola vykonana")

        self.udalostiUdaje.odhlasenie(email: self.pouzivatelskeUdaje.value(forKey: "email") as! String)
    }
    
    @objc func aktualizuj(_ sender: Any) {
        print("Metoda aktualizuj - Objavuj bola vykonana")
        
        if(Pripojenie.spojenieExistuje()){
            self.udalosti.removeAll()
            ziskajData()
        }else{
            self.zoznamUdalosti.isHidden = true
            self.aktualizator.isHidden = true
            
            self.ziadneUdalosti.image = UIImage(named: "ziadne_spojenie")
            self.ziadneUdalosti.isHidden = false
        }
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
        inicializacia()
    }
    
    private func inicializacia (){
        print("Metoda inicializacia - Objavuj bola vykonana")
        
        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self, kommunikaciaData: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
        
        ziskajData()
        nastavAktualizator()
    }
    
    private func ziskajData(){
        print("Metoda ziskajData - Objavuj bola vykonana")

        let miesto: NSDictionary = self.udalostiUdaje.miestoPrihlasenia()
        
        self.pouzivatelskeUdaje = self.uvodnaObrazovkaUdaje.prihlasPouzivatela()
        self.titul.title = miesto.value(forKey: "stat") as? String
        
        if self.udalosti.count == 0 {
            nacitajZoznamUdalosti(miesto: miesto)
        }
    }
    
    private func nastavAktualizator(){
        print("Metoda nastavAktualizator - Objavuj bola vykonana")

        self.aktualizator.backgroundColor = UIColor(red:0.00, green:0.36, blue:0.65, alpha:1.0)
        self.aktualizator.tintColor = UIColor.white
        self.aktualizator.addTarget(self, action: #selector(aktualizuj(_:)), for: .valueChanged)
        
        self.zoznamUdalosti.addSubview(self.aktualizator)
    }
    
    private func nacitajZoznamUdalosti(miesto: NSDictionary){
        print("Metoda nacitajZoznamUdalosti - Objavuj bola vykonana")
        
        self.nacitavanie.isHidden = false
        self.zoznamUdalosti.isHidden = true
        
        self.udalostiUdaje.zoznamUdalosti(
            email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
            stat: miesto.value(forKey: "stat") as! String,
            token: self.pouzivatelskeUdaje.value(forKey: "token") as! String)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Metoda tableView - numberOfRowsInSection - Objavuj bola vykonana")
        
        return self.udalosti.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Metoda tableView - willDisplay - Objavuj bola vykonana")
        
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.8) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Metoda tableView - didSelectRowAt - Objavuj bola vykonana")
        
        let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
        let podrobnostiUdalosti = udalosti.instantiateViewController(withIdentifier: "Podrobnosti") as! Podrobnosti
        podrobnostiUdalosti.udalost = self.udalosti[indexPath.row]
        self.navigationController?.pushViewController(podrobnostiUdalosti, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Metoda tableView - cellForRowAt - Objavuj bola vykonana")
        
        let riadokUdalosti = tableView.dequeueReusableCell(withIdentifier: "udalosti", for: indexPath) as! UdalostiTableViewCell
        
        let udalost: Udalost
        udalost = self.udalosti[indexPath.row]
        
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
                riadokUdalosti.nacitavanie.isHidden = true
            }else {
                riadokUdalosti.obrazok?.image = UIImage(named: "chyba_obrazka")!
                riadokUdalosti.obrazok.contentMode = .scaleAspectFill;
                riadokUdalosti.nacitavanie.isHidden = true
            }
        }

        return riadokUdalosti
    }
    
    func dataZoServera(odpoved: String, od: String, data: NSArray?) {
        print("Metoda dataZoServera - Objavuj bola vykonana")
        
        switch od {
            case Nastavenia.UDALOSTI_OBJAVUJ:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    
                    self.ziadneUdalosti.isHidden = true
                    self.zoznamUdalosti.isHidden = false
                    
                    self.ziadneUdalosti.image = UIImage(named: "ziadne_udalosti")
                    
                    if(data != nil){
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
                    }else{
                        self.ziadneUdalosti.isHidden = false
                        self.zoznamUdalosti.isHidden = true
                        
                        self.ziadneUdalosti.image = UIImage(named: "ziadne_spojenie")
                    }
                } else if(odpoved == Nastavenia.CHYBA){
                    self.ziadneUdalosti.isHidden = false
                    self.zoznamUdalosti.isHidden = true
                } else {
                    self.ziadneUdalosti.isHidden = false
                    self.zoznamUdalosti.isHidden = true
                }
                break;
            
            default: break
        }
        
        self.zoznamUdalosti.reloadData()
        self.aktualizator.endRefreshing()
        self.nacitavanie.isHidden = true
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - Objavuj bola vykonana")

        switch od {
            case Nastavenia.AUTENTIFIKACIA_ODHLASENIE:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    print("Odhlasenie prebehlo uspesne")
                    udalostiUdaje.automatickePrihlasenieVypnute(email: self.pouzivatelskeUdaje.value(forKey: "email") as! String)
                    
                    let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
                    let autentifikaciaController = udalosti.instantiateViewController(withIdentifier: "Autentifikacia")
                    self.present(autentifikaciaController, animated: true, completion: nil)
                }
                break;
            
            default: break
        }
    }
}
