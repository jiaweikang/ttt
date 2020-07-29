//
//  USBookContactManager.m
//  u_store
//
//  Created by jiangxintong on 2019/1/23.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "USBookContactManager.h"
#import <AddressBook/AddressBook.h>/// iOS 9前的框架
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>/// iOS 9的新框架

#define Is_up_Ios_9 ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

@interface USBookContactManager ()

@end

@implementation USBookContactManager
#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static USBookContactManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[USBookContactManager alloc] init];
    });
    return _manager;
}

- (void)getCallback:(void (^)(NSDictionary *))callback {
    if (Is_up_Ios_9) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                    if (callback) {
                        callback([NSDictionary dictionaryWithObjectsAndKeys:@"0001", @"returnCode", @[], @"data", nil]);
                    }
                } else if (!granted) {
                    if (callback) {
                        callback([NSDictionary dictionaryWithObjectsAndKeys:@"0001", @"returnCode", @[], @"data", nil]);
                    }
                } else {
                    if (callback) {
                        callback([self callAddressBook:Is_up_Ios_9]);
                    }
                }
            }];
            
        } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
            if (callback) {
                callback([self callAddressBook:Is_up_Ios_9]);
            }
            
        } else {
            if (callback) {
                callback([NSDictionary dictionaryWithObjectsAndKeys:@"0001", @"returnCode", @[], @"data", nil]);
            }
        }
        
    } else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        if (authStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                        if (callback) {
                            callback([NSDictionary dictionaryWithObjectsAndKeys:@"0001", @"returnCode", @[], @"data", nil]);
                        }
                        
                    } else if (!granted) {
                        if (callback) {
                            callback([NSDictionary dictionaryWithObjectsAndKeys:@"0001", @"returnCode", @[], @"data", nil]);
                        }
                        
                    } else {
                        if (callback) {
                            callback([self callAddressBook:Is_up_Ios_9]);
                        }
                    }
                });
            });
            
        } else if (authStatus == kABAuthorizationStatusAuthorized) {
            if (callback) {
                callback([self callAddressBook:Is_up_Ios_9]);
            }
        } else {
            if (callback) {
                callback([NSDictionary dictionaryWithObjectsAndKeys:@"0001", @"returnCode", @[], @"data", nil]);
            }
        }
    }
    
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - private methods
/**
 *  获取手机联系人
 */
- (NSDictionary *)callAddressBook:(BOOL)isUp_ios_9 {
    if (isUp_ios_9) {
        NSMutableArray *contacts = [self getContactsUP9];
        NSDictionary *contactsDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0000", @"returnCode", contacts, @"data", nil];
        return contactsDic;
    } else {
        NSMutableArray *contacts = [self getContactsDown9];
        NSDictionary *contactsDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0000", @"returnCode", contacts, @"data", nil];
        return contactsDic;
    }
    return [[NSDictionary alloc] init];
}

/**
 *  获取通讯录所有联系人姓名+手机号 iOS >= 9.0
 */
- (NSMutableArray *)getContactsUP9 {
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *phone = phoneNumber.stringValue;
            //去掉电话中的特殊字符
            phone = [self formatPhoneNumber:phone];
            //是否是标准手机号
            if ([self isMobileNumber:phone]) {
                NSDictionary *contact = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", phone, @"phone", nil];
                [contacts addObject:contact];
            }
        }
        //*stop = YES; // 停止循环，相当于break；
    }];
    return contacts;
}

/**
 *  获取通讯录所有联系人姓名+手机号 iOS < 9.0
 */
- (NSMutableArray *)getContactsDown9 {
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef allpeople = ABAddressBookCopyArrayOfAllPeople(book);
    CFIndex count = CFArrayGetCount(allpeople);
    for (CFIndex i=0; i<count; i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(allpeople, i);
        CFStringRef strFirst = ABRecordCopyValue(record, kABPersonFirstNameProperty);
        CFStringRef strmdills = ABRecordCopyValue(record, kABPersonMiddleNameProperty);
        CFStringRef strfamily = ABRecordCopyValue(record, kABPersonLastNameProperty);
        NSString *name = [NSString stringWithFormat:@"%@%@%@",(__bridge_transfer NSString *)strfamily, (__bridge_transfer NSString *)strmdills,(__bridge_transfer NSString *)strFirst];
        name = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        //电话号码
        ABMultiValueRef multivalue = ABRecordCopyValue(record, kABPersonPhoneProperty);
        for (CFIndex i=0; i<ABMultiValueGetCount(multivalue); i++) {
            CFStringRef phoneStr = ABMultiValueCopyValueAtIndex(multivalue, i);
            NSString *phone = (__bridge_transfer NSString *)(phoneStr);
            //去掉电话中的特殊字符
            phone = [self formatPhoneNumber:phone];
            //是否是标准手机号
            if ([self isMobileNumber:phone]) {
                NSDictionary *contact = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", phone, @"phone", nil];
                [phoneNumbers addObject:contact];
            }
            CFRelease(phoneStr);
        }
        if (strfamily) {
            CFRelease(strfamily);
        }
        if (strmdills) {
            CFRelease(strmdills);
        }
        if (strFirst) {
            CFRelease(strFirst);
        }
    }
    CFRelease(allpeople);
    return phoneNumbers;
}

/**
 *  去掉电话号码中的特殊字符
 */
- (NSString *)formatPhoneNumber:(NSString *)number {
    number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    return number;
}

/**
 *  判断是否为正确的手机号码
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    if ([mobileNum isEqualToString:@""]) return NO;
    NSString *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return  [pre evaluateWithObject:mobileNum];
}

@end
