#tag Module
Protected Module LedFontCatalog
	#tag Method, Flags = &h0
		Function AvailableFontNames() As String()
		  Var names() As String
		  
		  names.Add("FNT12X14")
		  names.Add("FNT18X21")
		  names.Add("LCD08X13")
		  names.Add("LCD09X13")
		  names.Add("LCD13X20")
		  names.Add("LCD15X24")
		  names.Add("LCD39X51")
		  names.Add("LCD55X81")
		  
		  Return names
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFont(fontName As String) As LedFontInfo
		  Select Case fontName.Uppercase
		    
		  Case "FNT12X14"
		    Return New LedFontInfo( _
		    "FNT12X14", _
		    GlyphMap_FNT12X14, _
		    12, _
		    14, _
		    FNT12X14 _
		    )
		    
		  Case "FNT18X21"
		    Return New LedFontInfo( _
		    "FNT18X21", _
		    GlyphMap_FNT18X21, _
		    18, _
		    21, _
		    FNT18X21 _
		    )
		    
		  Case "LCD08X13"
		    Return New LedFontInfo( _
		    "LCD08X13", _
		    GlyphMap_LCD, _
		    8, _
		    13, _
		    LCD08X13 _
		    )
		    
		  Case "LCD09X13"
		    Return New LedFontInfo( _
		    "LCD09X13", _
		    GlyphMap_LCD, _
		    9, _
		    13, _
		    LCD09X13 _
		    )
		    
		  Case "LCD13X20"
		    Return New LedFontInfo( _
		    "LCD13X20", _
		    GlyphMap_LCD, _
		    13, _
		    20, _
		    LCD13X20 _
		    )
		    
		  Case "LCD15X24"
		    Return New LedFontInfo( _
		    "LCD15X24", _
		    GlyphMap_LCD, _
		    15, _
		    24, _
		    LCD15X24 _
		    )
		    
		  Case "LCD39X51"
		    Return New LedFontInfo( _
		    "LCD39X51", _
		    GlyphMap_LCD, _
		    39, _
		    51, _
		    LCD39X51 _
		    )
		    
		  Case "LCD55X81"
		    Return New LedFontInfo( _
		    "LCD55X81", _
		    GlyphMap_LCD, _
		    55, _
		    81, _
		    LCD55X81 _
		    )
		    
		  Else
		    Return Nil
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GlyphMap_FNT12X14() As String
		  Var s As String = ""
		  Var i As Integer
		  
		  For i = 32 To 127
		    s = s + Chr(i)
		  Next
		  
		  For i = 192 To 255
		    s = s + Chr(i)
		  Next
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GlyphMap_FNT18X21() As String
		  Var s As String = ""
		  Var i As Integer
		  
		  For i = 32 To 95
		    s = s + Chr(i)
		  Next
		  
		  For i = 192 To 223
		    s = s + Chr(i)
		  Next
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GlyphMap_LCD() As String
		  Return " 0123456789|_-:"
		End Function
	#tag EndMethod


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
End Module
#tag EndModule
