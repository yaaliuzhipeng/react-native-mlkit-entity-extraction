// MlkitEntityExtraction.h

#import <React/RCTBridgeModule.h>
@import MLKitCommon;
@import MLKitEntityExtraction;

@interface MlkitEntityExtraction : NSObject <RCTBridgeModule>
@property (nonatomic,strong) MLKEntityExtractor *entityExtractor;
- (NSString *) mapEntityTypeRev:(int ) type;
- (int) mapEntityType:(NSString* ) type;
@end
