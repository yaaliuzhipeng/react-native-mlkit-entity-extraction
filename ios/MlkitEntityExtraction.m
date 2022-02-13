// MlkitEntityExtraction.m

#import "MlkitEntityExtraction.h"

/**
 TYPE_ADDRESS: 1,
 TYPE_DATE_TIME: 2,
 TYPE_EMAIL: 3,
 TYPE_FLIGHT_NUMBER: 4,
 TYPE_IBAN: 5,
 TYPE_ISBN: 6,
 TYPE_PAYMENT_CARD: 7,
 TYPE_PHONE: 8,
 TYPE_TRACKING_NUMBER: 9,
 TYPE_URL: 10,
 TYPE_MONEY: 11,
 */

@implementation MlkitEntityExtraction

- (int) mapEntityType:(NSString* ) type
{
    if([type isEqualToString: MLKEntityExtractionEntityTypeAddress]) {
        return 1;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypeDateTime]){
        return 2;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypeEmail]){
        return 3;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypeFlightNumber]){
        return 4;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypeIBAN]){
        return 5;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypeISBN]){
        return 6;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypePaymentCard]){
        return 7;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypePhone]){
        return 8;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypeTrackingNumber]){
        return 9;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypeURL]){
        return 10;
    }else if([type isEqualToString: MLKEntityExtractionEntityTypeMoney]){
        return 11;
    }
    return -1;
}
- (NSString *) mapEntityTypeRev:(int ) type
{
    if(type == 1) {
        return MLKEntityExtractionEntityTypeAddress;
    }else if(type == 2) {
        return MLKEntityExtractionEntityTypeDateTime;
    }else if(type == 3) {
        return MLKEntityExtractionEntityTypeEmail;
    }else if(type == 4) {
        return MLKEntityExtractionEntityTypeFlightNumber;
    }else if(type == 5) {
        return MLKEntityExtractionEntityTypeIBAN;
    }else if(type == 6) {
        return MLKEntityExtractionEntityTypeISBN;
    }else if(type == 7) {
        return MLKEntityExtractionEntityTypePaymentCard;
    }else if(type == 8) {
        return MLKEntityExtractionEntityTypePhone;
    }else if(type == 9) {
        return MLKEntityExtractionEntityTypeDateTime;
    }else if(type == 10) {
        return MLKEntityExtractionEntityTypeURL;
    }else if(type == 11) {
        return MLKEntityExtractionEntityTypeMoney;
    }
    return @"";
}

RCT_EXPORT_MODULE(MLKitEntityExtraction)

