//
//  Veespo.h
//  VeespoLib
//
//  Created by Giordano Scalzo on 3/15/12.
//  Copyright (c) 2012 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Veespo : NSObject

/*
 * userId - identificativo univoco dell'utente
 * apiKey - apikey di Veespo
 * name - nome dell'utente (opzionale)
 * lang - lingua di sistema
 * groupId - identificativo univoco fornito da Veespo
 * filename - nome del file yaml o json presente nel main bundle del progetto XCode (opzionale). 
 *            I file devono avere l'estensione .yaml o .json
 * URL - url dove scaricare il file di configurazione yaml. Nel url deve essere presente l'indirizzo completo, anche il nome del file (opzionale)
 * flag - YES se si utilizzano i server di Test di Veespo
 *
 */
+ (void)initUser:(NSString *)userId apiKey:(NSString *)apiKey userName:(NSString *)name language:(NSString *)lang veespoGroup:(NSString *)groupId fileConfig:(NSString *)filename urlConfig:(NSString *)URL andTestUrl:(BOOL)flag;

+ (void)initUser:(NSString *)userId apiKey:(NSString *)apiKey userName:(NSString *)name language:(NSString *)lang veespoGroup:(NSString *)groupId fileConfig:(NSString *)filename urlConfig:(NSString *)URL test:(BOOL)test sandBox:(BOOL)sandBox;

@end
