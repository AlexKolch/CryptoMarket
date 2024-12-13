//
//  MarketDataModel.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 13.12.2024.
//

import Foundation

//JSON data:
/*
 URL: https://api.coingecko.com/api/v3/global
 
 JSON response:
 {
   "date": {
     "active_cryptocurrencies": 13690,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 1046,
     "total_market_cap": {
       "btc": 39003738.0847159,
       "eth": 803832137.207531,
       "ltc": 26721173267.5358,
       "bch": 3981159931.51342,
       "bnb": 4670513150.58714,
       "eos": 2641998753398.41,
       "xrp": 4567762968374.06,
       "xlm": 21049307801356.5,
       "link": 153517938957.199,
       "dot": 315120726481.166,
       "yfi": 324671967.610845,
       "usd": 2721226850772.63,
       "aed": 9993705609462.48,
       "ars": 2341775032921960,
       "aud": 4135040261091.56,
       "bdt": 298245137607204,
       "bhd": 1024582727718.66,
       "bmd": 2721226850772.63,
       "brl": 13785980136430.7,
       "cad": 3698283351542.55,
       "chf": 2454228235855.38,
       "clp": 2557393918759370,
       "cny": 19681001075528,
       "czk": 63568675602103.7,
       "dkk": 18728571677757.6,
       "eur": 2508293570926.52,
       "gbp": 2153208842849.76,
       "gel": 7292887960070.66,
       "hkd": 21307070180207.2,
       "huf": 979811947048335,
       "idr": 43234171898362830,
       "ils": 10201683535213.3,
       "inr": 226670207147326,
       "jpy": 412551596711386,
       "krw": 3677112086909555,
       "kwd": 836219405108.176,
       "lkr": 812593109477406,
       "mmk": 5706555839881336,
       "mxn": 44773978111872.4,
       "myr": 12919024474043.1,
       "ngn": 3522998071018357,
       "nok": 29197131372679.9,
       "nzd": 4524820631515.69,
       "php": 153994230206450,
       "pkr": 755251422720381,
       "pln": 10747177948492.4,
       "rub": 251732363568359,
       "sar": 10207395390373.1,
       "sek": 29054498267296.6,
       "sgd": 3672056167154.8,
       "thb": 99649147572586.4,
       "try": 87273829665781.3,
       "twd": 87422678053291.6,
       "uah": 105534042826572,
       "vef": 272476444567.864,
       "vnd": 67937284004880150,
       "zar": 50878778428896,
       "xdr": 2052425485204.54,
       "xag": 99002369095.9216,
       "xau": 1167950564.35161,
       "bits": 39003738084715.9,
       "sats": 3900373808471590
     },
     "total_volume": {
       "btc": 993675.225562481,
       "eth": 20478757.1519219,
       "ltc": 680759567.614816,
       "bch": 101425662.954523,
       "bnb": 118987908.244129,
       "eos": 67308643636.0751,
       "xrp": 116370202467.687,
       "xlm": 536260797157.883,
       "link": 3911085965.39774,
       "dot": 8028144848.20593,
       "yfi": 8271476.18386717,
       "usd": 69327091133.5489,
       "aed": 254603742187.958,
       "ars": 59660021021604.7,
       "aud": 105345981331.984,
       "bdt": 7598215425943.58,
       "bhd": 26102689718.1482,
       "bmd": 69327091133.5489,
       "brl": 351217283120.761,
       "cad": 94218983205.0497,
       "chf": 62524924932.7986,
       "clp": 65153216175224.4,
       "cny": 501401253914.28,
       "czk": 1619501647007.04,
       "dkk": 477136772017.537,
       "eur": 63902315579.4398,
       "gbp": 54856031438.6965,
       "gel": 185796604237.911,
       "hkd": 542827657221.132,
       "huf": 24962090950805.3,
       "idr": 1101451492157040,
       "ils": 259902273109.113,
       "inr": 5774743147085.06,
       "jpy": 10510333651301.7,
       "krw": 93679615385638.7,
       "kwd": 21303868469.8839,
       "lkr": 20701955274048.2,
       "mmk": 145382556642719,
       "mxn": 1140680226674.96,
       "myr": 329130365156.523,
       "ngn": 89753343519839.4,
       "nok": 743838091608.3,
       "nzd": 115276185884.681,
       "php": 3923220156574.62,
       "pkr": 19241094948336.3,
       "pln": 273799512470.654,
       "rub": 6413236921211.56,
       "sar": 260047790673.403,
       "sek": 740204312126.535,
       "sgd": 93550808700.7045,
       "thb": 2538702546310.57,
       "try": 2223423872616.7,
       "twd": 2227215995174.62,
       "uah": 2688628550997.98,
       "vef": 6941721635.20225,
       "vnd": 1730798106095000,
       "zar": 1296208622923.97,
       "xdr": 52288433291.4744,
       "xag": 2522224952.61704,
       "xau": 29755187.5145192,
       "bits": 993675225562.481,
       "sats": 99367522556248.1
     },
     "market_cap_percentage": {
       "btc": 50.4465263233584,
       "eth": 14.9228066918211,
       "usdt": 3.92900641199819,
       "bnb": 3.29395203563452,
       "sol": 2.95074801328159,
       "usdc": 1.20922049263535,
       "xrp": 1.20523481041161,
       "steth": 1.18309266793764,
       "doge": 1.05778560354543,
       "ada": 0.765987294694099
     },
     "market_cap_change_percentage_24h_usd": 1.72179506060272,
     "updated_at": 1712512855
   }
 }
 */

struct GlobalData: Decodable {
    let date: MarketDataModel
}

// MARK: - DateClass
struct MarketDataModel: Decodable {
    
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
       
    }
    
    //Достаем из словаря значение usd
    var marketCapUSD: String {
        let value: String
        if let item = totalMarketCap.first(where: { key, value in
            key == "usd"
        }) {
            value = String(describing: item.value)
        } else {
            value = ""
        }
        return value
    }
    
    var volume: String {
        let value: String
        ///способ короче
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            value = String(describing: item.value)
        } else {
            value = ""
        }
        return value
    }
    
    var btcMarketCap: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc"}) {
            return item.value.asPercentString()
        }
        return ""
    }
}
