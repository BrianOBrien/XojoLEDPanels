#tag Class
Class BitmapFontBase
	#tag Method, Flags = &h0
		Function CharIndex(ch As String) As Integer
		  If ch = "" Then Return -1
		  Return Characters.IndexOf(ch)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GlyphAdvance(ch As String) As Integer
		  Return CellWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GlyphPicture(ch As String) As Picture
		  Var idx As Integer = CharIndex(ch)
		  If idx < 0 Then Return Nil
		  Return GlyphPictureByIndex(idx)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GlyphPictureByIndex(index As Integer) As Picture
		  If SourceImage Is Nil Then Return Nil
		  If index < 0 Then Return Nil
		  If index >= CellCount Then Return Nil
		  If CellWidth <= 0 Or CellHeight <= 0 Then Return Nil
		  
		  Var p As New Picture(CellWidth, CellHeight)
		  Var srcX As Integer = index * CellWidth
		  
		  p.Graphics.DrawPicture(SourceImage, 0, 0, CellWidth, CellHeight, srcX, 0, CellWidth, CellHeight)
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Setup(src As Picture, chars As String, cw As Integer, ch As Integer, onCol As Color, offCol As Color, bgCol As Color)
		  SourceImage = src
		  Characters = chars
		  CellWidth = cw
		  CellHeight = ch
		  OnColor = onCol
		  OffColor = offCol
		  BackgroundColor = bgCol
		  
		  If src <> Nil And cw > 0 Then
		    CellCount = src.Width \ cw
		  Else
		    CellCount = 0
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BackgroundColor As Color = &c000000
	#tag EndProperty

	#tag Property, Flags = &h0
		CellCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		CellHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		CellWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Characters As String
	#tag EndProperty

	#tag Property, Flags = &h0
		OffColor As Color = &c330000
	#tag EndProperty

	#tag Property, Flags = &h0
		OnColor As Color = &cFF0000
	#tag EndProperty

	#tag Property, Flags = &h0
		SourceImage As Picture
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
			Name="SourceImage"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Characters"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CellWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CellHeight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CellCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnColor"
			Visible=false
			Group="Behavior"
			InitialValue="&cFF0000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OffColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c330000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
