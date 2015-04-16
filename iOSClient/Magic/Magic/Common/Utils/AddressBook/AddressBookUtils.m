//
//  AddressBookUtils.m
//  three20test
//
//  Created by qqn_pipi on 10-3-19.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "AddressBookUtils.h"
#import "LocaleUtils.h"
#import "UIImageUtil.h"
#import "StringUtil.h"

@implementation PPContact

@synthesize person;
@synthesize personId;
@synthesize name;

- (id)initWithPerson:(ABRecordRef)personValue personId:(ABRecordID)personIdValue
{
	if (self = [super init]){
		self.person = personValue;
		self.personId = personIdValue;
		self.name = [AddressBookUtils getFullName:personValue];
	}
	
	return self;
}

- (NSString*)stringForGroup
{
	return [AddressBookUtils getFullName:person];
}

@end

@implementation PPGroup

@synthesize group;
@synthesize groupId;
@synthesize name;

- (id)initWithGroup:(ABRecordRef)groupVal groupId:(ABRecordID)groupIdVal name:(NSString*)nameVal
{
	if (self = [super init]){
		self.group = groupVal;
		self.groupId = groupIdVal;
		self.name = nameVal;
	}
	
	return self;
}

@end


@implementation AddressBookUtils

+ (NSString*)getPersonNameByPhone:(NSString*)phone addressBook:(ABAddressBookRef)addressBook
{
	ABRecordRef personRef = [AddressBookUtils getPersonByPhone:phone addressBook:addressBook];
	if (personRef == NULL){
		return @"";
	}
	else {
		return [AddressBookUtils getFullName:personRef];
	}

}

+ (ABRecordRef)getPersonByPhone:(NSString*)phone addressBook:(ABAddressBookRef)addressBook
{
	if (phone == nil || [phone length] <= 0 || addressBook == NULL)
		return NULL;
			
	NSArray* people = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	ABRecordRef retPersonRef = NULL;
	
	BOOL found = NO;
	for (NSObject* person in people){
		ABRecordRef personRef = (__bridge ABRecordRef)person;
		
		NSArray* phonesOfPerson = [AddressBookUtils getPhones:personRef];
		for (NSString* phoneOfPerson in phonesOfPerson){
			// performance is so so, can be improved if needed
			if ([phone isEqualToString:phoneOfPerson] == YES){
				found = YES;
				break;
			}
			else 
			{
                NSString* p = phoneOfPerson;
				p = [p stringByReplacingOccurrencesOfString:@"(" withString:@""];
				p = [p stringByReplacingOccurrencesOfString:@")" withString:@""];
				p = [p stringByReplacingOccurrencesOfString:@"-" withString:@""];
				p = [p stringByReplacingOccurrencesOfString:@" " withString:@""];
				p = [p stringByReplacingOccurrencesOfString:@"+" withString:@""];
				if ([phone isEqualToString:p] == YES){
					found = YES;
					break;
				}
			}

		}
		
		if (found){
			retPersonRef = (__bridge ABRecordRef)(person);
			break;
		}
	}
	
	return retPersonRef;
}

+ (ABRecordRef)getPersonByPhone:(NSString*)phone addressBook:(ABAddressBookRef)addressBook countryTelPrefix:(NSString*)countryTelPrefix
{
	if (phone == nil || [phone length] <= 0 || addressBook == NULL || countryTelPrefix == nil)
		return NULL;
	
	NSString* formatPhone = [NSString formatPhone:phone countryTelPrefix:countryTelPrefix];	
	NSArray* people = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	ABRecordRef retPersonRef = NULL;
	
	BOOL found = NO;
	for (NSObject* person in people){
		ABRecordRef personRef = (__bridge ABRecordRef)person;
		
		NSArray* phonesOfPerson = [AddressBookUtils getPhones:personRef];
		for (NSString* phoneOfPerson in phonesOfPerson){
			NSString* p = [NSString formatPhone:phoneOfPerson countryTelPrefix:countryTelPrefix];
			if ([p isEqualToString:formatPhone]){
				found = YES;
				break;
			}
		}
		
		if (found){
			retPersonRef = (__bridge ABRecordRef)(person);
			break;
		}
	}

    return retPersonRef;
}


// return label, but remove prefix and suffix in "_$!<Mobile>!$_"
+ (NSString *)getPhoneLabel:(ABMultiValueRef)phones index:(int)index
{
	NSString* origLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, index);
	
	NSString* localizedLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)origLabel);
	
	NSString* finalLabel = [NSString stringWithString:localizedLabel];
	
	finalLabel = [finalLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
	finalLabel = [finalLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];	
	
	return finalLabel;
}

