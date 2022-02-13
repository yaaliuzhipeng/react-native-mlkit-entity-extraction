<p align="center">
  <img src="https://github.com/yaaliuzhipeng/react-native-mlkit-entity-extraction/blob/main/raw/logo.png" alt="MLKitEntityExtraction" width="539" />
</p>

<h4 align="center">
  A MachineLearning Based Entity Extractor
</h4>

<p align="center">
  Build Powerful React Native With Entity Extractor <em>Amazing</em> ⚡️
</p>

<p align="center">
  <a href="https://github.com/yaaliuzhipeng/react-native-mlkit-entity-extraction">
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License">
  </a>
</p>

|   | MLKitEntityExtractor |
| - | ------------ |
| ⚡️ | **Multiple Language Support** over 10 languages supported ([full list](https://developers.google.com/ml-kit/language/entity-extraction)) |
| 😎 | **Lazy loaded**. download models when needed |
| 🔄 | **Offline-first.** no network required for using |
| 📱 | **Multiplatform**. iOS, Android |
| ⏱ | **Fast.** About TO Migrating to RN New Arch(JSI) |
| 🔗 | **Relational.** Built on MLKit [Translation](https://developers.google.com/ml-kit/language/entity-extraction) foundation |
| ⚠️ | **Static typing** Full-Support [TypeScript](https://typescriptlang.org) |

## Why MLKitEntityExtractor?

>Most apps offer users very little interaction with text beyond the basic cut/copy/paste operations. Entity extraction improves the user experience inside your app by understanding text and allowing you to add helpful shortcuts based on context.

The Entity Extraction API allows you to recognize specific entities within static text and while you're typing. Once an entity is identified, you can easily enable different actions for the user based on the entity type. Supported entities included are:

| Entity |	Example |
| - | --------- |
| Address|	350 third street, Cambridge MA
| Date-Time|	2019/09/29, let's meet tomorrow at 6pm
| Email address |	entity-extraction@google.com
| Flight Number | (IATA flight codes only)	LX37
| IBAN |	CH52 0483 0000 0000 0000 9
| ISBN | (version 13 only)	978-1101904190
| Money/Currency (Arabic numerals only) |	$12, 25 USD
| Payment / Credit Cards|	4111 1111 1111 1111
| Phone Number|	(555) 225-3556 12345
| Tracking Number (standardized international formats)|1Z204E380338943508
| URL|	www.google.com  https://en.wikipedia.org/wiki/Platypus


This API focuses on precision over recognition. Some instances of a particular entity might not be detected in favor of ensuring accuracy.
## Usage

**Quick example:** identify language type

```typescript
import MLKitEntityExtraction from './MLKitEntityExtraction';

const text = "My flight is LX373, please pick me up at 8am tomorrow. You can look up at http://github.com";

MLKitEntityExtraction.isModelDownloaded('ENGLISH')
    .then(v => {
		if (v) {
			//extrac it right now
            MLKitEntityExtraction.annotate(
                text,
                'ENGLISH',
                ['TYPE_FLIGHT_NUMBER','TYPE_DATE_TIME','TYPE_URL']
            ).then(v => {
				setExtractions(v);
			}).catch(e => {
                //something wrong
			})
		}else{
			//download model
			MLKitEntityExtraction
                .downloadModel('ENGLISH')
                .then(rs => {
					//download success
				}).catch(e => {
					//something wrong
				})
			}
	});

```

**Remember !!! ✨ Always check model firstly ; 
Do not translate text if the model is not downloaded**

> use MLKitEntityExtraction.isModelDownloaded to check

## Full Support Language
- ARABIC
- GERMAN
- ENGLISH
- SPANISH
- FRENCH
- ITALIAN
- JAPANESE
- KOREAN
- DUTCH
- POLISH
- PORTUGUESE
- RUSSIAN
- THAI
- TURKISH
- CHINESE

## All Supported Entity Type
- ADDRESS
- DATE_TIME
- EMAIL
- FLIGHT_NUMBER
- IBAN
- ISBN
- PAYMENT_CARD
- PHONE
- TRACKING_NUMBER
- URL
- MONEY

## Author and license

**WatermelonDB** was created by [@yaaliuzhipeng](https://github.com/yaaliuzhipeng)

react-native-mlkit-translate-text is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.