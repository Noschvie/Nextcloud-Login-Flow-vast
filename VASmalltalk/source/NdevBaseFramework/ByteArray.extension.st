Extension {
	#name : 'ByteArray'
}

{ #category : '*NdevBaseFramework',
 #vaCategories : ['Not categorized'] }
ByteArray >> abtBigEndianUint16At: anInteger [
	"Answers the unsigned 16-bit Integer at byte offset anInteger."

	^((self uint8At: anInteger) bitShift: 8) + (self uint8At: anInteger + 1)
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['Not categorized'] }
ByteArray >> abtBigEndianUint16At: anInteger put: newValue [
	"Set the unsigned 16-bit Integer at byte offset anInteger to newValue."

	| lo hi val |

	val := newValue < 0 ifTrue: [ newValue + 16r10000. ] ifFalse: [ newValue. ].
	lo := val bitAnd: 16rFF.
	hi := val bitShift: -8.
	self
		uint8At: anInteger put: hi;
		uint8At: anInteger + 1 put: lo;
		yourself.

	^newValue
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['Not categorized'] }
ByteArray >> asHexString [
	" "
	| s |

	s := WriteStream on: String new.

	s nextPut: $[.
	self do: [ :byte | byte printOn: s base: TmcsConstants::CONST_16 showRadix: false. ] separatedBy: [
		s space.
	].
	s nextPut: $].

	^s contents
]