+ (NSString*)getPhoneLabel:(ABRecordRef)person phone:(NSString*)phone
{
	BOOL found = NO;
	NSString* returnLabel = @"";
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		CFIndex count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);

			if (phoneNumber != nil && [phoneNumber isEqualToString:phone]){
				// found
				found = YES;				
			}			
			
			if (found){
				NSString* localizedLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)phoneLabel);
				returnLabel = [NSString stringWithString:localizedLabel];
				
				returnLabel = [returnLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
				returnLabel = [returnLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];	
				
			}
			
			if (found){
				break;
			}
		}
	}
	CFRelease(phones);
	
	return returnLabel;
	
}

+ (NSDate*)copyModificationDate:(ABRecordRef)person
{
	NSDate* date = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonModificationDateProperty);
	
//	NSLog(@"latest date is %@", date);
	
	return date;
}

+ (NSString *)getFullName:(ABAddressBookRef)addressBook personId:(int)personId
{
	ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBook, personId);
	if (!personRef)
		return nil;
	else {
		return [AddressBookUtils getFullName:personRef];
	}

}

+ (NSString *)getFullName:(ABRecordRef)person
{

	/*
	NSString* countryCode = [LocaleUtils getCountryCode];
	if (countryCode != nil && ( [countryCode isEqualToString:@"CN"] == YES || 
							   [countryCode isEqualToString:@"TW"] == YES ||
							   [countryCode isEqualToString:@"KR"] == YES ||
							   [countryCode isEqualToString:@"JP"] == YES))								   
	{
	}
	else{
	}
	*/
		
	
	CFStringRef name = ABRecordCopyCompositeName(person);
	if (name == NULL){
		return @"";
	}
	
	NSString* ret = [NSString stringWithString:(__bridge NSString*)name];
	
	CFRelease(name);
	
	return ret;
	
	/*
	NSString* firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString* lastName  = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	NSString* orgName = (NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
	
	BOOL useOrgName = NO;
	
	if (firstName == nil && lastName == nil)
		useOrgName = YES;
	
	if (firstName == nil)
		firstName = @"";
	
	if (lastName == nil)
		lastName = @"";		
	
	NSString* fullName;
	
	if (useOrgName == NO){
		if ([[LocaleUtils getCountryCode] isEqualToString:@"CN"] == YES){
			if ([lastName length] > 0){
				fullName = [NSString stringWithFormat:@"%@ %@", lastName, firstName];	
			}
			else {
				fullName = [NSString stringWithString:firstName];
			}

		}
		else {
			if ([firstName length] > 0){
				fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];	
			}
			else {
				fullName = [NSString stringWithString:lastName];
			}

		}	
	}
	else {
		
		if (orgName == nil)
			orgName = @"";
		
		fullName = [NSString stringWithFormat:@"%@", orgName];
	}
	
	[firstName release];
	[lastName release];
	[orgName release];
	 
	
	return fullName;
	 */ 
}

+ (NSArray *)getPhonesWithAddressBook:(ABRecordID)personId addressBook:(ABAddressBookRef)addressBook
{
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, personId);
	if (person){
		return [AddressBookUtils getPhones:person];
	}
	else {
		return nil;
	}
}

// get the first phone number to display

+ (BOOL)hasPhones:(ABRecordRef)person
{
	NSArray* phones = [AddressBookUtils getPhones:person];
	if (phones != nil && [phones count] > 0){
		return YES;
	}
	else {
		return NO;
	}

}

+ (BOOL)hasEmails:(ABRecordRef)person
{
	NSArray* emails = [AddressBookUtils getEmails:person];
	if (emails != nil && [emails count] > 0){
		return YES;
	}
	else {
		return NO;
	}
	
}

+ (BOOL)hasMobiles:(ABRecordRef)person
{
	BOOL ret = NO;
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		CFIndex count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
//			NSString *phoneNumber      = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
//			NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
			
//			[phoneList addObject:phoneNumber];

			if ([phoneLabel isEqualToString:@"_$!<Mobile>!$_"] ||
				[phoneLabel isEqualToString:@"iPhone"] )
			{
				ret = YES;
			}
			
			if (ret){
				break;
			}
		}
	}
	CFRelease(phones);
	
	return ret;
	
}

