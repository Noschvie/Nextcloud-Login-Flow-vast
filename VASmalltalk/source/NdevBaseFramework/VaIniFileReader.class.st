Class {
	#name : 'VaIniFileReader',
	#superclass : 'Object',
	#instVars : [
		'entriesDictionary',
		'iniFileName',
		'replacementDictionary',
		'classesDebugEnabledDictionary',
		'areAllDebugsEnabled'
	],
	#classVars : [
		'DefaultReader'
	],
	#category : 'NdevBaseFramework'
}

{ #category : 'Initialize' }
VaIniFileReader class >> cleanupPart [
	" "

	self defaultReader notNil
		ifTrue: [
			self defaultReader cleanupPart.
			self defaultReader: nil.
		].
]

{ #category : 'Debug enabled' }
VaIniFileReader class >> computeIsDebugEnabledForClass: aClass [
	" "

	aClass
		withAllSuperclassesDo: [ :aLocalClass | (self isDebugEnabledFor: aLocalClass name) ifTrue: [ ^true ]. ].

	^false
]

{ #category : 'Constants' }
VaIniFileReader class >> debugPrefix [
	" "

	^'DEBUG_'
]

{ #category : 'Accessors' }
VaIniFileReader class >> defaultReader [
	" "
	
	^DefaultReader
]

{ #category : 'Accessors' }
VaIniFileReader class >> defaultReader: aDefaultReader [
	" "

	DefaultReader := aDefaultReader.
]

{ #category : 'Public' }
VaIniFileReader class >> getApplicationDirectory [
	"Issue8780"

	^self getEntryFor: 'path_Application'
]

{ #category : 'Public' }
VaIniFileReader class >> getBooleanEntryFor: aString [
	" "

	^self getBooleanEntryFor: aString ifAbsent: [ true. ]
]

{ #category : 'Public' }
VaIniFileReader class >> getBooleanEntryFor: aString ifAbsent: anAbsentBlock [
	"Issue6076: Detect boolean values on parsing."

	^self
		getEntryFor: aString
		ifPresent: [ :aValue |
			aValue isBoolean
				ifTrue: [ aValue. ]
				ifFalse: [
					self vfDebug: [
						'getBooleanEntryFor:ifAbsent: expected a boolean value, got "%1"' bindWith: aValue.
					].
					false.
				].
		]
		ifAbsent: anAbsentBlock
]

{ #category : 'Public' }
VaIniFileReader class >> getEntryFor: aString [
	"Entry in configuration file for key aString"

	^aString isNil
		ifTrue: [
			self vfDebug: [ 'getEntryFor: aString isNil!'. ].
			nil.
		]
		ifFalse: [ self getEntryFor: aString ifPresent: [ :aValue | aValue. ] ifAbsent: [ nil. ]. ]
]

{ #category : 'Public' }
VaIniFileReader class >> getEntryFor: aString ifAbsentOrNil: anAbsentBlock [
	"Entry in configuration file for key aString"

	^self
		getEntryFor: aString
		ifPresent: [ :aValue | aValue ifNil: anAbsentBlock ifNotNil: [ aValue. ]. ]
		ifAbsent: [
			aString isNil ifTrue: [ self vfDebug: [ 'getEntryFor:ifAbsent: aString isNil!'. ]. ].
			anAbsentBlock value.
		]
]

{ #category : 'Public' }
VaIniFileReader class >> getEntryFor: aString ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	" "

	^self defaultReader
		ifNotNil: [ :aReader |
			| aValue |
			aValue := aReader entriesDictionary at: aString asUppercase ifAbsent: [ nil. ].

			aValue isNil ifTrue: [ anAbsentBlock value. ] ifFalse: [ aPresentBlock value: aValue. ].
		]
		ifNil: anAbsentBlock
]

{ #category : 'Public' }
VaIniFileReader class >> getIntegerEntryFor: aString ifAbsent: anAbsentBlock [
	" "

	^self getEntryFor: aString ifPresent: [ :aValue | aValue asNumber asInteger. ] ifAbsent: anAbsentBlock
]

{ #category : 'Debug enabled' }
VaIniFileReader class >> isDebugEnabledFor: aStringOrSymbol [
	"Make sure the '#' is not included."

	^self defaultReader
		ifNotNil: [ :aReader |
			aReader areAllDebugsEnabled or: [
				self getBooleanEntryFor: self debugPrefix , aStringOrSymbol asString ifAbsent: [ false. ].
			].
		]
		ifNil: [ false. ]
]

{ #category : 'Debug enabled' }
VaIniFileReader class >> isDebugEnabledForClass: aClass [
	" "

	^self defaultReader
		ifNotNil: [ :aReader |
			[
				aReader classesDebugEnabledDictionary
					at: aClass name
					ifAbsentPut: [ self computeIsDebugEnabledForClass: aClass. ].
			]
				critical.
		]
		ifNil: [ false. ]
]

{ #category : 'Initialize' }
VaIniFileReader class >> withFileName: aFileName replacements: aBlock [
	"Fetch all entries from INI-File into the entries dictionary
	and perform the replacements specified in aBlock value."

	self
		defaultReader: (
			self new
				initialize;
				yourself);
		yourself.

	self defaultReader
		initWithFileName: aFileName replacements: aBlock;
		yourself.

	self
		defaultReader: (self defaultReader entriesDictionary ifNotNil: [ self defaultReader. ] ifNil: [ nil. ]).

	^self defaultReader notNil
]

{ #category : 'Accessors' }
VaIniFileReader >> areAllDebugsEnabled [
	"Return the value of areAllDebugsEnabled."

	^areAllDebugsEnabled
]

{ #category : 'Accessors' }
VaIniFileReader >> areAllDebugsEnabled: aBoolean [
	"Save the value of areAllDebugsEnabled."

	areAllDebugsEnabled := aBoolean.
]

{ #category : 'Accessors' }
VaIniFileReader >> classesDebugEnabledDictionary [
	"Return the value of classesDebugEnabledDictionary."

	^classesDebugEnabledDictionary
]

{ #category : 'Accessors' }
VaIniFileReader >> classesDebugEnabledDictionary: aDictionary [
	"Save the value of classesDebugEnabledDictionary."

	classesDebugEnabledDictionary := aDictionary.
]

{ #category : 'Initialize' }
VaIniFileReader >> cleanupPart [
	" "

	self
		iniFileName: nil;
		entriesDictionary: nil;
		classesDebugEnabledDictionary: nil;
		yourself.
]

{ #category : 'Accessors' }
VaIniFileReader >> entriesDictionary [
	"Return the value of entriesDictionary."

	^entriesDictionary
]

{ #category : 'Accessors' }
VaIniFileReader >> entriesDictionary: aDictionary [
	"Save the value of entriesDictionary."

	entriesDictionary := aDictionary.
]

{ #category : 'Entries' }
VaIniFileReader >> entriesDo: aTwoArgumentBlock [
	" "

	self entriesDictionary keysAndValuesDo: aTwoArgumentBlock.
]

{ #category : 'Accessors' }
VaIniFileReader >> iniFileName [
	"Return the value of iniFileName."

	^iniFileName
]

{ #category : 'Accessors' }
VaIniFileReader >> iniFileName: aString [
	"Save the value of iniFileName."

	iniFileName := aString.
]

{ #category : 'Initialize' }
VaIniFileReader >> initialize [
	" "

	super initialize.

	self
		areAllDebugsEnabled: false;
		entriesDictionary: Dictionary new;
		classesDebugEnabledDictionary: Dictionary new;
		yourself.
]

{ #category : 'Initialize' }
VaIniFileReader >> initWithFileName: aFileName replacements: aBlock [
	"Fetch all entries from INI-File into the entries dictionary
	and perform the replacements specified in aBlock value."

	| myConfigurationEntries |

	self
		iniFileName: aFileName;
		yourself.

	myConfigurationEntries :=
		(NdevConfigurationFileParser withFileNamed: self iniFileName) getConfigurationEntries.

	myConfigurationEntries ifNotNil: [ :anEntriesDictionary |
		| aLocalEntriesDictionary |

		self replacementDictionary: aBlock value.

		aLocalEntriesDictionary := self performReplacementsInDictionary: anEntriesDictionary.

		self
			entriesDictionary: aLocalEntriesDictionary;

			areAllDebugsEnabled: (self class isDebugEnabledFor: 'ALL_CLASSES');
			yourself.
	].
]

{ #category : 'Replacement dictionary' }
VaIniFileReader >> performReplacementsInDictionary: aDictionary [
	"Perform the replacements specified by the replacement dictionary in aDictionary."

	^aDictionary collect: [ :aValue |
		aValue isString ifTrue: [ self performReplacementsInString: aValue. ] ifFalse: [ aValue. ].
	]
]

{ #category : 'Replacement dictionary' }
VaIniFileReader >> performReplacementsInString: aString [
	"Perform the replacements specified by the replacement dictionary in aString."

	| s |

	s := aString.

	self replacementDictionary keysAndValuesDo: [ :aKey :aValue | s := s copyReplaceAll: aKey with: aValue. ].

	^s
]

{ #category : 'Initialize' }
VaIniFileReader >> reloadDebugEntries [
	" "

	| aConfigurationFileParser |

	aConfigurationFileParser := NdevConfigurationFileParser withFileNamed: self iniFileName.

	aConfigurationFileParser iniDic ifNotNil: [ :anEntriesDictionary |
		(self performReplacementsInDictionary: anEntriesDictionary) ifNotNil: [ :aDictionary |
			aDictionary keysAndValuesDo: [ :aKey :aValue |
				| aPrefix |
				aPrefix := self class debugPrefix.

				(aKey left: aPrefix size) = aPrefix ifTrue: [ self entriesDictionary at: aKey put: aValue. ].
			].
		].
	].
]

{ #category : 'Accessors' }
VaIniFileReader >> replacementDictionary [
	"Return the value of replacementDictionary."

	^replacementDictionary
]

{ #category : 'Accessors' }
VaIniFileReader >> replacementDictionary: aDictionary [
	"Save the value of replacementDictionary."

	replacementDictionary := aDictionary.
]
