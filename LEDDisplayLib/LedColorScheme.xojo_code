#tag Class
Protected Class LedColorScheme
	#tag Method, Flags = &h0
		Sub Constructor()
		  OffColor = &c000000
		  DimColor = &c7F0000
		  BrightColor = &cFF0000
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(offC As Color, dimC As Color, brightC As Color)
		  Self.OffColor = offC
		  Self.DimColor = dimC
		  Self.BrightColor = brightC
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromBaseColor(base As Color) As LedColorScheme
		  Var offR As Integer = base.Red * 0.10
		  Var offG As Integer = base.Green * 0.10
		  Var offB As Integer = base.Blue * 0.10
		  
		  Var dimR As Integer = base.Red * 0.55
		  Var dimG As Integer = base.Green * 0.55
		  Var dimB As Integer = base.Blue * 0.55
		  
		  Var brightR As Integer = base.Red + ((255 - base.Red) * 0.35)
		  Var brightG As Integer = base.Green + ((255 - base.Green) * 0.35)
		  Var brightB As Integer = base.Blue + ((255 - base.Blue) * 0.35)
		  
		  Return New LedColorScheme( _
		  Color.RGB(offR, offG, offB), _
		  Color.RGB(dimR, dimG, dimB), _
		  Color.RGB(brightR, brightG, brightB) _
		  )
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		BrightColor As Color = &cFF0000
	#tag EndProperty

	#tag Property, Flags = &h0
		DimColor As Color = &c7F0000
	#tag EndProperty

	#tag Property, Flags = &h0
		OffColor As Color = &c000000
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
			Name="OffColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DimColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c7F0000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BrightColor"
			Visible=false
			Group="Behavior"
			InitialValue="&cFF0000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