+ (NSString *)getFirstMobilePhone:(ABRecordRef)person
{
	NSString* mobile = nil;
	NSString* iPhone = nil;
	NSString* main = nil;
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		CFIndex count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
//			NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
			
			if ([phoneLabel isEqualToString:@"_$!<Mobile>!$_"])
			{
				mobile = [NSString stringWithString:phoneNumber];
			}			
			else if ([phoneLabel isEqualToString:@"iPhone"]){
				iPhone = [NSString stringWithString:phoneNumber];				
			}
			else if ([phoneLabel isEqualToString:@"_$!<Main>!$_"]){
				main = [NSString stringWithString:phoneNumber];
			}
			
		}
	}
	CFRelease(phones);
	
	if (iPhone != nil && [iPhone length] > 0)
		return iPhone;
	
	if (mobile != nil && [mobile length] > 0)
		return mobile;

	if (main != nil && [main length] > 0)
		return main;
	
	return nil;
}

+ (NSArray *)getMobilePhones:(ABRecordRef)person
{
	NSMutableArray* phoneList = [[NSMutableArray alloc] init];
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		CFIndex count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
			NSString *phoneLabel       = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
//			NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);

			if ([phoneLabel isEqualToString:@"_$!<Mobile>!$_"] ||
				[phoneLabel isEqualToString:@"iPhone"] )
			{
				// it's mobile, then add the objects
				[phoneList addObject:phoneNumber];
			}			
			
		}
	}
	CFRelease(phones);
	
	return phoneList;
}


+ (NSArray *)getPhones:(ABRecordRef)person
{
	NSMutableArray* phoneList = [[NSMutableArray alloc] init];
	
	ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);	
	if (phones){
		CFIndex count = ABMultiValueGetCount(phones);
		for (CFIndex i = 0; i < count; i++) {
//			NSString *phoneLabel       = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
			NSString *phoneNumber      = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
			//NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
			
			[phoneList addObject:phoneNumber];
			
		}
	}
	CFRelease(phones);

	return phoneList;
	
	
}

+ (NSString*)getPhoneWithPerson:(ABRecordRef)person identifier:(ABMultiValueIdentifier)identifier property:(ABPropertyID)property
{
	NSString* retPhone = nil;
	ABMultiValueRef phones = ABRecordCopyValue(person, property);	

	if (phones){
		CFIndex index = ABMultiValueGetIndexForIdentifier(phones, identifier);
		NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, index);
		retPhone = [NSString stringWithString:phone];		
	}

	CFRelease(phones);	

	return retPhone;
}

+ (NSArray *)getEmailsWithAddressBook:(ABRecordID)personId addressBook:(ABAddressBookRef)addressBook
{
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, personId);
	if (person){
		return [AddressBookUtils getEmails:person];
	}
	else {
		return nil;
	}
}

+ (NSString *)getFirstEmail:(ABRecordRef)person
{
	NSArray* emailArr = [AddressBookUtils getEmails:person];
	if (emailArr != nil && [emailArr count] > 0)
		return [emailArr objectAtIndex:0];
	else
		return nil;
}

// can be refactored to the same implementation later
+ (NSArray *)getEmails:(ABRecordRef)person
{
	NSMutableArray* emailList = [[NSMutableArray alloc] init];
	
	ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);	
	if (emails){
		for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
//			NSString *label       = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(emails, i);
			NSString *value      = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, i);
			
//			NSLog(@"email label (%@), number (%@)", label, value);
			
			[emailList addObject:value];
		}
	}
	CFRelease(emails);
	
	return emailList;
}

+ (UIImage*)getImageByPerson:(ABRecordRef)person
{
	UIImage* image = nil;
	
	if (ABPersonHasImageData(person)){
		
//		NSData* data = (NSData *)ABPersonCopyImageData(person);

		NSData* data = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize);
		image = [UIImage imageWithData:data];		
	}
	
	return image;	
}

+ (UIImage*)getSmallImage:(ABRecordRef)person size:(CGSize)size
{
	UIImage* image = [AddressBookUtils getImageByPerson:person];
	
	if (image != nil){
		// resize image
		return [image imageByScalingAndCroppingForSize:size];
	}
	
	return nil;
}

