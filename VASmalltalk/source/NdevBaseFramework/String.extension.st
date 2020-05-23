Extension {
	#name : 'String'
}

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> centerIn: newStringLength [
	"Answer a copy of the receiver, padded with spaces on both
	 sides so as to center the contents of the receiver in a string of given
	 length. Answer a truncated version of the receiver if it is longer than
	 the newStringLength."

	^self centerIn: newStringLength padWith: Space
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> centerIn: newStringLength padWith: aCharacter [
	"Answer a copy of the receiver, padded with the given character on both
	 sides so as to center the contents of the receiver in a string of given
	 length. Answer a truncated version of the receiver if it is longer than
	 the newStringLength."

	| delta padSize |

	delta := newStringLength - self size.
	delta > 0 ifFalse: [ ^self copyFrom: 1 to: newStringLength ].

	padSize := (delta / 2) rounded.

	^(WriteStream on: (self class new: newStringLength))
		next: padSize put: aCharacter;
		nextPutAll: self;
		next: newStringLength - padSize - self size put: aCharacter;

		contents
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> endsWith: aString [
	" "

	^(self right: aString size) = aString
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> extractOption: anOptionName [
	" "

	| leftSide |

	leftSide := '-' , anOptionName , '='.

	^(leftSide substr: self at: 1) ifTrue: [ self right: (self size - leftSide size). ]
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> isDigit [
	"Return true if the string contains decimal only characters and false otherwise"

	self do: [ :ch | ch isDigit ifFalse: [ ^false ]. ].
	^true
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> isHexaDecimal [
	"Return true if the string contains hexadecimal only characters and false otherwise"

	self do: [ :ch | ch isHexDigit ifFalse: [ ^false ]. ].
	^true
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> left: anInteger [
	"
		answer the left part of a string
	"

	^self copyFrom: 1 to: (anInteger min: self size)
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> leftJustifyIn: anInteger [
	" "

	^self leftJustifyIn: anInteger padWith: Space
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> leftJustifyIn: anInteger padWith: aCharacter [
	" "

	^anInteger <= self size
		ifTrue: [ self copyFrom: 1 to: anInteger. ]
		ifFalse: [
			(WriteStream on: (self class new: anInteger))
				nextPutAll: self;
				next: anInteger - self size put: aCharacter;
				contents.
		]
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> right: anInteger [
	"
		Answer the right part of a string
	"

	^self copyFrom: ((self size - anInteger + 1) max: 1) to: self size
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> rightJustifyIn: newStringLength [
	"<newStringLength: hOf Integer, ^hOf myClass>"
	"Answer a copy of the receiver, padded with spaces on the left
	 side so as to right justify the contents of the receiver in a string of given
	 length. Answer a truncated version of the receiver if it is longer than
	 the newStringLength."

	^self rightJustifyIn: newStringLength padWith: Space
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> rightJustifyIn: newStringLength padWith: aCharacter [
	"Answer a copy of the receiver, padded with the given character on the left
	 side so as to right justify the contents of the receiver in a string of given
	 length. Answer a truncated version (truncation on the left) of the receiver if
	 it is longer than the newStringLength."

	| delta |

	delta := newStringLength - self size.
	delta > 0 ifFalse: [ ^self copyFrom: 1 - delta to: self size ].

	^(WriteStream on: (self class new: newStringLength))
		next: delta put: aCharacter;
		nextPutAll: self;

		contents
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> startsWith: aString [
	" "

	^(self left: aString size) = aString
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> substr: aString [
	"
		Answer the first position of aString in the receiver or zero if aString canït be found in the receiver.
		'123::abc' substr: '::' returns 4
		'123::abc' substr: ':!' returns 0

	"

	^self indexOfSubCollection: aString startingAt: 1
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> substr: aString at: position [
	"Answer whether the receiver occurs as a sub-string in
	 aString at position. The comparison is case sensitive.
	"
	| size offset |

	position <= 0 ifTrue: [ ^false ].
	(size := self size) > (aString size - (offset := position - 1)) ifTrue: [ ^false ].
	[ :char :index | char = (aString at: index) ifFalse: [ ^false ]. ]
		applyWithIndex: self
		from: 1
		to: size
		offset: offset.
	^true
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> substr: aString startingAt: anInteger [
	"
		Answer the first position of aString, starting at startingAt: ,  in the receiver or zero if aString canït be found in the receiver.
		'123::abc' substr: '::' returns 4
		'123::abc' substr: ':!' returns 0
	"

	^self indexOfSubCollection: aString startingAt: anInteger
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
String >> trimTrailingBlanks [
	"Answer a String containing the receiver string with trailing blanks removed."

	| start end done |

	start := 1.
	(end := self size) == 0 ifTrue: [ ^self ].
	done := false.

	[ (self at: end) ~~ Space or: [ done := start == end. ]. ] whileFalse: [ end := end - 1. ].

	^done ifTrue: [ ''. ] ifFalse: [ self copyFrom: start to: end. ]
]
