Extension {
	#name : 'AbtTimestamp'
}

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
AbtTimestamp >> printStringUsingFormatter: aFormatter [
	" "

	| stream |

	stream := WriteStream on: String new.

	aFormatter printDate: self date time: self time on: stream.
	stream nextPut: $..
	self time milliseconds printOn: stream base: 10 showRadix: false padTo: 3 with: $0.

	^stream contents
]
