Extension {
	#name : 'SequenceableCollection'
}

{ #category : '*NdevBaseFramework',
 #vaCategories : ['Not categorized'] }
SequenceableCollection >> segmentsWithSize: segmentSize [
	"Split the collection into segments."

	^(1 to: self size by: segmentSize) collect: [ :fromIndex |
		| toIndex |
		toIndex := (fromIndex + segmentSize - 1) min: self size.

		self copyFrom: fromIndex to: toIndex.
	]
]
