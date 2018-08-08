//
//  RychlaUkazkaAplikacie.swift
//  Udalosti
//
//  Created by Bence Mate on 8/7/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
import paper_onboarding

class RychlaUkazkaAplikacie: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    @IBOutlet weak var pokracovat: UIButton!
    @IBOutlet var ukazkaAplikacie: OnboardingView!
    
    @IBAction func prvyStart(_ sender: Any) {
        print("Metoda prvyStart bola vykonana")
        
        let preferencie = UserDefaults.standard
        preferencie.set(true, forKey: "prvyStart")
        preferencie.synchronize()
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let pozadiePrva = UIColor(red: 8/255, green: 78/255, blue: 123/255, alpha: 1)
        let pozadieDruha = UIColor(red: 1/255, green: 96/255, blue: 151/255, alpha: 1)
        let pozadieTretia = UIColor(red: 17/255, green: 117/255, blue: 180/255, alpha: 1)

        let titul = UIFont(name: "Raleway-Bold", size: 24)!
        let popis = UIFont(name: "Raleway-Regular", size: 18)!
        
        return [
            OnboardingItemInfo(informationImage: UIImage(named: "udalosti_registracia_prihlasovanie")!,
                               title: "Registrácia a Prihlásenie",
                               description: "Registrujte sa, a majte prehľad nad všetkými udalosťami",
                               pageIcon: UIImage(named: "udalosi_cast")!,
                               color: pozadiePrva,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titul,
                               descriptionFont: popis),
            OnboardingItemInfo(informationImage: UIImage(named: "udalosti_objavuj")!,
                               title: "Objavujte",
                               description: "Vyhldávajte z udalostí a nájdite tie ktoré Vás zaujímajú",
                               pageIcon: UIImage(named: "udalosi_cast")!,
                               color: pozadieDruha,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titul,
                               descriptionFont: popis),
            OnboardingItemInfo(informationImage: UIImage(named: "udalosti_podla_pozicie")!,
                               title: "Podľa pozície",
                               description: "Hladajte udalosti ktoré sú najbližšie k Vám podla Vašej pozície",
                               pageIcon: UIImage(named: "udalosi_cast")!,
                               color: pozadieTretia,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titul,
                               descriptionFont: popis)
            ][index]
    }
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            
            if self.pokracovat.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations:{
                    self.pokracovat.alpha = 0
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0.4, animations:{
                self.pokracovat.alpha = 1
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ukazkaAplikacie.dataSource = self
        self.ukazkaAplikacie.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
