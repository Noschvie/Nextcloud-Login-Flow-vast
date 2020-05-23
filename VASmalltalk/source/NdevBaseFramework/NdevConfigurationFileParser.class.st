Class {
	#name : 'NdevConfigurationFileParser',
	#superclass : 'Object',
	#instVars : [
		'iniDic'
	],
	#category : 'NdevBaseFramework'
}

{ #category : 'Instance creation' }
NdevConfigurationFileParser class >> withFileNamed: aFilename [
	" "

	^self new
		initWithFileNamed: aFilename;
		yourself
]

{ #category : 'Parsing' }
NdevConfigurationFileParser >> doReadEntriesWithFileNamed: aFilename [
	" "

	| aStream |

	aStream := CfsReadFileStream open: aFilename.
	aStream isCfsError
		ifTrue: [
			self vfDebug: [ 'doReadEntriesWithFileNamed: %1, error %2' bindWith: aFilename with: aStream. ].
		]
		ifFalse: [
			self vfDebug: [ 'doReadEntriesWithFileNamed: %1' bindWith: aFilename. ].

			aStream isCharacters: true.

			[
				[ aStream atEnd. ] whileFalse: [
					| aString |
					aString := aStream nextLine trimSeparators.

					self parseLine: aString.
				].
			]
				ensure: [ aStream close. ].
		].
]

{ #category : 'Common' }
NdevConfigurationFileParser >> getConfigurationEntries [
	" "

	^self iniDic
]

{ #category : 'Accessors' }
NdevConfigurationFileParser >> iniDic [
	"Return the value of iniDic."

	^iniDic
]

{ #category : 'Accessors' }
NdevConfigurationFileParser >> iniDic: aDictionary [
	"Save the value of iniDic."

	iniDic := aDictionary.
]

{ #category : 'Initialization' }
NdevConfigurationFileParser >> initWithFileNamed: aFilename [
	" "

	self
		iniDic: Dictionary new;

		doReadEntriesWithFileNamed: aFilename;
		yourself.
]

{ #category : 'Parsing' }
NdevConfigurationFileParser >> parseEntry: aString [
	" "

	| index |

	index := aString indexOf: $=.

	index > 0
		ifTrue: [
			| key |
			key := (aString copyFrom: 1 to: index - 1) trimSeparators asUppercase.

			(key allSatisfy: [ :c | c isSeparator not. ])
				ifTrue: [
					| value lowerCaseValue |
					value :=
						index < aString size
							ifTrue: [ (aString copyFrom: index + 1 to: aString size) trimSeparators. ]
							ifFalse: [ ''. ].

					"Issue6076: Detect boolean values."
					lowerCaseValue := value asLowercase.
					(#('true' 'on' 'enabled') includes: lowerCaseValue) ifTrue: [ value := true. ].
					(#('false' 'off' 'disabled') includes: lowerCaseValue) ifTrue: [ value := false. ].

					self iniDic at: key put: value.
				]
				ifFalse: [ self vfDebug: [ 'parseEntry: key "%1" contains separators' bindWith: key. ]. ].
		]
		ifFalse: [ self vfDebug: [ 'parseEntry: could not parse line "%1"' bindWith: aString. ]. ].
]

{ #category : 'Parsing' }
NdevConfigurationFileParser >> parseLine: aString [
	"Return true to continue parsing, false to stop parsing."

	| myLineTokens |

	myLineTokens := aString subStrings.

	(myLineTokens notEmpty and: [
		"Comment"
		| isComment |
		isComment := #('#' ';' 'rem') includes: myLineTokens first asLowercase.

		isComment not.
	])
		and: [
			| isIncludeDirective |
			isIncludeDirective := myLineTokens size = 2 and: [ myLineTokens first = '#include'. ].

			isIncludeDirective
				ifTrue: [ self doReadEntriesWithFileNamed: (myLineTokens at: 2). ]
				ifFalse: [ self parseEntry: aString. ].
		].
]
