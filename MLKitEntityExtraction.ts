import { NativeModules,Platform } from "react-native";

const { MLKitEntityExtraction: NativeMLKitEntityExtraction } = NativeModules;
const isAndroid = Platform.OS === 'android';
export const ENTITY_LANG_TAGS = {
    ARABIC: "arabic",
    GERMAN: "german",
    ENGLISH: "english",
    SPANISH: "spanish",
    FRENCH: "french",
    ITALIAN: "italian",
    JAPANESE: "japanese",
    KOREAN: "korean",
    DUTCH: "dutch",
    POLISH: "polish",
    PORTUGUESE: "portuguese",
    RUSSIAN: "russian",
    THAI: "thai",
    TURKISH: "turkish",
    CHINESE: "chinese",
}

export const LANG_TAGS = {
    AFRIKAANS: "af",
    ALBANIAN: "sq",
    ARABIC: "ar",
    BELARUSIAN: "be",
    BULGARIAN: "bg",
    BENGALI: "bn",
    CATALAN: "ca",
    CHINESE: "zh",
    CROATIAN: "hr",
    CZECH: "cs",
    DANISH: "da",
    DUTCH: "nl",
    ENGLISH: "en",
    ESPERANTO: "eo",
    ESTONIAN: "et",
    FINNISH: "fi",
    FRENCH: "fr",
    GALICIAN: "gl",
    GEORGIAN: "ka",
    GERMAN: "de",
    GREEK: "el",
    GUJARATI: "gu",
    HAITIAN_CREOLE: "ht",
    HEBREW: "he",
    HINDI: "hi",
    HUNGARIAN: "hu",
    ICELANDIC: "is",
    INDONESIAN: "id",
    IRISH: "ga",
    ITALIAN: "it",
    JAPANESE: "ja",
    KANNADA: "kn",
    KOREAN: "ko",
    LITHUANIAN: "lt",
    LATVIAN: "lv",
    MACEDONIAN: "mk",
    MARATHI: "mr",
    MALAY: "ms",
    MALTESE: "mt",
    NORWEGIAN: "no",
    PERSIAN: "fa",
    POLISH: "pl",
    PORTUGUESE: "pt",
    ROMANIAN: "ro",
    RUSSIAN: "ru",
    SLOVAK: "sk",
    SLOVENIAN: "sl",
    SPANISH: "es",
    SWEDISH: "sv",
    SWAHILI: "sw",
    TAGALOG: "tl",
    TAMIL: "ta",
    TELUGU: "te",
    THAI: "th",
    TURKISH: "tr",
    UKRAINIAN: "uk",
    URDU: "ur",
    VIETNAMESE: "vi",
    WELSH: "cy",
}
export type ENTITY_LANG_TAGS_TYPE = 'ARABIC' |
    'GERMAN' |
    'ENGLISH' |
    'SPANISH' |
    'FRENCH' |
    'ITALIAN' |
    'JAPANESE' |
    'KOREAN' |
    'DUTCH' |
    'POLISH' |
    'PORTUGUESE' |
    'RUSSIAN' |
    'THAI' |
    'TURKISH' |
    'CHINESE';
export const ENTITY_TYPES = {
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
}
export type ENTITY_TYPE = 'TYPE_ADDRESS'|
'TYPE_DATE_TIME'|
'TYPE_EMAIL'|
'TYPE_FLIGHT_NUMBER'|
'TYPE_IBAN'|
'TYPE_ISBN'|
'TYPE_PAYMENT_CARD'|
'TYPE_PHONE'|
'TYPE_TRACKING_NUMBER'|
'TYPE_URL'|
'TYPE_MONEY';

const annotate = (text:string,lang:ENTITY_LANG_TAGS_TYPE, types: ENTITY_TYPE[]) => {
    return new Promise((resolver,rejecter) => {
        let mappedTypes:number[] = [];
        for(let tp of types) {
            if(typeof(ENTITY_TYPES[tp]) === 'number') mappedTypes.push(ENTITY_TYPES[tp]);
        }
        NativeMLKitEntityExtraction.annotate(
            text,
            isAndroid ? ENTITY_LANG_TAGS[lang] : LANG_TAGS[lang],
            mappedTypes,
            (v) => {
                resolver(v);
            },
            (e) => {
                rejecter(e);
            });
    })
}

const isModelDownloaded = (language:ENTITY_LANG_TAGS_TYPE) => {
    return new Promise((resolver, rejecter) => {
        NativeMLKitEntityExtraction.isModelDownloaded(
            isAndroid ? ENTITY_LANG_TAGS[language] : LANG_TAGS[language],
            (v) => { 
                if(Platform.OS === 'ios') {
                    resolver(v === 1 ? true : false); 
                }else{
                    resolver(v);
                }
            },
            // (e) => { rejecter(e); } // no need for now
        );
    });
}
const deleteDownloadedModel = (language: ENTITY_LANG_TAGS_TYPE) => {
    return new Promise((resolver, rejecter) => {
        NativeMLKitEntityExtraction.deleteDownloadedModel(
            isAndroid ? ENTITY_LANG_TAGS[language] : LANG_TAGS[language],
            (v) => { resolver(v); },
            (e) => { rejecter(e); }
        );
    });
}
const downloadModel = (language: ENTITY_LANG_TAGS_TYPE) => {
    return new Promise((resolver, rejecter) => {
        NativeMLKitEntityExtraction.downloadModel(
            isAndroid ? ENTITY_LANG_TAGS[language] : LANG_TAGS[language],
            (v) => { resolver(v); },
            (e) => { rejecter(e); }
        );
    });
}

const MLKitEntityExtraction = {
    annotate,
    isModelDownloaded,
    deleteDownloadedModel,
    downloadModel
}
export default MLKitEntityExtraction;
export {
    annotate,
    isModelDownloaded,
    deleteDownloadedModel,
    downloadModel
}