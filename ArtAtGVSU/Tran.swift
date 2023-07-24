//
//  Translator.swift
//  ArtAtGVSU
//
//  Created by lauren defrancesco on 4/3/20.
//  Copyright © 2020 Kirthi Samson. All rights reserved.
//

import Foundation
import Firebase

//This is the class for where the translators are created so that it only has to be called from one file. 
struct Tran{
    
    func createTranslator() -> Translator {
        let phoneLang = NSLocale.preferredLanguages[0]

        let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .es)
        var t = NaturalLanguage.naturalLanguage().translator(options: options)

        //spanish translator
        if(phoneLang == "es-US"){
            let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .es)
            t = NaturalLanguage.naturalLanguage().translator(options: options)
        }
        //french translator
        if(phoneLang == "fr-US"){
            let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .fr)
            t = NaturalLanguage.naturalLanguage().translator(options: options)
        }
        
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        t.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            // Model downloaded successfully. Okay to start translating.
        }
        
        return t
    }
    
}



