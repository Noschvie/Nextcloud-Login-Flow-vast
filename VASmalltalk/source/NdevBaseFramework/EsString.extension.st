Extension {
	#name : 'EsString'
}

{ #category : '*NdevBaseFramework',
 #vaCategories : ['Not categorized'] }
EsString >> bindWithHexArguments: anArrayOfArguments [
	"Answer the string formatted under the control of the receiver.  The receiver
	 is a character string patterned after the formatting conventions of printf() and 
	 contains field descriptors used to insert arguments into the format string. 

	 Each conversion specification is introduced by the percent character ($%). 
	 After the $% character, the following can appear in the sequence indicated:

		[1-9, A-F]
			Specifies the argument string to be used in place of the field descriptor.
					e.g.	(anArrayOfArguments at: 1) replaces all occurances of %1.
							.
							.
							.
							(anArrayOfArguments at: 9) replaces all occurances of %9.
							(anArrayOfArguments at: 10) replaces all occurances of %A or %a.
							.
							.
							.
							(anArrayOfArguments at: 15) replaces all occurances of %F or %f.

		[%]	
			Print a $% character; no argument is converted.
			
	Error cases handled:
		1. Argument array is too small -- attempt recovery
		2. Replacement value is not a string or a character -- attempt recovery
		3. Malformed message string -- signal error"

	| index aChar output argNumber arg cachedSize newIndex argsSize |

	"Use the fast indexOf: primitive"

	(index := self indexOf: $% startingAt: 1) == 0 ifTrue: [ ^self ].

	cachedSize := self size.
	argsSize := anArrayOfArguments size.

	output := WriteStream on: (Locale current preferredStringClass new: cachedSize).
	output nextPutAll: (self copyFrom: 1 to: index - 1).

	[ index <= cachedSize. ] whileTrue: [
		index = cachedSize ifTrue: [
			"Unterminated field delimiter"
			ExCLDTInvalidArgument signalWith: 1.
		].

		(aChar := self at: index + 1) isHexDigit
			ifTrue: [
				"In-line the conversion for speed"
				aChar isDigit
					ifTrue: [ argNumber := aChar value - $0 value. ]
					ifFalse: [ argNumber := aChar asUppercase value - $A value + 10. ].

				argNumber > 0
					ifTrue: [
						argNumber > argsSize
							ifTrue: [ self bindErrorNotEnoughArguments: argNumber on: output. ]
							ifFalse: [
								(arg := anArrayOfArguments at: argNumber) isCharacter
									ifTrue: [ output nextPut: arg. ]
									ifFalse: [
										arg isString
											ifTrue: [ output nextPutAll: arg. ]
											ifFalse: [ self bindErrorBadArgumentType: arg on: output. ].
									].
							].
					]
					ifFalse: [ output nextPutAll: LineDelimiter. ].
			]
			ifFalse: [
				aChar == $%
					ifTrue: [ output nextPut: aChar. ]
					ifFalse: [
						"Unknown field delimiter"
						ExCLDTInvalidArgument signalWith: 1.
					].
			].

		"Advance past last token."
		index := index + 2.

		(newIndex := self indexOf: $% startingAt: index) == 0
			ifTrue: [
				output nextPutAll: (self copyFrom: index to: cachedSize).
				^output contents asReducedString
			]
			ifFalse: [
				output nextPutAll: (self copyFrom: index to: newIndex - 1).
				index := newIndex.
			].
	].

	^output contents asReducedString
]
