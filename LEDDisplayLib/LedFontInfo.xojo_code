#tag Class
Protected Class LedFontInfo
	#tag Method, Flags = &h0
		Function Bitmap() As Picture
		  Return mBitmap
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(fontName as String, glyphs as String, glyphWidth as Integer, glyphHeight as Integer, fontBitmap as Picture)
		  mName = fontName
		  mGlyphs = glyphs
		  mGlyphWidth = glyphWidth
		  mGlyphHeight = glyphHeight
		  mBitmap = fontBitmap
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GlyphHeight() As Integer
		  Return mGlyphHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Glyphs() As String
		  Return mGlyphs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GlyphWidth() As Integer
		  Return mGlyphWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name() As String
		  Return mName
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBitmap As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGlyphHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGlyphs As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGlyphWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mName As String
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
	#tag EndViewBehavior
End Class
#tag EndClass
