import React, { useState } from 'react';
import { View, Text, Pressable, Modal, SafeAreaView, FlatList, Alert } from 'react-native';

import MLKitEntityExtraction, { ENTITY_LANG_TAGS, ENTITY_TYPES } from './MLKitEntityExtraction';

const App = (props) => {

	const text = "My flight is LX373, please pick me up at 8am tomorrow. You can look up at http://github.com";

	const [targetLanguage, setTargetLanguage] = useState(ENTITY_LANG_TAGS.ENGLISH);
	const [extractions, setExtractions] = useState([]);

	const annotate = () => {
		MLKitEntityExtraction.isModelDownloaded('ENGLISH').then(v => {
			if (v) {
				//extrac it right now
				MLKitEntityExtraction.annotate(text,'ENGLISH',['TYPE_FLIGHT_NUMBER','TYPE_DATE_TIME','TYPE_URL'])
				.then(v => {
					setExtractions(v);
				})
				.catch(e => {

				})
			}else{
				//download it
				Alert.alert("downloading model now","have to download modle first , then extract text. Downloading ... You will be notified once downloaded")
				MLKitEntityExtraction.downloadModel('ENGLISH').then(rs => {
					Alert.alert("download success","you can extract text right now")
				}).catch(e => {
					Alert.alert("download failed","try it again: "+e)
				})
			}
		})
	}

	return (
		<View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#f8f8fa' }}>
			<Text style={{ color: '#000', fontWeight: 'bold', fontSize: 25 }}>🍻 MLKit 🍻</Text>
			<Text style={{ fontSize: 17, color: '#333', marginTop: 8 }}>☆☆☆Press To Extract Text ☆☆☆</Text>
			<View style={{ paddingVertical: 20 }}>
				<Text style={{ fontSize: 15, color: '#333' }}>Target Language: <Text style={{ color: '#000', fontWeight: "bold" }}>{targetLanguage}</Text></Text>
			</View>
			<View style={{ width: "100%", paddingHorizontal: 20 }}>
			</View>
			<Pressable onPress={annotate} style={{ backgroundColor: '#FFF', borderRadius: 6, paddingHorizontal: 20, paddingVertical: 10, marginTop: 20 }}>
				<Text style={{ color: '#56565a', fontSize: 15 }}>Current Text is : <Text style={{ color: '#000' }}>{text}</Text></Text>
			</Pressable>
			<View style={{ backgroundColor: '#FFF', borderRadius: 6, paddingHorizontal: 20, paddingVertical: 10, marginTop: 20 }}>
				<Text style={{ color: '#56565a', fontSize: 15,marginBottom:15 }}>Extracted Result:</Text>
				{
					extractions.map((item,index) => {
						return (
							<>
							<Text style={{ color: '#555',fontSize:16 }}>anno: {item.annotation}</Text>
							<Text style={{ color: '#555',fontSize:14 }}>type: {item.type}</Text>
							<Text style={{ marginBottom: 12, color: '#555',fontSize:14 }}>entities: {item.entities != undefined ? JSON.stringify(item.entities) : ''}</Text>
							</>
						)
					})
				}
			</View>
		</View>
	)
}
export default App;