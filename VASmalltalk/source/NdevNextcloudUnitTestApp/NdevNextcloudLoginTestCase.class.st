Class {
	#name : 'NdevNextcloudLoginTestCase',
	#superclass : 'TestCase',
	#category : 'NdevNextcloudUnitTestApp'
}

{ #category : 'Running' }
NdevNextcloudLoginTestCase >> testLogin [
	" "

	| myAgent myResult |


	myAgent := NextcloudLoginFlowAgent withUrl: 'https://nextcloud.myDomain.at' username: 'myUsername'.
	self assert: (myAgent notNil).

	myResult := myAgent performLogin.
	self assert: (myResult notNil).

	myResult ifNotNil: [ :aNeoJSONObject |
		| aLoginName |
		aLoginName := aNeoJSONObject at: #login.

		(aNeoJSONObject at: #poll) ifNotNil: [ :aPollObject |
			| anEndpoint aToken |
			anEndpoint := aPollObject at: #endpoint.
			aToken := aPollObject at: #token.

			self vfDebug: [ 'testLogin aLoginName %1, anEndpoint %2' bindWith: aLoginName with: anEndpoint. ].
			self vfDebug: [ 'testLogin aLoginName aToken %1' bindWith: aToken. ].

			myAgent appPassword: aToken.

			[
				"Execute browser for aLoginName"
				"firefox -new-window URL"
				AbtHTMLHelpAccessor helpFromURL: aLoginName.

				myAgent performPollingEndpointUntilOk ifNotNil: [ :aNcAuthenticationObject |
					| aServer myLoginName anAppPassword |

					aServer := aNcAuthenticationObject at: #server.
					myLoginName := aNcAuthenticationObject at: #loginName.
					anAppPassword := aNcAuthenticationObject at: #appPassword.

					self vfDebug: [
						'testLogin aServer %1, myLoginName %2, anAppPassword %3'
							bindWith: aServer
							with: myLoginName
							with: anAppPassword.
					].

					myAgent appPassword: anAppPassword.

					"					myResult := myAgent performDeleteAppPassword.

					self vfDebug: [ 'testLogin aServer %1' bindWith: myResult. ].
"
				].
			]
				fork.
		].
	].
]
