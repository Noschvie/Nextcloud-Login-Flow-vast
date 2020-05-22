Extension {
	#name : 'Block'
}

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> asyncExecInBackgroundNamed: name [
	"Execute this block in a background process (regardless of whether the current process is the UI process or not)."

	^self asyncExecInBackgroundWithPriority: Processor userBackgroundPriority named: name
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> asyncExecInBackgroundWithPriority: aPriority named: name [
	"Execute this block in a background process (regardless of whether the current process is the UI process or not)."

	| theProcess |

	self
		vfDebugIfEnabled: [ 'asyncExecInBackgroundWithPriority:named: %1, %2' bindWith: aPriority with: name. ].

	theProcess := [ self value. ] forkAt: aPriority named: name.

	^theProcess
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> atRuntimeWhen: exception do: handlerBlock [
	"Only add the exception handler during runtime, not during development time."

	^System isRuntime ifTrue: [ self when: exception do: handlerBlock. ] ifFalse: [ self value. ]
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> atRuntimeWhen: exception1 do: block1 when: exception2 do: block2 [
	"Only add the exception handler during runtime, not during development time."

	^System isRuntime
		ifTrue: [ self when: exception1 do: block1 when: exception2 do: block2. ]
		ifFalse: [ self value. ]
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> atRuntimeWhenOneOf: exceptionCollection doMatching: blockCollection [
	"Only add the exception handler during runtime, not during development time."

	^System isRuntime
		ifTrue: [ self whenOneOf: exceptionCollection doMatching: blockCollection. ]
		ifFalse: [ self value. ]
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> isInSstDispatchWorkerOrIdleThread [
	" "

	| aProcessName |

	aProcessName := Processor activeProcess processName.

	^(aProcessName startsWith: 'Dispatch worker:') or: [ aProcessName startsWith: 'Idle'. ]
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> syncExecInBackgroundIfInUIOrSstWithName: name [
	"If we are currently in the UI process or in an SST process,
	execute this block synchronously in a background process."

	^self syncExecInBackgroundIfInUIOrSstWithPriority: Processor userBackgroundPriority named: name
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> syncExecInBackgroundIfInUIOrSstWithPriority: aPriority named: name [
	"If we are currently in the UI process or in an SST process,
	execute this block synchronously in a background process."

	^(Processor runningInUI or: [
		| aProcessPriority |
		aProcessPriority := Processor activeProcess priority.

		aPriority ~= aProcessPriority or: [ self isInSstDispatchWorkerOrIdleThread. ].
	])
		ifTrue: [ self syncExecInBackgroundWithPriority: aPriority named: name. ]
		ifFalse: [ self value. ]
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> syncExecInBackgroundNamed: name [
	"Execute this block in a background process (regardless of whether the current process is the UI process or not)."

	^self syncExecInBackgroundWithPriority: Processor userBackgroundPriority named: name
]

{ #category : '*NdevBaseFramework',
 #vaCategories : ['TMCS'] }
Block >> syncExecInBackgroundWithPriority: aPriority named: name [
	"Execute this block in a background process (regardless of whether the current process is the UI process or not)."
	"If it is the UI process, AbtSemaphore>>wait spawns a new UI process so that the UI won't be blocked."

	| semaphore value |

	self vfDebug: [ 'syncExecInBackgroundWithPriority:named: %1, %2' bindWith: aPriority with: name. ].

	semaphore := AbtSemaphore new.

	[
		value := self value.

		semaphore signal.
	]
		forkAt: aPriority
		named: name.

	semaphore wait.

	^value
]
