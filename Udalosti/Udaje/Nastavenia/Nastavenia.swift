//
//  Nastavenia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/6/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

class Nastavenia {
    public static let START = "prvyStart";
    
    public static let USPECH = "uspech";
    public static let CHYBA = "CHYBA"
    public static let MOZNA_CHYBA = "neUspesnePrihlasenie";
    public static let VSETKO_V_PORIADKU = "OK"

    public static let AUTENTIFIKACIA_PRIHLASENIE = "prihlasenie"
    public static let AUTENTIFIKACIA_ODHLASENIE = "odhlasenie"
    public static let AUTENTIFIKACIA_REGISRACIA = "registracia"

    public static let UDALOSTI_OBJAVUJ = "objavuj";
    public static let UDALOSTI_PODLA_POZICIE = "podla_pozicie"
    public static let UDALOSTI_AKTUALIZUJ = "aktualizuj";
    
    public static var TOKEN: Bool = false
    public static let POZICIA_TOKEN = "097c58e2ea9355";
    public static let POZICIA_FORMAT = "json";
    public static let POZICIA_JAZYK = "sk";
    
    public static let ZAUJEM = "zaujem";
    public static let ZAUJEM_POTVRD = "zaujem_potvrd";
    public static let ZAUJEM_ODSTRANENIE = "zaujem_odstranenie";
    public static let ZAUJEM_ZOZNAM = "zaujem_zoznam";
    
    public static let DLZKA_REQUESTU = 20;
    public static let SERVER_GEO_IP = "json";
    public static let SERVER_PRIHLASENIE = "index.php/prihlasenie/prihlasit";
    public static let SERVER_ODHLASENIE = "index.php/prihlasenie/odhlasit";
    public static let SERVER_REGISTRACIA = "index.php/registracia";
    public static let SERVER_ZOZNAM_UDALOSTI = "index.php/udalosti";
    public static let SERVER_ZOZNAM_UDALOSTI_PODLA_POZCIE = "index.php/udalosti/zoznam_podla_pozicie";
    public static let SERVER_ZOZNAM_ZAUJMOV = "index.php/zaujmy/zoznam";
    public static let SERVER_ZAUJEM = "index.php/zaujmy";
    public static let SERVER_POTVRD_ZAUJEM = "index.php/zaujmy/potvrd";
    public static let SERVER_ODSTRAN_ZAUJEM = "index.php/zaujmy/odstran";
}
