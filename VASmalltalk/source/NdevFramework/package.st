Package {
	#name : 'NdevFramework',
	#vaPrerequisites : ['AbtRecordStructureBaseApp','AbtXmlSerializationApp','SstHttpsServerSupport'],
	#vaSubApplications : [
	{
		#condition : 'true',
		#subapps : [
			'NdevNextcloudApplication'
		]
	}
]
}
