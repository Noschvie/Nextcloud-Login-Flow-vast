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
Time >> asStatisticDurationString [
	"
	time as string without leading 00:
	(Time fromSeconds: 111) asStatisticDurationString '01:51'
	"

	| aWriteStream aTimeFormatter |

	aWriteStream := WriteStream on: (String new: TmcsConstants::CONST_8).

	aTimeFormatter :=
		LCTime new
			tFmt: (self hours > 0 ifTrue: [ '%H:%M:%S'. ] ifFalse: [ '%M:%S'. ]);
			yourself.

	aTimeFormatter printTime: self on: aWriteStream.

	^aWriteStream contents
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['Not categorized'] }
Time >> dbRepresentation [
	" "

	^self asMilliseconds printString
]
