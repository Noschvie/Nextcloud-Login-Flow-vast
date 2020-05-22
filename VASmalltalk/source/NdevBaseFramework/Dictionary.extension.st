Extension {
	#name : 'Dictionary'
}

{ #category : '*NdevBaseFramework',
 #vaCategories : ['Not categorized'] }
Dictionary >> at: aKey ifAbsentPutSafely: aBlock [
	"A variant of at:ifAbsentPut: where it is safe to manipulate the same dictionary within aBlock."

	self at: aKey ifPresent: [ :value | ^value ].

	^self at: aKey put: aBlock value
]
