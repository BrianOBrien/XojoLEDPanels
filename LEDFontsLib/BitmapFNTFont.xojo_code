#tag Class
Class BitmapFNTFont
Inherits BitmapFontBase
	#tag Method, Flags = &h0
		Sub AdvanceCharacter()
		  If Message = "" Then Return
		  
		  MessageIndex = MessageIndex + 1
		  If MessageIndex >= Message.Length Then
		    MessageIndex = 0
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClockTick()
		  If Message = "" Then Return
		  
		  ScrollX = ScrollX + 1
		  
		  Var totalWidth As Integer = 0
		  For i As Integer = 0 To Message.Length - 1
		    totalWidth = totalWidth + GlyphAdvance(Message.Middle(i, 1))
		  Next
		  
		  If totalWidth <= 0 Then Return
		  
		  If ScrollX >= totalWidth Then
		    ScrollX = 0
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CurrentCharacter() As String
		  If Message = "" Then Return ""
		  If MessageIndex < 0 Then Return ""
		  If MessageIndex >= Message.Length Then Return ""
		  
		  Return Message.Middle(MessageIndex, 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadMessage(value As String)
		  Message = value
		  ResetScroll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetScroll()
		  ScrollX = 0
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Message As String
	#tag EndProperty

	#tag Property, Flags = &h0
		MessageIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ScrollX As Integer
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
			Name="Message"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollX"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MessageIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
