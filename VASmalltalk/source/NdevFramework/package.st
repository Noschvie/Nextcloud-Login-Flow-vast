Package {
	#name : 'NdevFramework',
	#vaPrerequisites : ['NdevApplicationFramework','SstHttpsServerSupport'],
	#vaSubApplications : [
	{
		#condition : 'true',
		#subapps : [
			'NdevNextcloudApplication'
		]
	}
]
}
