#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    
    NSMutableString *inputNumber = [NSMutableString stringWithString:string];
    if ([inputNumber characterAtIndex:0] != '+') {
        [inputNumber insertString:@"+" atIndex:0];
    }
    
    NSMutableString *countryCode = [NSMutableString stringWithString:@""];
    NSMutableString *countryID = [NSMutableString stringWithString:@""];
    NSMutableString *resultNumber = [NSMutableString stringWithString:@""];
    
    NSDictionary *codesAndFormatNumber = @{
        @"+7" : @[@"RU", @"+x (xxx) xxx-xx-xx"],        //  10  7   RU  +x (xxx) xxx-xx-xx    = 11
        @"+77" : @[@"KZ", @"+x (xxx) xxx-xx-xx"],       //  10  7   KZ  +x (xxx) xxx-xx-xx    = 11
        @"+373" : @[@"MD", @"+xxx (xx) xxx-xxx"],       //  8   373 MD  +xxx (xx) xxx-xxx     = 11
        @"+374" : @[@"AM", @"+xxx (xx) xxx-xxx"],       //  8   374 AM  +xxx (xx) xxx-xxx     = 11
        @"+375" : @[@"BY", @"+xxx (xx) xxx-xx-xx"],     //  9   375 BY  +xxx (xx) xxx-xx-xx   = 12
        @"+380" : @[@"UA", @"+xxx (xx) xxx-xx-xx"],     //  9   380 UA  +xxx (xx) xxx-xx-xx   = 12
        @"+992" : @[@"TJ", @"+xxx (xx) xxx-xx-xx"],     //  9   992 TJ  +xxx (xx) xxx-xx-xx   = 12
        @"+993" : @[@"TM", @"+xxx (xx) xxx-xxx"],       //  8   993 TM  +xxx (xx) xxx-xxx     = 11
        @"+994" : @[@"AZ", @"+xxx (xx) xxx-xx-xx"],     //  9   994 AZ  +xxx (xx) xxx-xx-xx   = 12
        @"+996" : @[@"KG", @"+xxx (xx) xxx-xx-xx"],     //  9   996 KG  +xxx (xx) xxx-xx-xx   = 12
        @"+998" : @[@"UZ", @"+xxx (xx) xxx-xx-xx"]      //  9   998 UZ  +xxx (xx) xxx-xx-xx   = 12
    };
    
    NSArray *codes = [codesAndFormatNumber allKeys];
    
    NSSortDescriptor *sortDescriptor= [[[NSSortDescriptor alloc] initWithKey:@"length" ascending:NO] autorelease];
    
    codes = [codes sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    for (NSString *code in codes) {
        if (code.length <= inputNumber.length) {
            if ([code isEqualToString:[inputNumber substringWithRange:NSMakeRange(0, code.length)]]) {
                [countryCode appendString:code];
                break;
            }
        }
    }
    
    // no matches the country code
    if (countryCode.length == 0) {
        if (inputNumber.length > 13) {
            return @{KeyPhoneNumber: [inputNumber substringWithRange:NSMakeRange(0, 13)],
                     KeyCountry: @""};
        } else {
            return @{KeyPhoneNumber: inputNumber,
                     KeyCountry: @""};
        }
    }
    
    [countryID appendString: [[codesAndFormatNumber objectForKey:countryCode] objectAtIndex:0]];
    [resultNumber appendString:[[codesAndFormatNumber objectForKey:countryCode] objectAtIndex:1]];
    
    [inputNumber deleteCharactersInRange:NSMakeRange(0, 1)];
    
    for (int q = 1; q < resultNumber.length; q++) {
        if ([resultNumber characterAtIndex:q] == 'x') {
            [resultNumber replaceCharactersInRange:NSMakeRange(q, 1) withString: [inputNumber substringToIndex:1]];
            [inputNumber deleteCharactersInRange:NSMakeRange(0, 1)];
            if (inputNumber.length == 0 && q < (resultNumber.length - 1)) {
                
                [resultNumber deleteCharactersInRange:NSMakeRange(q + 1, resultNumber.length - q - 1)];
                break;
            }
        }
    }
    
    return @{KeyPhoneNumber: resultNumber,
             KeyCountry: countryID};
}
@end