RCT_EXPORT_METHOD(annotate: (NSString *)text
                  lang:(NSString *)lang
                  types:(NSArray *)types
                  successCallback:(RCTResponseSenderBlock) successCallback
                  failCallback:(RCTResponseSenderBlock) failCallback)
{
    MLKEntityExtractorOptions *options =[[MLKEntityExtractorOptions alloc] initWithModelIdentifier:MLKEntityExtractionModelIdentifierForLanguageTag(lang)];
    if(_entityExtractor == nil) {
        _entityExtractor = [MLKEntityExtractor entityExtractorWithOptions:options];
    }
    
    MLKEntityExtractionParams *params = [[MLKEntityExtractionParams alloc] init];
    NSMutableSet *tps = [NSMutableSet new];
    for (NSNumber* tp in types) {
        NSString *tpstr = [self mapEntityTypeRev: [tp intValue]];
        if([tpstr isEqualToString:@""]) {
            continue;
        }
        [tps addObject:tpstr];
    }
    params.typesFilter = tps;
    id this = self;
    [_entityExtractor annotateText: text
                       withParams:params
                       completion:^(NSArray *_Nullable entityAnnotations, NSError *_Nullable error) {
        if(error != nil) {
            failCallback(@[error.localizedDescription]);
            return;
        }
        NSMutableArray* annots = [[NSMutableArray alloc] init];
        for (MLKEntityAnnotation *entityAnnotation in entityAnnotations) {
            NSArray *entities = entityAnnotation.entities;
            
            NSMutableDictionary *annomap = [[NSMutableDictionary alloc] init];
            [annomap setObject: [text substringWithRange: entityAnnotation.range] forKey:@"annotation"];
            
            NSMutableArray *annoarr = [[NSMutableArray alloc] init];
            for (MLKEntity *entity in entities) {
                [annomap setObject: [[NSNumber alloc] initWithInt: [this mapEntityType:entity.entityType]] forKey:@"type"];
                if([entity.entityType isEqualToString:MLKEntityExtractionEntityTypeAddress]){
                    continue;
                } else if ([entity.entityType isEqualToString:MLKEntityExtractionEntityTypeDateTime]) {
                    MLKDateTimeEntity *dateTimeEntity = entity.dateTimeEntity;
                    NSMutableDictionary* dateTimeMap = [[NSMutableDictionary alloc] init];
                    [dateTimeMap setObject:[[NSNumber alloc] initWithInt:(int)dateTimeEntity.dateTimeGranularity] forKey: @"granularity"];
                    [dateTimeMap setObject: [[NSNumber alloc] initWithDouble:dateTimeEntity.dateTime.timeIntervalSince1970] forKey: @"timestamp"];
                    [annoarr addObject:dateTimeMap];
                    continue;;
                }else if([entity.entityType isEqualToString:MLKEntityExtractionEntityTypeEmail]){
                    continue;
                } else if ([entity.entityType isEqualToString:MLKEntityExtractionEntityTypeFlightNumber]) {
                    MLKFlightNumberEntity *flightNumberEntity = entity.flightNumberEntity;
                    NSMutableDictionary* flightNumberMap = [[NSMutableDictionary alloc] init];
                    [flightNumberMap setObject:flightNumberEntity.airlineCode forKey:@"ariline_code"];
                    [flightNumberMap setObject:flightNumberEntity.flightNumber forKey:@"flight_number"];
                    [annoarr addObject:flightNumberMap];
                    continue;
                }else if([entity.entityType isEqualToString:MLKEntityExtractionEntityTypeIBAN]){
                    MLKIBANEntity *ibanEntity = entity.IBANEntity;
                    NSMutableDictionary* ibanMap = [[NSMutableDictionary alloc] init];
                    [ibanMap setObject:ibanEntity.IBAN forKey:@"iban"];
                    [ibanMap setObject:ibanEntity.countryCode forKey:@"country_code"];
                    [annoarr addObject:ibanMap];
                    continue;
                }else if([entity.entityType isEqualToString:MLKEntityExtractionEntityTypeISBN]){
                    MLKISBNEntity *isbnEntity = entity.ISBNEntity;
                    NSMutableDictionary* isbnMap = [[NSMutableDictionary alloc] init];
                    [isbnMap setObject:isbnEntity.ISBN forKey:@"isbn"];
                    [isbnMap setObject:@"" forKey:@"country_code"];
                    [annoarr addObject:isbnMap];
                    continue;
                }else if([entity.entityType isEqualToString:MLKEntityExtractionEntityTypePaymentCard]){
                    MLKPaymentCardEntity* paymentCardEntity = entity.paymentCardEntity;
                    NSMutableDictionary* paymentCardMap = [[NSMutableDictionary alloc] init];
                    [paymentCardMap setObject: paymentCardEntity.paymentCardNumber forKey:@"card_number"];
                    [paymentCardMap setObject: [[NSNumber alloc] initWithInteger:paymentCardEntity.paymentCardNetwork] forKey:@"card_network"];
                    [annoarr addObject:paymentCardMap];
                    continue;
                } else if ([entity.entityType isEqualToString:MLKEntityExtractionEntityTypePhone]) {
                    continue;
                } else if ([entity.entityType isEqualToString:MLKEntityExtractionEntityTypeTrackingNumber]) {
                    MLKTrackingNumberEntity *trackingNumberEntity = entity.trackingNumberEntity;
                    NSMutableDictionary* trackingNumberMap = [[NSMutableDictionary alloc] init];
                    [trackingNumberMap setObject:trackingNumberEntity.parcelTrackingNumber forKey:@"tracking_number"];
                    [trackingNumberMap setObject:[[NSNumber alloc] initWithInteger:trackingNumberEntity.parcelCarrier] forKey:@"carrier"];
                    [annoarr addObject:trackingNumberMap];
                } else if ([entity.entityType isEqualToString:MLKEntityExtractionEntityTypeURL]) {
                    continue;
                } else if ([entity.entityType isEqualToString:MLKEntityExtractionEntityTypeMoney]) {
                    MLKMoneyEntity *moneyEntity = entity.moneyEntity;
                    NSMutableDictionary* moneyMap = [[NSMutableDictionary alloc] init];
                    [moneyMap setObject:moneyEntity.unnormalizedCurrency forKey:@"currency"];
                    [moneyMap setObject:[[NSNumber alloc] initWithInteger:moneyEntity.integerPart] forKey:@"integer_part"];
                    [moneyMap setObject:[[NSNumber alloc] initWithInteger:moneyEntity.fractionalPart] forKey:@"fractional_part"];
                    [annoarr addObject:moneyMap];
                    break;
                } else {
                    continue;
                }
            }
            if([annoarr count] > 0){
                [annomap setObject:annoarr forKey:@"entities"];
            }
            [annots addObject:annomap];
        }
        successCallback(@[annots]);
    }];
}


