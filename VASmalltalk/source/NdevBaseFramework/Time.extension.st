Extension {
	#name : 'Time'
}

{ #category : '*NdevBaseFramework',
 #vaCategories : ['Not categorized'] }
Time class >> withDbRepresentation: aString [
	" "

	^self fromMilliseconds: aString asNumber asInteger
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['Not categorized'] }
Time >> dbRepresentation [
	" "

	^self asMilliseconds printString
]
