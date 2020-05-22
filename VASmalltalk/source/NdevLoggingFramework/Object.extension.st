Extension {
	#name : 'Object'
}

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object class >> buildCompleteMessageStringFor: aString class: aClass [
	" "

	| stream |

	stream := WriteStream on: String new.

	self printProcess: Processor activeProcess on: stream.

	stream nextPut: $ .

	aClass printOn: stream.
	^stream
		nextPutAll: '>>';
		nextPutAll: aString;

		contents
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object class >> isDebugEnabled [
	" "

	^(Smalltalk classAt: #VaIniFileReader)
		ifNotNil: [ :aVaIniFileReaderClass | aVaIniFileReaderClass isDebugEnabledForClass: self. ]
		ifNil: [ false. ]
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object class >> isDebugEnabledFor: aSymbol [
	" "

	^(Smalltalk classAt: #VaIniFileReader)
		ifNotNil: [ :aVaIniFileReaderClass | aVaIniFileReaderClass isDebugEnabledFor: aSymbol. ]
		ifNil: [ false. ]
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object class >> logMessage: aStringOrBlock class: aClass shouldLog: aBlock [
	" "

	| shouldLog msg |

	shouldLog := aBlock value.

	msg :=
		aStringOrBlock isString
			ifTrue: [ aStringOrBlock. ]
			ifFalse: [
				"It's a block."
				"Evaluate it in the development environment to make sure it runs error-free."

				(shouldLog or: [ System isRuntime not. ]) ifTrue: [ aStringOrBlock value. ].
			].

	shouldLog
		ifTrue: [
			(Smalltalk at: #TmcsApplicationLoggerAgent ifAbsent: [ nil. ]) ifNotNil: [ :anApplicationLoggerAgent |
				anApplicationLoggerAgent logMessage: (self buildCompleteMessageStringFor: msg class: aClass).
			].
		].
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object class >> printProcess: aProcess on: stream [
	" "

	stream nextPut: $(.

	aProcess priority printOn: stream.

	aProcess abtIsUIProcess ifTrue: [ stream nextPutAll: ', UI'. ].

	stream
		nextPutAll: ', ';
		nextPutAll: aProcess processName;
		nextPut: $).
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object class >> vfDebug: aStringOrBlock [
	" "

	self logMessage: aStringOrBlock class: self class shouldLog: [ true. ].
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object class >> vfDebug: aStringOrBlock ifEnabledFor: aSymbol [
	" "

	self logMessage: aStringOrBlock class: self class shouldLog: [ self isDebugEnabledFor: aSymbol. ].
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object class >> vfDebugIfEnabled: aStringOrBlock [
	" "

	self logMessage: aStringOrBlock class: self class shouldLog: [ self isDebugEnabled. ].
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object >> vfDebug: aStringOrBlock [
	" "

	self class logMessage: aStringOrBlock class: self class shouldLog: [ true. ].
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object >> vfDebug: aStringOrBlock ifEnabledFor: aSymbol [
	" "

	self class
		logMessage: aStringOrBlock
		class: self class
		shouldLog: [ self class isDebugEnabledFor: aSymbol. ].
]

{ #category : '*NdevLoggingFramework',
 #vaCategories : ['TMCS Logging'] }
Object >> vfDebugIfEnabled: aStringOrBlock [
	" "

	self class logMessage: aStringOrBlock class: self class shouldLog: [ self class isDebugEnabled. ].
]