RCT_EXPORT_METHOD(isModelDownloaded:(NSString *) lang withCallback:(RCTResponseSenderBlock) callback)
{
    MLKEntityExtractionRemoteModel *model = [MLKEntityExtractionRemoteModel entityExtractorRemoteModelWithIdentifier: MLKEntityExtractionModelIdentifierForLanguageTag(lang)];
    bool downloaded = [[MLKModelManager modelManager] isModelDownloaded: model];
    if (downloaded) {
        callback(@[@true]);
    }else{
        callback(@[@false]);
    }
}

RCT_EXPORT_METHOD(deleteDownloadedModel:(NSString *) lang
                  successCallback:(RCTResponseSenderBlock)successCallback
                  failCallback:(RCTResponseSenderBlock)failCallback )
{
    MLKEntityExtractionRemoteModel *model = [MLKEntityExtractionRemoteModel entityExtractorRemoteModelWithIdentifier: MLKEntityExtractionModelIdentifierForLanguageTag(lang)];
    bool downloaded = [[MLKModelManager modelManager] isModelDownloaded: model];
    if(downloaded) {
        [[MLKModelManager modelManager] deleteDownloadedModel:model completion:^(NSError * _Nullable error) {
            if (error != nil) {
                failCallback(@[error.localizedDescription]);
                return;
            }
            successCallback(@[@"success"]);
        }];
    }
}

RCT_EXPORT_METHOD(downloadModel:(NSString *) lang
                  successCallback:(RCTResponseSenderBlock)successCallback
                  failCallback:(RCTResponseSenderBlock)failCallback )
{
    MLKModelDownloadConditions *conditions = [[MLKModelDownloadConditions alloc] initWithAllowsCellularAccess:NO
                                                                                  allowsBackgroundDownloading:YES];
    MLKEntityExtractionRemoteModel *lmodel = [MLKEntityExtractionRemoteModel entityExtractorRemoteModelWithIdentifier: MLKEntityExtractionModelIdentifierForLanguageTag(lang)];
    NSLog(@"lang 是 ======> %@",lang);
    [[MLKModelManager modelManager] downloadModel:lmodel conditions:conditions];
    id sob;
    id fob;
    sob = [NSNotificationCenter.defaultCenter
           addObserverForName:MLKModelDownloadDidSucceedNotification
           object:nil
           queue:nil
           usingBlock:^(NSNotification * _Nonnull note) {
        MLKEntityExtractionRemoteModel *model = note.userInfo[MLKModelDownloadUserInfoKeyRemoteModel];
        if ([model isKindOfClass:[MLKEntityExtractionRemoteModel class]] && model == lmodel) {
            successCallback(@[@"success"]);
        }
        [NSNotificationCenter.defaultCenter removeObserver:sob];
        [NSNotificationCenter.defaultCenter removeObserver:fob];
    }];
    fob = [NSNotificationCenter.defaultCenter
           addObserverForName:MLKModelDownloadDidFailNotification
           object:nil
           queue:nil
           usingBlock:^(NSNotification * _Nonnull note) {
        MLKEntityExtractionRemoteModel *model = note.userInfo[MLKModelDownloadUserInfoKeyRemoteModel];
        if ([model isKindOfClass:[MLKEntityExtractionRemoteModel class]] && model == lmodel) {
            NSError *error = note.userInfo[MLKModelDownloadUserInfoKeyError];
            failCallback(@[error.localizedDescription]);
        }
        [NSNotificationCenter.defaultCenter removeObserver:sob];
        [NSNotificationCenter.defaultCenter removeObserver:fob];
    }];
}
@end
