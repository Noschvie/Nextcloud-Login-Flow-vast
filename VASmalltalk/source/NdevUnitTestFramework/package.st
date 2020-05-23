Package {
	#name : 'NdevUnitTestFramework',
	#vaPrerequisites : ['NdevFramework','SUnit'],
	#vaSubApplications : [
	{
		#condition : 'true',
		#subapps : [
			'NdevNextcloudUnitTestApp'
		]
	}
]
}
