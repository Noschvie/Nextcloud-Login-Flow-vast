Extension {
	#name : 'AbtTimestamp'
}

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
AbtTimestamp >> asLogfileString [
	"Format TT.MM.JJJJJ HH:MM:SS"

	| myDate myTime |

	myDate :=
		'%1.%2.%3'
			bindWith: (self date dayOfMonth printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0)
			with: (self date monthIndex printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0)
			with: (self date year printString copyFrom: 1 to: TmcsConstants::CONST_4).

	myTime :=
		'%1:%2:%3'
			bindWith: (self time hours printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0)
			with: (self time minutes printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0)
			with: (self time seconds printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0).

	^myDate , ' ' , myTime
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
AbtTimestamp >> asStatisticString [
	"Format JJJJ-MM-DD HH:MM:SS"

	| myDate myTime |

	myDate :=
		'%1-%2-%3'
			bindWith: (self date year printString copyFrom: 1 to: TmcsConstants::CONST_4)
			with: (self date monthIndex printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0)
			with: (self date dayOfMonth printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0).

	myTime :=
		'%1:%2:%3'
			bindWith: (self time hours printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0)
			with: (self time minutes printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0)
			with: (self time seconds printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0).

	^myDate , ' ' , myTime
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
AbtTimestamp >> asStringForDayKey [
	"Issue8153, Format YYYYMMDD"

	| myDate |

	myDate := self date.

	^'%1%2%3'
		bindWith: (myDate year printString copyFrom: 1 to: TmcsConstants::CONST_4)
		with: (myDate monthIndex printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0)
		with: (myDate dayOfMonth printString rightJustifyIn: TmcsConstants::CONST_2 padWith: $0)
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
AbtTimestamp >> printStringUsingFormatter: aFormatter [
	" "

	| stream |

	stream := WriteStream on: String new.

	aFormatter printDate: self date time: self time on: stream.
	stream nextPut: $..
	self time milliseconds printOn: stream base: TmcsConstants::CONST_10 showRadix: false padTo: TmcsConstants::CONST_3 with: $0.

	^stream contents
]
