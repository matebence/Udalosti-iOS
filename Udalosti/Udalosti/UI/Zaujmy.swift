//
//  Zaujmy.swift
//  Udalosti
//
//  Created by Bence Mate on 11/14/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class Zaujmy: UIViewController, UITableViewDataSource, UITableViewDelegate, Aktualizator, KommunikaciaOdpoved, KommunikaciaData {
    
    private var udalostiUdaje : UdalostiUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    
    private var pouzivatelskeUdaje: NSDictionary!
    private var zaujmy = [Udalost]()
    
    @IBOutlet weak var zoznamZaujmov: UITableView!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    @IBOutlet weak var ziadneZaujmy: UIImageView!
    
    @IBAction func odhlasitSa(_ sender: Any) {
        print("Metoda odhlasitSa - Zaujmy bola vykonana")
        
        self.udalostiUdaje.odhlasenie(email: self.pouzivatelskeUdaje.value(forKey: "email") as! String)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("Metoda preferredStatusBarStyle - Zaujmy bola vykonana")
        
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        print("Metoda didReceiveMemoryWarning - Zaujmy bola vykonana")
        
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        print("Metoda viewDidLoad - Zaujmy bola vykonana")

        super.viewDidLoad()
        inicializacia()
    }
    
    private func inicializacia (){
        print("Metoda inicializacia - Zaujmy bola vykonana")
        
        AktualizatorObsahu.zaujmy().nastav(aktualizator: self)
        
        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self, kommunikaciaData: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
        
        ziskajData()
    }
    
    private func ziskajData(){
        print("Metoda ziskajData - Zaujmy bola vykonana")
        
        let miesto: NSDictionary = self.udalostiUdaje.miestoPrihlasenia()
        self.pouzivatelskeUdaje = self.uvodnaObrazovkaUdaje.prihlasPouzivatela()
        
        if self.zaujmy.count == 0 {
            nacitajZoznamZaujmov(miesto: miesto)
        }
    }
    
    private func nacitajZoznamZaujmov(miesto: NSDictionary){
        print("Metoda nacitajZoznamUdalosti - Zaujmy bola vykonana")
        
        self.nacitavanie.isHidden = false
        self.zoznamZaujmov.isHidden = true
        
        self.udalostiUdaje.zoznamZaujmov(
            email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
            token: self.pouzivatelskeUdaje.value(forKey: "token") as! String)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Metoda tableView - numberOfRowsInSection- Zaujmy bola vykonana")
        
        return self.zaujmy.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Metoda tableView - willDisplay- Zaujmy bola vykonana")

        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.8) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Metoda tableView - didSelectRowAt- Zaujmy bola vykonana")

        let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
        let podrobnostiUdalosti = udalosti.instantiateViewController(withIdentifier: "Podrobnosti") as! Podrobnosti
        podrobnostiUdalosti.udalost = self.zaujmy[indexPath.row]
        self.navigationController?.pushViewController(podrobnostiUdalosti, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Metoda tableView - editingStyle- Zaujmy bola vykonana")

        if editingStyle == .delete {
            let potvrdenie = UIAlertController(title: "Odstránenie", message: "Naozaj chcete odstrániť záujem \(zaujmy[indexPath.row].nazov ?? "")?", preferredStyle: UIAlertController.Style.alert)
            
            potvrdenie.addAction(UIAlertAction(title: "Áno, odstrániť", style: .default, handler: { (action: UIAlertAction!) in
                self.udalostiUdaje.odstranZaujem(
                    email: self.pouzivatelskeUdaje.value(forKey: "email") as! String,
                    token: self.pouzivatelskeUdaje.value(forKey: "token") as! String,
                    idUdalost: Int(self.zaujmy[indexPath.row].idUdalost!)!)
                
                self.zaujmy.remove(at: indexPath.row)
                self.zoznamZaujmov.deleteRows(at: [indexPath], with: .fade)
            }))
            
            potvrdenie.addAction(UIAlertAction(title: "Zavoriť", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(potvrdenie, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        print("Metoda tableView - titleForDeleteConfirmationButtonForRowAtIndexPath - Zaujmy bola vykonana")
        
        return "Odstrániť"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Metoda tableView - cellForRowAt - Zaujmy bola vykonana")
        
        let riadokUdalosti = tableView.dequeueReusableCell(withIdentifier: "zaujmy", for: indexPath) as! ZaujmyTableViewCell
        
        let udalost: Udalost
        udalost = self.zaujmy[indexPath.row]
        
        riadokUdalosti.den?.text = udalost.den
        riadokUdalosti.mesiac?.text = udalost.mesiac
        riadokUdalosti.nazov?.text = udalost.nazov
        riadokUdalosti.mesto?.text = udalost.mesto
        riadokUdalosti.ulica?.text = udalost.ulica
        
        return riadokUdalosti
    }
    
    func dataZoServera(odpoved: String, od: String, data: NSArray?) {
        print("Metoda dataZoServera - Zaujmy bola vykonana")
        
        switch od {
            case Nastavenia.ZAUJEM_ZOZNAM:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    
                    self.ziadneZaujmy.isHidden = true
                    self.zoznamZaujmov.isHidden = false
                    
                    self.ziadneZaujmy.image = UIImage(named: "ziadne_zaujmy")
                    
                    if(data != nil){
                        for i in 0..<data!.count{
                            self.zaujmy.append(Udalost(
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
                        self.zoznamZaujmov.reloadData()
                    }else{
                        self.ziadneZaujmy.isHidden = false
                        self.zoznamZaujmov.isHidden = true
                        
                        self.ziadneZaujmy.image = UIImage(named: "ziadne_spojenie")
                    }
                } else if(odpoved == Nastavenia.CHYBA){
                    self.ziadneZaujmy.isHidden = false
                    self.zoznamZaujmov.isHidden = true
                } else {
                    self.ziadneZaujmy.isHidden = false
                    self.zoznamZaujmov.isHidden = true
                }
                break;
            
            default: break
        }
        
        self.zoznamZaujmov.reloadData()
        self.nacitavanie.isHidden = true
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - Zaujmy bola vykonana")
        
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
            
            case Nastavenia.ZAUJEM_ODSTRANENIE:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    
                    if(udaje?.value(forKey: "uspech") != nil){
                        if(zaujmy.count == 0){
                            zoznamZaujmov.isHidden = true
                            ziadneZaujmy.isHidden = false
                        }
                    } else if(udaje?.value(forKey: "chyba") != nil){
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
    
    func aktualizujObsahZaujmov() {
        print("Metoda aktualizujObsahZaujmov - Zaujmy bola vykonana")
        
        zaujmy.removeAll()
        ziskajData()
    }
}
