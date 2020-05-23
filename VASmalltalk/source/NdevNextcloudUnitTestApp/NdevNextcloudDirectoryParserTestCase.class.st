Class {
	#name : 'NdevNextcloudDirectoryParserTestCase',
	#superclass : 'TestCase',
	#pools : [
		'CfsConstants'
	],
	#category : 'NdevNextcloudUnitTestApp'
}

{ #category : 'Running' }
NdevNextcloudDirectoryParserTestCase class >> getFilesFromDirectory: aDirectoryName [
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
				myFiles add: aCfsDirectoryEntry.

				"Yield so that any other background processes may have a turn after this binary file."
				"		Processor yield.
"
			].

			myFiles.
		]
]

{ #category : 'Running' }
NdevNextcloudDirectoryParserTestCase class >> getSubDirectoriesFromDirectory: mySourceDirectoryName [
	" "

	| mySourceDirectory aDirectoryCollection |

	aDirectoryCollection := OrderedCollection new.

	mySourceDirectory := (CfsDirectoryDescriptor opendir: mySourceDirectoryName pattern: nil mode: FDIR).

	^mySourceDirectory isCfsError
		ifTrue: [
			self vfDebug: [ 'getSubDirectoriesFromDirectory: error %1' bindWith: mySourceDirectory. ].
			#().
		]
		ifFalse: [
			[
				| aCfsDirectoryEntry |

				[ (aCfsDirectoryEntry := mySourceDirectory readdir) isNil. ] whileFalse: [
					aCfsDirectoryEntry dName first ~~ $.
						ifTrue: [
							self vfDebug: [
								'getSubDirectoriesFromDirectory: aSubDirectory %1' bindWith: aCfsDirectoryEntry.
							].

							aDirectoryCollection add:
								mySourceDirectoryName , CfsDirectoryDescriptor pathSeparatorString ,
									aCfsDirectoryEntry dName.
						].
				].
			]
				ensure: [ mySourceDirectory closedir. ].

			aDirectoryCollection do: [ :aSubDirectory |
				(self getSubDirectoriesFromDirectory: aSubDirectory)
					ifNotNil: [ :aC | aC notEmpty ifTrue: [ aDirectoryCollection addAll: aC. ]. ].
			].

			aDirectoryCollection.
		]
]

{ #category : 'Running' }
NdevNextcloudDirectoryParserTestCase >> testDirectoryParser [
	" [ self new 
	 testDirectoryParser. ] fork. "

	| myNextcloudDirectoryParser mySourceDirectoryName myDestinationDirectoryName aDirectoryCollection
	  aFileCollection |

	mySourceDirectoryName := 'D:\library'.
	mySourceDirectoryName := 'C:\Temp\NeuroLibrary'.
	mySourceDirectoryName := 'C:\Temp\my local library'.
	myDestinationDirectoryName := 'NeuroLibrary'.

	aDirectoryCollection := OrderedCollection new.
	aFileCollection := OrderedCollection new.

	myNextcloudDirectoryParser :=
		NdevNextcloudDirectoryParser new
			sourceBaseDirectory: mySourceDirectoryName;
			destinationBaseDirectory: myDestinationDirectoryName;
			yourself.

	myNextcloudDirectoryParser
		forEachSubFolderDo: [ :aSource :aDestination |
			aDirectoryCollection add: aSource.
			self vfDebug: [ './cloudmanager.sh makeFolder %1' bindWith: aDestination. ].
		]
		andFileDo: [ :aSource :aDestination :aFileName |
			aFileCollection add: aFileName.
			self vfDebug: [
				'./cloudsend.sh send ''%1'' ''%2'''
					bindWith: aSource , '/' , aFileName
					with: aDestination , '/' , aFileName.
			].
		].

	self vfDebug: [
		'testDirectoryParser %1, directories %2, files %3'
			bindWith: myNextcloudDirectoryParser sourceBaseDirectory
			with: aDirectoryCollection size
			with: aFileCollection size.
	].
]
