#tag Class
Protected Class DCDatabaseStats
Implements DatabaseModule.DataBaseStatsInterface
	#tag Method, Flags = &h0
		Sub Task2Task(d as Dictionary)
		  // Part of the DatabaseModule.DataBaseStatsInterface interface.
		  Instances = d.Lookup("InstanceCount", 0)
		  Series    = d.Lookup("SeriesCount", 0)
		  Studies   = d.Lookup("StudyCount", 0)
		  Patients  = d.Lookup("PatientCount", 0)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Instances As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Patients As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Series As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Studies As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Studies"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Instances"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Patients"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Series"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