+ (UIImage*)getThumbnailImage:(ABRecordRef)person
{
	NSData* data = (__bridge NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
	UIImage* image = [[UIImage alloc] initWithData:data];
	return image;
}


+ (NSString*)getShortName:(ABRecordRef)person
{
	NSString* firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString* lastName  = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	NSString* orgName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
	
	BOOL useOrgName = NO;
	
	if (firstName == nil && lastName == nil)
		useOrgName = YES;
	
	if (firstName == nil)
		firstName = @"";
	
	if (lastName == nil)
		lastName = @"";		
	
	NSString* fullName;
	
	if (useOrgName == NO){
		NSString* countryCode = [LocaleUtils getCountryCode];
		if (countryCode != nil && ( [countryCode isEqualToString:@"CN"] == YES || 
								    [countryCode isEqualToString:@"TW"] == YES ||
								    [countryCode isEqualToString:@"KR"] == YES ||
								    [countryCode isEqualToString:@"JP"] == YES)								   
								   )
		{
			if ([lastName length] > 0){
				fullName = [NSString stringWithFormat:@"%@ %@", lastName, firstName];	
			}
			else {
				fullName = [NSString stringWithString:firstName];
			}
			
		}
		else {			
			if ([firstName length] > 0){
				fullName = [NSString stringWithFormat:@"%@", firstName];	
			}
			else {
				fullName = [NSString stringWithString:lastName];
			}
			
		}	
	}
	else {
		
		if (orgName == nil)
			orgName = @"";
		
		fullName = [NSString stringWithFormat:@"%@", orgName];
	}
		
	return fullName;
	
}

+ (BOOL)addPhone:(ABRecordRef)person phone:(NSString*)phone
{
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	
	CFErrorRef anError = NULL;
	
	// The multivalue identifier of the new value isn't used in this example,
	// multivalueIdentifier is just for illustration purposes.  Real-world
	// code can use this identifier to do additional work with this value.
	ABMultiValueIdentifier multivalueIdentifier;
	
	if (!ABMultiValueAddValueAndLabel(multi, (__bridge CFStringRef)phone, kABPersonPhoneMainLabel, &multivalueIdentifier)){
		CFRelease(multi);
		return NO;
	}
		
	if (!ABRecordSetValue(person, kABPersonPhoneProperty, multi, &anError)){
		CFRelease(multi);
		return NO;
	}

	CFRelease(multi);
	return YES;
}

+ (BOOL)addAddress:(ABRecordRef)person street:(NSString*)street
{
	ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
	
	static int  homeLableValueCount = 5;
	
	// Set up keys and values for the dictionary.
	CFStringRef keys[homeLableValueCount];
	CFStringRef values[homeLableValueCount];
	keys[0]      = kABPersonAddressStreetKey;
	keys[1]      = kABPersonAddressCityKey;
	keys[2]      = kABPersonAddressStateKey;
	keys[3]      = kABPersonAddressZIPKey;
	keys[4]      = kABPersonAddressCountryKey;
	values[0]    = (__bridge CFStringRef)street;
	values[1]    = CFSTR("");
	values[2]    = CFSTR("");
	values[3]    = CFSTR("");
	values[4]    = CFSTR("");
	
	CFDictionaryRef aDict = CFDictionaryCreate(
											   kCFAllocatorDefault,
											   (void *)keys,
											   (void *)values,
											   homeLableValueCount,
											   &kCFCopyStringDictionaryKeyCallBacks,
											   &kCFTypeDictionaryValueCallBacks
											   );
	
	// Add the street address to the person record.
	ABMultiValueIdentifier identifier;
	
	BOOL result = ABMultiValueAddValueAndLabel(address, aDict, kABHomeLabel, &identifier);	

	CFErrorRef error = NULL;
	result = ABRecordSetValue(person, kABPersonAddressProperty, address, &error);
	
	CFRelease(aDict);	
	CFRelease(address);	
	
	return result;
}

+ (BOOL)addImage:(ABRecordRef)person image:(UIImage*)image
{
	CFErrorRef error = NULL;
	
	// remove old image data firstly
	ABPersonRemoveImageData(person, NULL);
	
	// add new image data
	BOOL result = ABPersonSetImageData (
							   person,
							   (__bridge CFDataRef)UIImagePNGRepresentation(image),
							   &error
							   );	
	
//	CFRelease(error);
	
	return result;
}

+ (NSMutableArray *)queryContact:(NSString*)searchText addressBook:(ABAddressBookRef)addressBook
{
	NSArray* allPeople;
	NSArray* sortedAllPeople;
	
	if (searchText != nil && [searchText length] > 0){		
		allPeople = (__bridge NSArray*)ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)searchText);
	}
	else {		
		allPeople = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
	}
	
	if (allPeople == nil)
		return nil;
	
	ABPersonSortOrdering sortOrdering = kABPersonSortByLastName;						
	sortedAllPeople = [allPeople sortedArrayUsingFunction:ABPersonComparePeopleByName context:(void*)sortOrdering];
	
	if (sortedAllPeople == nil){
		return nil;
	}
	
	NSMutableArray* list = [[NSMutableArray alloc] init];
	for (NSObject* obj in sortedAllPeople){	
		ABRecordRef person = (__bridge ABRecordRef)obj;
		PPContact* contact = [[PPContact alloc] initWithPerson:person personId:ABRecordGetRecordID(person)];
		[list addObject:contact];	
	}
	
	return list;
}

