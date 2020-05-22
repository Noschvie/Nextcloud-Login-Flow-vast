Package {
	#name : 'NdevUnitTestFramework',
	#vaPrerequisites : ['EsIpHelper','NdevFramework','SUnit'],
	#vaSubApplications : [
	{
		#condition : 'true',
		#subapps : [
			'NdevNextcloudUnitTestApp'
		]
	}
]
}
