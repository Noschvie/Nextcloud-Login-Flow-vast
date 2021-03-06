Class {
	#name : 'NdevNextcloudDirectoryParser',
	#superclass : 'Object',
	#instVars : [
		'sourceBaseDirectory',
		'destinationBaseDirectory'
	],
	#pools : [
		'CfsConstants'
	],
	#category : 'NdevNextcloudApplication'
}

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
NdevNextcloudDirectoryParser class >> _PRAGMA_IS_ [

	"%%PRAGMA DECLARE
	(name: IS_NdevNextcloudDirectoryParser isPool: true isConstant: false)
	(pool: IS_NdevNextcloudDirectoryParser declarations: (
		(name: IS_instanceInterfaceSpec isConstant: false)
	))"


]

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
NdevNextcloudDirectoryParser class >> abtPrimFlushInterfaceSpecCache [

	IS_NdevNextcloudDirectoryParser
		associationsDo: [:poolDictionaryAssoc | poolDictionaryAssoc value: nil].
	super abtPrimFlushInterfaceSpecCache
]

{ #category : 'Internal' }
NdevNextcloudDirectoryParser class >> getFilesFromDirectory: aDirectoryName [
	" "

	| aCfsDirectoryDescriptor aCfsDirectoryEntry myFiles |

	myFiles := OrderedCollection new.

	aCfsDirectoryDescriptor := CfsDirectoryDescriptor opendir: aDirectoryName pattern: '*.*' mode: FREG.

	^aCfsDirectoryDescriptor isCfsError
		ifTrue: [
			self vfDebug: [ 'getFilesFromDirectory: error %1' bindWith: aDirectoryName. ].
			#().
		]
		ifFalse: [
			[ (aCfsDirectoryEntry := aCfsDirectoryDescriptor readdir) notNil. ] whileTrue: [
				myFiles add: aCfsDirectoryEntry dName.

				"Yield so that any other background processes may have a turn after this binary file."
				"		Processor yield.
"
			].

			myFiles.
		]
]

{ #category : 'Internal' }
NdevNextcloudDirectoryParser class >> getSubDirectoriesOfDirectory: mySourceDirectoryName [
	" "

	| mySourceDirectory aDirectoryCollection |

	aDirectoryCollection := OrderedCollection new.

	mySourceDirectory := (CfsDirectoryDescriptor opendir: mySourceDirectoryName pattern: nil mode: FDIR).

	^mySourceDirectory isCfsError
		ifTrue: [
			self vfDebug: [ 'getSubDirectoriesOfDirectory: error %1' bindWith: mySourceDirectory. ].
			#().
		]
		ifFalse: [
			[
				| aCfsDirectoryEntry |

				[ (aCfsDirectoryEntry := mySourceDirectory readdir) isNil. ] whileFalse: [
					aCfsDirectoryEntry dName first ~~ $.
						ifTrue: [
							self vfDebugIfEnabled: [
								'getSubDirectoriesOfDirectory: aSubDirectory %1' bindWith: aCfsDirectoryEntry.
							].

							aDirectoryCollection add:
"								mySourceDirectoryName , CfsDirectoryDescriptor pathSeparatorString ,
"									aCfsDirectoryEntry dName.
						].
				].
			]
				ensure: [ mySourceDirectory closedir. ].

			aDirectoryCollection.
		]
]

{ #category : 'IS_generated',
  #vaVisibility : 'private' }
NdevNextcloudDirectoryParser class >> IS_instanceInterfaceSpec [
	"Private - ** Warning ** This method is generated by VisualAge and should not
	be modified or deleted. This method is responsible for returning a featureSpec
	that describes the implementation of a particular feature of the receiver"

	^IS_NdevNextcloudDirectoryParser::IS_instanceInterfaceSpec notNil ifTrue: [IS_NdevNextcloudDirectoryParser::IS_instanceInterfaceSpec]
	ifFalse: [IS_NdevNextcloudDirectoryParser::IS_instanceInterfaceSpec := AbtInterfaceSpec new]
]

{ #category : 'Accessors' }
NdevNextcloudDirectoryParser >> destinationBaseDirectory [
	"Return the value of destinationBaseDirectory."

	^destinationBaseDirectory
]

{ #category : 'Accessors' }
NdevNextcloudDirectoryParser >> destinationBaseDirectory: aString [
	"Save the value of destinationBaseDirectory."

	destinationBaseDirectory := aString
]

{ #category : 'API' }
NdevNextcloudDirectoryParser >> forEachSubFolderDo: aFolderBlock andFileDo: aFileBlock [
	" "

	self
		vfDebug: [
			'forEachSubFolderDo:andFileDo: source ''%1'', destination ''%2'''
				bindWith: self sourceBaseDirectory
				with: self destinationBaseDirectory.
		];

		forEachSubFolderOf: self sourceBaseDirectory
			destinationFolder: self destinationBaseDirectory
			do: [ :aSource :aDestination |
				| aSubDirectoryFileCollection |

				aFolderBlock value: aSource value: aDestination.

				aSubDirectoryFileCollection := self class getFilesFromDirectory: aSource.
				(aSubDirectoryFileCollection notNil and: [ aSubDirectoryFileCollection notEmpty. ])
					ifTrue: [
						aSubDirectoryFileCollection do: [ :aFileName |
							aFileBlock value: aSource value: aDestination value: aFileName.
						].
					].
			];
		yourself.
]

{ #category : 'API' }
NdevNextcloudDirectoryParser >> forEachSubFolderOf: aBaseFolder destinationFolder: aDestinationFolder do: aBlock [
	" "

	| aDirectoryCollection |

	self vfDebugIfEnabled: [
		'forEachSubFolder:ofFolder:do: %1, aSubFolder %2' bindWith: aBaseFolder with: aDestinationFolder.
	].

	aDirectoryCollection := self class getSubDirectoriesOfDirectory: aBaseFolder.

	aDirectoryCollection do: [ :aSubDirectory |
		aBlock
			value: aBaseFolder , CfsDirectoryDescriptor pathSeparatorString , aSubDirectory
			value: aDestinationFolder , '/' , aSubDirectory.

		self
			forEachSubFolderOf: aBaseFolder , CfsDirectoryDescriptor pathSeparatorString , aSubDirectory
			destinationFolder: aDestinationFolder , '/' , aSubDirectory
			do: aBlock.
	].
]

{ #category : 'Accessors' }
NdevNextcloudDirectoryParser >> sourceBaseDirectory [
	"Return the value of sourceBaseDirectory."

	^sourceBaseDirectory
]

{ #category : 'Accessors' }
NdevNextcloudDirectoryParser >> sourceBaseDirectory: aString [
	"Save the value of sourceBaseDirectory."

	sourceBaseDirectory := aString
]
