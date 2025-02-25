//
//  APISearchDataModel.swift
//  MBA-book-browser
//
//  Created by Moonbeom KWON on 2/24/25.
//

struct APISearchDataModel: Codable {
    
    let kind: String
    let totalItems: Int
    let items: [APIBookDataModel]
    
    enum CodingKeys: String, CodingKey {
        case kind
        case totalItems
        case items
    }
}

struct APIBookDataModel: Codable {
    let id: String
    let etag: String
    let volumeInfo: APIVolumeInfoModel
    let saleInfo: APISaleInfoModel
    
    enum CodingKeys: String, CodingKey {
        case id
        case etag
        case volumeInfo
        case saleInfo
    }
}

struct APIVolumeInfoModel: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let imageLinks: APIVolumeImageModel?
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case authors
        case publisher
        case publishedDate
        case description
        case imageLinks
    }
}

struct APIVolumeImageModel: Codable {
    let smallThumbnail: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case smallThumbnail
        case thumbnail
    }
}

struct APISaleInfoModel: Codable {
    let country: String
    let saleability: String
    let isEbook: Bool
    let listPrice: APISalePriceModel?
    let retailPrice: APISalePriceModel?
    let buyLink: String?
    
    enum CodingKeys: String, CodingKey {
        case country
        case saleability
        case isEbook
        case listPrice
        case retailPrice
        case buyLink
    }
}

struct APISalePriceModel: Codable {
    let amount: Float
    let currencyCode: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case currencyCode
    }
}

/*
 {
   "kind": "books#volume",
   "id": "RKAFCwAAQBAJ",
   "etag": "Hno3Vm0oc1I",
   "selfLink": "https://www.googleapis.com/books/v1/volumes/RKAFCwAAQBAJ",
   "volumeInfo": {
     "title": "Swift for Beginners",
     "subtitle": "Develop and Design",
     "authors": [
       "Boisy G. Pitre"
     ],
     "publisher": "Peachpit Press",
     "publishedDate": "2015-11-26",
     "description": "LEARNING A NEW PROGRAMMING LANGUAGE can be daunting. With Swift, Apple has lowered the barrier of entry for developing iOS and OS X apps by giving developers an innovative programming language for Cocoa and Cocoa Touch. Now in its second edition, Swift for Beginners has been updated to accommodate the evolving features of this rapidly adopted language. If you are new to Swift, this book is for you. If you have never used C, C++, or Objective-C, this book is definitely for you. With this handson guide, you’ll quickly be writing Swift code, using Playgrounds to instantly see the results of your work. Author Boisy G. Pitre gives you a solid grounding in key Swift language concepts—including variables, constants, types, arrays, and dictionaries—before he shows you how to use Swift’s innovative Xcode integrated development environment to create apps for iOS and OS X. THIS BOOK INCLUDES: Detailed instruction, ample illustrations, and clear examples Best practices from an experienced Mac and iOS developer Emphasis on how to use Xcode, Playgrounds, and the REPL COMPANION WEBSITE: www.peachpit.com/swiftbeginners2 includes additional resources.",
     "industryIdentifiers": [
       {
         "type": "ISBN_13",
         "identifier": "9780134289786"
       },
       {
         "type": "ISBN_10",
         "identifier": "0134289781"
       }
     ],
     "readingModes": {
       "text": true,
       "image": true
     },
     "pageCount": 702,
     "printType": "BOOK",
     "categories": [
       "Computers"
     ],
     "maturityRating": "NOT_MATURE",
     "allowAnonLogging": true,
     "contentVersion": "1.12.11.0.preview.3",
     "panelizationSummary": {
       "containsEpubBubbles": false,
       "containsImageBubbles": false
     },
     "imageLinks": {
       "smallThumbnail": "http://books.google.com/books/content?id=RKAFCwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
       "thumbnail": "http://books.google.com/books/content?id=RKAFCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
     },
     "language": "en",
     "previewLink": "http://books.google.co.kr/books?id=RKAFCwAAQBAJ&printsec=frontcover&dq=intitle:swift&hl=&cd=1&source=gbs_api",
     "infoLink": "https://play.google.com/store/books/details?id=RKAFCwAAQBAJ&source=gbs_api",
     "canonicalVolumeLink": "https://play.google.com/store/books/details?id=RKAFCwAAQBAJ"
   },
   "saleInfo": {
     "country": "KR",
     "saleability": "FOR_SALE",
     "isEbook": true,
     "listPrice": {
       "amount": 28280,
       "currencyCode": "KRW"
     },
     "retailPrice": {
       "amount": 25452,
       "currencyCode": "KRW"
     },
     "buyLink": "https://play.google.com/store/books/details?id=RKAFCwAAQBAJ&rdid=book-RKAFCwAAQBAJ&rdot=1&source=gbs_api",
     "offers": [
       {
         "finskyOfferType": 1,
         "listPrice": {
           "amountInMicros": 28280000000,
           "currencyCode": "KRW"
         },
         "retailPrice": {
           "amountInMicros": 25452000000,
           "currencyCode": "KRW"
         }
       }
     ]
   },
   "accessInfo": {
     "country": "KR",
     "viewability": "PARTIAL",
     "embeddable": true,
     "publicDomain": false,
     "textToSpeechPermission": "ALLOWED_FOR_ACCESSIBILITY",
     "epub": {
       "isAvailable": true,
       "acsTokenLink": "http://books.google.co.kr/books/download/Swift_for_Beginners-sample-epub.acsm?id=RKAFCwAAQBAJ&format=epub&output=acs4_fulfillment_token&dl_type=sample&source=gbs_api"
     },
     "pdf": {
       "isAvailable": true,
       "acsTokenLink": "http://books.google.co.kr/books/download/Swift_for_Beginners-sample-pdf.acsm?id=RKAFCwAAQBAJ&format=pdf&output=acs4_fulfillment_token&dl_type=sample&source=gbs_api"
     },
     "webReaderLink": "http://play.google.com/books/reader?id=RKAFCwAAQBAJ&hl=&source=gbs_api",
     "accessViewStatus": "SAMPLE",
     "quoteSharingAllowed": false
   },
   "searchInfo": {
     "textSnippet": "If you are new to Swift, this book is for you. If you have never used C, C++, or Objective-C, this book is definitely for you."
   }
 } */

