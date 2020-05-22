Class {
	#name : 'NdevApplicationFramework',
	#superclass : 'Application',
	#category : 'Ndev Application Framework'
}

{ #category : '-',
 #vaCategories : ['-','AbtEdit','AutoGen'],
  #vaVisibility : 'private' }
NdevApplicationFramework class >> abtIsViewApplication [

	^true
]

{ #category : 'Tonel' }
NdevApplicationFramework class >> tonelPackageName [
	"Issue9464"

	^'Ndev Application Framework'
]
