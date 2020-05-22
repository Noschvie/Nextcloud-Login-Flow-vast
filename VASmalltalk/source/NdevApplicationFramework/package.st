Package {
	#name : 'NdevApplicationFramework',
	#vaPrerequisites : ['AbtThreadsApp','CommonFileSystem'],
	#vaSubApplications : [
	{
		#condition : 'true',
		#subapps : [
			'NdevBaseFramework',
			'NdevLoggingFramework'
		]
	}
]
}
