#tag Class
Protected Class LedDisplayRenderer
	#tag Method, Flags = &h0
		Sub Constructor()
		  Rows = 1
		  Columns = 16
		  BackgroundColor = &c000000
		  ForegroundColor = &c8B5CF6
		  ColorScheme = LedColorScheme.FromBaseColor(ForegroundColor)
		  mGapColumns = 4
		  mScrollOffsetPixels = 0
		  SetFont("FNT18X21")
		  EnsureLines
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CurrentFontName() As String
		  If mFont Is Nil Then Return ""
		  Return mFont.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EnsureLines()
		  Var oldLast As Integer = mLines.LastIndex
		  Var i As Integer
		  
		  If Rows < 1 Then Rows = 1
		  ReDim mLines(Rows - 1)
		  
		  If oldLast < 0 Then
		    For i = 0 To Rows - 1
		      mLines(i) = ""
		    Next
		  ElseIf oldLast < Rows - 1 Then
		    For i = oldLast + 1 To Rows - 1
		      mLines(i) = ""
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GapText() As String
		  Var s As String = ""
		  Var i As Integer
		  For i = 1 To mGapColumns
		    s = s + " "
		  Next
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IdealHeight() As Integer
		  If mFont Is Nil Then Return 0
		  Return Rows * mFont.GlyphHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IdealWidth() As Integer
		  If mFont Is Nil Then Return 0
		  Return Columns * mFont.GlyphWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MakeRowPicture(value As String) As Picture
		  Var picWidth As Integer
		  Var picHeight As Integer
		  Var p As Picture
		  Var gx As Graphics
		  Var i As Integer
		  Var ch As String
		  Var glyphIndex As Integer
		  Var dx As Integer
		  Var glyphPic As Picture
		  
		  If mFont Is Nil Then Return Nil
		  
		  picWidth = value.Length * mFont.GlyphWidth
		  If picWidth < 1 Then picWidth = mFont.GlyphWidth
		  picHeight = mFont.GlyphHeight
		  
		  p = New Picture(picWidth, picHeight, 32)
		  gx = p.Graphics
		  gx.DrawingColor = BackgroundColor
		  gx.FillRectangle(0, 0, picWidth, picHeight)
		  
		  For i = 0 To value.Length - 1
		    ch = value.Middle(i, 1)
		    glyphIndex = mFont.Glyphs.IndexOf(ch)
		    If glyphIndex < 0 Then
		      glyphIndex = mFont.Glyphs.IndexOf(ch.Uppercase)
		    End If
		    If glyphIndex >= 0 Then
		      dx = i * mFont.GlyphWidth
		      glyphPic = MakeTintedGlyph(glyphIndex)
		      gx.DrawPicture(glyphPic, dx, 0)
		    End If
		  Next
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MakeTintedGlyph(glyphIndex As Integer) As Picture
		  Var p As New Picture(mFont.GlyphWidth, mFont.GlyphHeight, 32)
		  Var gg As Graphics = p.Graphics
		  Var srcX As Integer = glyphIndex * mFont.GlyphWidth
		  
		  gg.DrawingColor = ColorScheme.BrightColor
		  gg.FillRectangle(0, 0, p.Width, p.Height)
		  
		  p.Mask.Graphics.DrawPicture(mFont.Bitmap, 0, 0, mFont.GlyphWidth, mFont.GlyphHeight, srcX, 0, mFont.GlyphWidth, mFont.GlyphHeight)
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Render(g As Graphics)
		  Var row As Integer
		  Var y As Integer
		  Var displayW As Integer
		  Var stripText As String
		  Var stripPic As Picture
		  Var stripW As Integer
		  Var x As Integer
		  
		  If mFont Is Nil Then Return
		  EnsureLines
		  displayW = IdealWidth
		  
		  g.DrawingColor = BackgroundColor
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  For row = 0 To Rows - 1
		    stripText = ScrollStripText(row)
		    stripPic = MakeRowPicture(stripText)
		    If stripPic Is Nil Then Continue
		    stripW = stripPic.Width
		    y = row * mFont.GlyphHeight
		    x = -mScrollOffsetPixels
		    While x > -stripW
		      x = x - stripW
		    Wend
		    While x < displayW
		      g.DrawPicture(stripPic, x, y)
		      x = x + stripW
		    Wend
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetScroll()
		  mScrollOffsetPixels = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScrollStep()
		  Var stripWidth As Integer
		  If mFont Is Nil Then Return
		  stripWidth = ScrollStripWidth
		  If stripWidth <= 0 Then Return
		  mScrollOffsetPixels = mScrollOffsetPixels + 1
		  If mScrollOffsetPixels >= stripWidth Then
		    mScrollOffsetPixels = 0
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ScrollStripText(row As Integer) As String
		  Var s As String
		  If row < 0 Or row > mLines.LastIndex Then Return " "
		  s = mLines(row)
		  If s = "" Then s = " "
		  Return s + GapText
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ScrollStripWidth() As Integer
		  Var widest As Integer
		  Var i As Integer
		  Var w As Integer
		  If mFont Is Nil Then Return 0
		  widest = IdealWidth + mFont.GlyphWidth
		  For i = 0 To mLines.LastIndex
		    w = ScrollStripText(i).Length * mFont.GlyphWidth
		    If w > widest Then widest = w
		  Next
		  Return widest
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFont(name As String)
		  mFont = LedFontCatalog.GetFont(name)
		  ResetScroll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetRowText(index As Integer, value As String)
		  If index < 0 Then Return
		  EnsureLines
		  If index > mLines.LastIndex Then Return
		  mLines(index) = value.Uppercase
		  ResetScroll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetText(lines() As String)
		  Var i As Integer
		  EnsureLines
		  For i = 0 To Rows - 1
		    If i <= lines.LastIndex Then
		      mLines(i) = lines(i).Uppercase
		    Else
		      mLines(i) = ""
		    End If
		  Next
		  ResetScroll
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BackgroundColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		ColorScheme As LedColorScheme
	#tag EndProperty

	#tag Property, Flags = &h0
		Columns As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ForegroundColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFont As LedFontInfo
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGapColumns As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLines() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollOffsetPixels As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Rows As Integer
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
			Name="Rows"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
			Name="BackgroundColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
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
	#tag EndViewBehavior
End Class
#tag EndClass