+ (NSMutableArray *)queryAllGroup:(ABAddressBookRef)addressBook
{
	NSMutableArray* list = [[NSMutableArray alloc] init];

	// add all group object
	PPGroup* allGroupObj = [[PPGroup alloc] initWithGroup:NULL 
											   groupId:kGroupIdForAllGroup
												  name:NSLS(@"All Groups")];
	[list addObject:allGroupObj];
	
	// add group objects
	NSArray* allGroups = (__bridge NSArray*)ABAddressBookCopyArrayOfAllGroups(addressBook);
	if (allGroups != nil && [allGroups count] > 0){
		for (NSObject* group in allGroups){
			NSString* groupName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(group), kABGroupNameProperty);
			PPGroup* groupObj = [[PPGroup alloc] initWithGroup:(__bridge ABRecordRef)(group) 
													   groupId:ABRecordGetRecordID((__bridge ABRecordRef)(group)) 
														  name:groupName];
			
			[list addObject:groupObj];
		}
	}

	return list;
}

+ (NSMutableArray *)queryAllContact:(ABAddressBookRef)addressBook
{
	return [AddressBookUtils queryContact:nil addressBook:addressBook];
}

+ (NSArray*)queryContactByGroup:(NSString*)searchText inGroup:(int)groupId addressBook:(ABAddressBookRef)addressBook
{
	if (addressBook == NULL)
		return nil;
	
	if (groupId == kGroupIdForAllGroup)
		return [AddressBookUtils queryContact:searchText addressBook:addressBook];
	
	ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(addressBook, groupId);
	if (groupRef == NULL)
		return nil;
	
	NSMutableArray* retList = [[NSMutableArray alloc] init];
	NSArray* memberList = (__bridge NSArray*)ABGroupCopyArrayOfAllMembers(groupRef);
	if (memberList != nil && [memberList count] > 0){
		// add group object
		for (NSObject* person in memberList){
			
			BOOL needAdd = YES;
			NSString*  name = [AddressBookUtils getFullName:(__bridge ABRecordRef)(person)];
			if (searchText != nil && [searchText length] > 0){
				if (name == nil){
					needAdd = NO;
				}
				else if ([name rangeOfString:searchText options:NSCaseInsensitiveSearch].location == NSNotFound){
					needAdd = NO;
				}
			}
			
			if (needAdd){
				ABRecordID personId = ABRecordGetRecordID((__bridge ABRecordRef)(person));
				PPContact* contact = [[PPContact alloc] initWithPerson:(__bridge ABRecordRef)(person) personId:personId];
				[retList addObject:contact];
			}
		}
		
	}
	
	// sort return array
	return [retList sortedArrayUsingComparator:^(id obj1, id obj2) {					
		return [[((PPContact*)obj1).name pinyinFirstLetter] compare:[((PPContact*)obj2).name pinyinFirstLetter]]; 
	}];	
}

+ (BOOL)isPersonNew:(ABRecordRef)person lastCheckDate:(NSDate*)lastCheckDate
{
	if (person != NULL){
		NSDate* createDate = (__bridge NSDate*) ABRecordCopyValue( person, kABPersonCreationDateProperty );
		BOOL ret = [lastCheckDate timeIntervalSinceDate:createDate] < 0;
		return ret;
	}
	
	return NO;
}

+ (BOOL)isPersonModify:(ABRecordRef)person lastCheckDate:(NSDate*)lastCheckDate
{
	if (person != NULL){
		NSDate* modifyDate = (__bridge NSDate*) ABRecordCopyValue( person, kABPersonModificationDateProperty );
		BOOL ret = [lastCheckDate timeIntervalSinceDate:modifyDate] < 0;
		return ret;
	}
	
	return NO;	
}

+ (void)setThumbnailImage:(ABRecordRef)person UIImage:(UIImage*)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    ABRecordSetValue(person, kABPersonImageFormatThumbnail, (__bridge CFDataRef)imageData, NULL);
}

+ (void)setNormalImage:(ABRecordRef)person UIImage:(UIImage*)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    ABRecordSetValue(person, kABPersonImageFormatThumbnail, (__bridge CFDataRef)imageData, NULL);
}


@end
