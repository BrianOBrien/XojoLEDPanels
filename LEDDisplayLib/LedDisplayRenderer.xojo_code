#tag Class
Protected Class LedDisplayRenderer
	#tag Method, Flags = &h0
		Function AvailableFontNames() As String()
		  Var names() As String
		  names.Append("FNT12X14")
		  names.Append("FNT18X21")
		  names.Append("LCD08X13")
		  names.Append("LCD09X13")
		  names.Append("LCD13X20")
		  names.Append("LCD15X24")
		  names.Append("LCD39X51")
		  names.Append("LCD55X81")
		  Return names
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  mBackgroundColor = &c000000
		  mForegroundColor = &c0A84FF
		  mRows = 1
		  mColumns = 16
		  SetFont("FNT18X21")
		  EnsureRowBuffers
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EnsureRowBuffers()
		  Var i As Integer
		  
		  If mRows < 1 Then mRows = 1
		  If mColumns < 1 Then mColumns = 1
		  
		  If mRowBuffers.Ubound < mRows - 1 Then
		    For i = mRowBuffers.Ubound + 1 To mRows - 1
		      mRowBuffers.Append(New LedRowBuffer(mColumns, ""))
		    Next i
		  ElseIf mRowBuffers.Ubound > mRows - 1 Then
		    While mRowBuffers.Ubound > mRows - 1
		      mRowBuffers.RemoveAt(mRowBuffers.Ubound)
		    Wend
		  End If
		  
		  For i = 0 To mRowBuffers.Ubound
		    mRowBuffers(i).DisplayWidth = mColumns
		  Next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FontByName(fontName as String) As LedFontInfo
		  Var i As Integer
		  Var glyphs As String
		  
		  Select Case fontName
		  Case "FNT12X14"
		    glyphs = ""
		    For i = 32 To 127
		      glyphs = glyphs + Chr(i)
		    Next i
		    For i = 192 To 255
		      glyphs = glyphs + Chr(i)
		    Next i
		    Return New LedFontInfo(fontName, glyphs, 12, 14, FNT12X14)
		    
		  Case "FNT18X21"
		    glyphs = ""
		    For i = 32 To 95
		      glyphs = glyphs + Chr(i)
		    Next i
		    For i = 192 To 223
		      glyphs = glyphs + Chr(i)
		    Next i
		    Return New LedFontInfo(fontName, glyphs, 18, 21, FNT18X21)
		    
		  Case "LCD08X13"
		    Return New LedFontInfo(fontName, " 0123456789|_-:", 8, 13, LCD08X13)
		    
		  Case "LCD09X13"
		    Return New LedFontInfo(fontName, " 0123456789|_-:", 9, 13, LCD09X13)
		    
		  Case "LCD13X20"
		    Return New LedFontInfo(fontName, " 0123456789|_-:", 13, 20, LCD13X20)
		    
		  Case "LCD15X24"
		    Return New LedFontInfo(fontName, " 0123456789|_-:", 15, 24, LCD15X24)
		    
		  Case "LCD39X51"
		    Return New LedFontInfo(fontName, " 0123456789|_-:", 39, 51, LCD39X51)
		    
		  Case "LCD55X81"
		    Return New LedFontInfo(fontName, " 0123456789|_-:", 55, 81, LCD55X81)
		    
		  Else
		    Return Nil
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IdealHeight() As Integer
		  If mFontInfo Is Nil Then Return 0
		  Return mRows * mFontInfo.GlyphHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IdealWidth() As Integer
		  If mFontInfo Is Nil Then Return 0
		  Return mColumns * mFontInfo.GlyphWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IndexForGlyph(c as String) As Integer
		  If mFontInfo Is Nil Then Return 0
		  If mFontInfo.Glyphs.Len = 160 Then
		    Return mFontInfo.Glyphs.InStrB(0, c)
		  Else
		    Return mFontInfo.Glyphs.InStr(0, c)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NewPictureRGBA(w as Integer, h as Integer) As Picture
		  #If TargetCocoa Then
		    Return New Picture(w, h)
		  #ElseIf TargetWin32 Then
		    Return New Picture(w, h)
		  #Else
		    Return New Picture(w, h, 32)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Render(g as Graphics)
		  Render(g, g.Width, g.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Render(g as Graphics, availableWidth as Integer, availableHeight as Integer)
		  Var row As Integer
		  Var col As Integer
		  Var sx, sy, dx, dy As Integer
		  Var glyphIndex As Integer
		  Var ch As String
		  Var txt As String
		  Var leds As Picture
		  Var displayWidth As Integer
		  Var displayHeight As Integer
		  Var x As Integer
		  Var y As Integer
		  
		  g.ForeColor = mBackgroundColor
		  g.FillRect(0, 0, availableWidth, availableHeight)
		  
		  If mFontInfo Is Nil Then Return
		  If mFontInfo.Bitmap Is Nil Then Return
		  
		  EnsureRowBuffers
		  
		  displayWidth = mFontInfo.GlyphWidth * mColumns
		  displayHeight = mFontInfo.GlyphHeight * mRows
		  leds = NewPictureRGBA(displayWidth, displayHeight)
		  
		  leds.Graphics.ForeColor = mBackgroundColor
		  leds.Graphics.FillRect(0, 0, displayWidth, displayHeight)
		  
		  For row = 0 To mRows - 1
		    If row <= mRowBuffers.Ubound Then
		      txt = mRowBuffers(row).VisibleText
		      
		      For col = 1 To mColumns
		        ch = txt.Mid(col, 1)
		        glyphIndex = IndexForGlyph(ch)
		        If glyphIndex = 0 Then
		          glyphIndex = IndexForGlyph(" ")
		        End If
		        
		        If glyphIndex > 0 Then
		          sx = (glyphIndex - 1) * mFontInfo.GlyphWidth
		          sy = 0
		          dx = (col - 1) * mFontInfo.GlyphWidth
		          dy = row * mFontInfo.GlyphHeight
		          
		          leds.Graphics.ForeColor = mForegroundColor
		          leds.Graphics.FillRect(dx, dy, mFontInfo.GlyphWidth, mFontInfo.GlyphHeight)
		          
		          leds.Mask.Graphics.DrawPicture(mFontInfo.Bitmap, dx, dy, mFontInfo.GlyphWidth, mFontInfo.GlyphHeight, sx, sy, mFontInfo.GlyphWidth, mFontInfo.GlyphHeight)
		        End If
		      Next col
		    End If
		  Next row
		  
		  x = (availableWidth - displayWidth) / 2
		  y = (availableHeight - displayHeight) / 2
		  g.DrawPicture(leds, x, y)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScrollStep()
		  Var i As Integer
		  EnsureRowBuffers
		  For i = 0 To mRowBuffers.Ubound
		    mRowBuffers(i).ScrollStep
		  Next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFont(fontName as String)
		  Var info As LedFontInfo = FontByName(fontName)
		  If info Is Nil Then
		    Raise New UnsupportedFormatException
		  End If
		  mFontInfo = info
		  mFontName = fontName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetRowText(row as Integer, value as String)
		  EnsureRowBuffers
		  If row < 0 Or row > mRowBuffers.Ubound Then
		    Raise New OutOfBoundsException
		  End If
		  mRowBuffers(row).Message = value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetText(lines() as String)
		  Var i As Integer
		  EnsureRowBuffers
		  For i = 0 To mRows - 1
		    If i <= lines.Ubound Then
		      mRowBuffers(i).Message = lines(i)
		    Else
		      mRowBuffers(i).Message = ""
		    End If
		    mRowBuffers(i).DisplayWidth = mColumns
		    mRowBuffers(i).Reset
		  Next i
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBackgroundColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mBackgroundColor = value
			End Set
		#tag EndSetter
		BackgroundColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mColumns
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mColumns = value
			  EnsureRowBuffers
			End Set
		#tag EndSetter
		Columns As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mFontName
			End Get
		#tag EndGetter
		FontName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mForegroundColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mForegroundColor = value
			End Set
		#tag EndSetter
		ForegroundColor As Color
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBackgroundColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mColumns As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontInfo As LedFontInfo
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFontName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mForegroundColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRowBuffers(-1) As LedRowBuffer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRows As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mRows
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mRows = value
			  EnsureRowBuffers
			End Set
		#tag EndSetter
		Rows As Integer
	#tag EndComputedProperty


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
			Name="BackgroundColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Columns"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForegroundColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Rows"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
