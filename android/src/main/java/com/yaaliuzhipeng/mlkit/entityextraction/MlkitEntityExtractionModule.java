// MlkitEntityExtractionModule.java

package com.yaaliuzhipeng.mlkit.entityextraction;

import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.mlkit.common.model.DownloadConditions;
import com.google.mlkit.common.model.RemoteModelManager;
import com.google.mlkit.nl.entityextraction.DateTimeEntity;
import com.google.mlkit.nl.entityextraction.Entity;
import com.google.mlkit.nl.entityextraction.EntityAnnotation;
import com.google.mlkit.nl.entityextraction.EntityExtraction;
import com.google.mlkit.nl.entityextraction.EntityExtractionParams;
import com.google.mlkit.nl.entityextraction.EntityExtractionRemoteModel;
import com.google.mlkit.nl.entityextraction.EntityExtractor;
import com.google.mlkit.nl.entityextraction.EntityExtractorOptions;
import com.google.mlkit.nl.entityextraction.FlightNumberEntity;
import com.google.mlkit.nl.entityextraction.IbanEntity;
import com.google.mlkit.nl.entityextraction.MoneyEntity;
import com.google.mlkit.nl.entityextraction.PaymentCardEntity;
import com.google.mlkit.nl.entityextraction.TrackingNumberEntity;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class MlkitEntityExtractionModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    final String TAG = "entity";

    public MlkitEntityExtractionModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "MLKitEntityExtraction";
    }

    @ReactMethod
    public void annotate(String text, String lang, ReadableArray types, Callback successCallback,Callback failCallback) {
        EntityExtractor entityExtractor = EntityExtraction.getClient(new EntityExtractorOptions.Builder(lang).build());
        HashSet<Integer> tps = new HashSet<>();
        ArrayList<Object> list = types.toArrayList();
        for (Object tp : list) {
            Double tpd = (Double) tp;
            Integer tpi = tpd.intValue();
            tps.add(tpi);
        }
        EntityExtractionParams params = new EntityExtractionParams
                .Builder(text)
                .setEntityTypesFilter(tps)
                .build();
        entityExtractor
                .annotate(params)
                .addOnSuccessListener(entityAnnotations -> {
                    WritableArray annots = Arguments.createArray();
                    for (EntityAnnotation entityAnnotation : entityAnnotations) {
                        String annotatedText = entityAnnotation.getAnnotatedText();
                        WritableMap annomap = Arguments.createMap();
                        annomap.putString("annotation", annotatedText);

                        WritableArray annoarr = Arguments.createArray();
                        for (Entity entity : entityAnnotation.getEntities()) {
                            annomap.putInt("type",entity.getType());
                            switch (entity.getType()) {
                                case Entity.TYPE_ADDRESS:
                                    break;
                                case Entity.TYPE_DATE_TIME:
                                    WritableMap dateTimeMap = Arguments.createMap();
                                    DateTimeEntity dateTimeEntity = entity.asDateTimeEntity();
                                    if(dateTimeEntity == null) break;
                                    dateTimeMap.putInt("granularity", dateTimeEntity.getDateTimeGranularity());
                                    dateTimeMap.putDouble("timestamp", dateTimeEntity.getTimestampMillis());
                                    annoarr.pushMap(dateTimeMap);
                                    break;
                                case Entity.TYPE_EMAIL:
                                    break;
                                case Entity.TYPE_FLIGHT_NUMBER:
                                    WritableMap flightNumberMap = Arguments.createMap();
                                    FlightNumberEntity flightNumberEntity = entity.asFlightNumberEntity();
                                    if(flightNumberEntity == null) break;
                                    flightNumberMap.putString("ariline_code", flightNumberEntity.getAirlineCode());
                                    flightNumberMap.putString("flight_number", flightNumberEntity.getFlightNumber());
                                    annoarr.pushMap(flightNumberMap);
                                    break;
                                case Entity.TYPE_IBAN:
                                    WritableMap ibanMap = Arguments.createMap();
                                    IbanEntity ibanEntity = entity.asIbanEntity();
                                    if(ibanEntity == null) break;
                                    ibanMap.putString("iban",ibanEntity.getIban());
                                    ibanMap.putString("country_code",ibanEntity.getIbanCountryCode());
                                    annoarr.pushMap(ibanMap);
                                case Entity.TYPE_ISBN:
                                    WritableMap isbnMap = Arguments.createMap();
                                    IbanEntity isbnEntity = entity.asIbanEntity();
                                    if(isbnEntity == null) break;
                                    isbnMap.putString("isbn",isbnEntity.getIban());
                                    isbnMap.putString("country_code",isbnEntity.getIbanCountryCode());
                                    annoarr.pushMap(isbnMap);
                                case Entity.TYPE_PAYMENT_CARD:
                                    WritableMap paymentCardMap = Arguments.createMap();
                                    PaymentCardEntity paymentCardEntity = entity.asPaymentCardEntity();
                                    if(paymentCardEntity == null) break;
                                    paymentCardMap.putString("card_number",paymentCardEntity.getPaymentCardNumber());
                                    paymentCardMap.putInt("card_network",paymentCardEntity.getPaymentCardNetwork());
                                    annoarr.pushMap(paymentCardMap);
                                case Entity.TYPE_PHONE:
                                    break;
                                case Entity.TYPE_TRACKING_NUMBER:
                                    WritableMap trackingNumberMap = Arguments.createMap();
                                    TrackingNumberEntity trackingNumberEntity = entity.asTrackingNumberEntity();
                                    if(trackingNumberEntity == null) return;
                                    trackingNumberMap.putString("tracking_number",trackingNumberEntity.getParcelTrackingNumber());
                                    trackingNumberMap.putInt("carrier",trackingNumberEntity.getParcelCarrier());
                                    annoarr.pushMap(trackingNumberMap);
                                case Entity.TYPE_URL:
                                    break;
                                case Entity.TYPE_MONEY:
                                    WritableMap moneyMap = Arguments.createMap();
                                    MoneyEntity moneyEntity = entity.asMoneyEntity();
                                    if(moneyEntity == null) break;
                                    moneyMap.putString("currency", moneyEntity.getUnnormalizedCurrency());
                                    moneyMap.putInt("integer_part", moneyEntity.getIntegerPart());
                                    moneyMap.putInt("fractional_part", moneyEntity.getFractionalPart());
                                    annoarr.pushMap(moneyMap);
                                    break;
                                default:
                                    break;
                            }
                        }
                        if(annoarr.size() > 0) {
                            annomap.putArray("entities",annoarr);
                        }
                        annots.pushMap(annomap);
                    }
                    successCallback.invoke(annots);
                })
                .addOnFailureListener(e -> {
                    failCallback.invoke(e.getLocalizedMessage());
                });
    }

    @ReactMethod
    public void isModelDownloaded(String lang, Callback callback) {
        EntityExtractionRemoteModel model = new EntityExtractionRemoteModel.Builder(EntityExtractorOptions.ENGLISH).build();
        RemoteModelManager modelManager = RemoteModelManager.getInstance();
        modelManager.isModelDownloaded(model)
                .addOnSuccessListener(callback::invoke);
    }

    @ReactMethod
    void deleteDownloadedModel(String lang, Callback successCallback, Callback failCallback) {
        RemoteModelManager modelManager = RemoteModelManager.getInstance();
        EntityExtractionRemoteModel lm = new EntityExtractionRemoteModel
                .Builder(lang)
                .build();
        modelManager.isModelDownloaded(lm)
                .addOnSuccessListener(v -> {
                    if (v) {
                        modelManager.deleteDownloadedModel(lm)
                                .addOnSuccessListener(output -> {
                                    successCallback.invoke("success");
                                })
                                .addOnFailureListener(e -> {
                                    failCallback.invoke(e.getLocalizedMessage());
                                });
                    }
                })
                .addOnFailureListener(e -> {
                    failCallback.invoke(e.getLocalizedMessage());
                });
    }

    @ReactMethod
    void downloadModel(String lang, Callback successCallback, Callback failCallback) {
        RemoteModelManager modelManager = RemoteModelManager.getInstance();
        EntityExtractionRemoteModel lm = new EntityExtractionRemoteModel
                .Builder(lang)
                .build();
        modelManager.download(lm, new DownloadConditions.Builder().requireWifi().build())
                .addOnSuccessListener(v -> {
                    successCallback.invoke("success");
                })
                .addOnFailureListener(e -> {
                    failCallback.invoke(e.getLocalizedMessage());
                });
    }
}
