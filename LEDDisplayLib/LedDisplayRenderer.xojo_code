#tag Class
Protected Class LedDisplayRenderer
	#tag Method, Flags = &h21
		Private Function CommonStripCharCount() As Integer
		  Var i As Integer
		  Var longest As Integer
		  
		  longest = Columns
		  
		  For i = 0 To mLines.LastIndex
		    If mLines(i).Length > longest Then
		      longest = mLines(i).Length
		    End If
		  Next
		  
		  longest = longest + Columns
		  
		  Return longest
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Rows = 1
		  Columns = 16
		  BackgroundColor = &c000000
		  ForegroundColor = &c0A84FF
		  ColorScheme = LedColorScheme.FromBaseColor(ForegroundColor)
		  ScrollDirection = LedScrollDirection.Left
		  mGapColumns = 4
		  mHorizontalOffset = 0
		  mVerticalOffset = 0
		  
		  SetFont("FNT18X21")
		  EnsureLines
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EnsureLines()
		  Var i As Integer
		  
		  If Rows < 1 Then Rows = 1
		  ReDim mLines(Rows - 1)
		  
		  For i = 0 To Rows - 1
		    If mLines(i) = "" Then
		      mLines(i) = ""
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GapText() As String
		  Var s As String = ""
		  Var i As Integer
		  Var gapChars As Integer
		  
		  If mFont Is Nil Then Return " "
		  
		  gapChars = Columns
		  
		  For i = 1 To gapChars
		    s = s + " "
		  Next
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HorizontalStripText(row As Integer) As String
		  Var s As String
		  Var targetLen As Integer
		  
		  If row < 0 Or row > mLines.LastIndex Then Return ""
		  
		  s = mLines(row)
		  If s = "" Then s = " "
		  
		  targetLen = CommonStripCharCount
		  
		  While s.Length < targetLen
		    s = s + " "
		  Wend
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HorizontalStripWidth() As Integer
		  If mFont Is Nil Then Return 0
		  Return CommonStripCharCount * mFont.GlyphWidth
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
		Private Function MakePanelPicture() As Picture
		  Var panel As New Picture(IdealWidth, IdealHeight, 32)
		  Var g As Graphics = panel.Graphics
		  Var row As Integer
		  Var rowPic As Picture
		  Var y As Integer
		  
		  g.DrawingColor = BackgroundColor
		  g.FillRectangle(0, 0, panel.Width, panel.Height)
		  
		  For row = 0 To Rows - 1
		    rowPic = MakeRowPicture(HorizontalStripText(row))
		    If rowPic <> Nil Then
		      y = row * mFont.GlyphHeight
		      g.DrawPicture(rowPic, 0, y)
		    End If
		  Next
		  
		  Return panel
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
		  Var sx As Integer
		  Var dx As Integer
		  Var glyphPic As Picture
		  Var gg As Graphics
		  
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
		      sx = glyphIndex * mFont.GlyphWidth
		      dx = i * mFont.GlyphWidth
		      
		      glyphPic = New Picture(mFont.GlyphWidth, mFont.GlyphHeight, 32)
		      gg = glyphPic.Graphics
		      gg.DrawingColor = ForegroundColor
		      gg.FillRectangle(0, 0, mFont.GlyphWidth, mFont.GlyphHeight)
		      glyphPic.Mask.Graphics.DrawPicture(mFont.Bitmap, 0, 0, mFont.GlyphWidth, mFont.GlyphHeight, sx, 0, mFont.GlyphWidth, mFont.GlyphHeight)
		      
		      gx.DrawPicture(glyphPic, dx, 0)
		    End If
		  Next
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Render(g As Graphics)
		  Select Case ScrollDirection
		  Case LedScrollDirection.Up, LedScrollDirection.Down
		    RenderVertical(g)
		  Else
		    RenderHorizontal(g)
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RenderHorizontal(g As Graphics)
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
		    stripText = HorizontalStripText(row)
		    stripPic = MakeRowPicture(stripText)
		    If stripPic Is Nil Then Continue
		    
		    stripW = stripPic.Width
		    y = row * mFont.GlyphHeight
		    
		    If ScrollDirection = LedScrollDirection.Right Then
		      x = mHorizontalOffset - stripW
		    Else
		      x = -mHorizontalOffset
		      While x > -stripW
		        x = x - stripW
		      Wend
		    End If
		    
		    While x < displayW
		      g.DrawPicture(stripPic, x, y)
		      x = x + stripW
		    Wend
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RenderVertical(g As Graphics)
		  Var panel As Picture
		  Var stripH As Integer
		  Var y As Integer
		  Var displayH As Integer
		  
		  If mFont Is Nil Then Return
		  EnsureLines
		  
		  displayH = IdealHeight
		  
		  g.DrawingColor = BackgroundColor
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  panel = MakePanelPicture
		  If panel Is Nil Then Return
		  
		  stripH = panel.Height
		  If stripH <= 0 Then Return
		  
		  If ScrollDirection = LedScrollDirection.Down Then
		    y = mVerticalOffset - stripH
		    While y > -stripH
		      y = y - stripH
		    Wend
		  Else
		    y = -mVerticalOffset
		    While y > -stripH
		      y = y - stripH
		    Wend
		  End If
		  
		  While y < displayH
		    g.DrawPicture(panel, 0, y)
		    y = y + stripH
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetScroll()
		  mHorizontalOffset = 0
		  mVerticalOffset = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScrollDownStep()
		  Var stripHeight As Integer
		  
		  If mFont Is Nil Then Return
		  stripHeight = VerticalStripHeight
		  If stripHeight <= 0 Then Return
		  
		  mVerticalOffset = mVerticalOffset - 1
		  If mVerticalOffset < 0 Then
		    mVerticalOffset = stripHeight - 1
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScrollLeftStep()
		  Var stripWidth As Integer
		  
		  If mFont Is Nil Then Return
		  
		  stripWidth = HorizontalStripWidth
		  If stripWidth <= 0 Then Return
		  
		  mHorizontalOffset = mHorizontalOffset + 1
		  
		  If mHorizontalOffset >= stripWidth Then
		    mHorizontalOffset = 0
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScrollRightStep()
		  Var stripWidth As Integer
		  
		  If mFont Is Nil Then Return
		  stripWidth = HorizontalStripWidth
		  If stripWidth <= 0 Then Return
		  
		  mHorizontalOffset = mHorizontalOffset - 1
		  If mHorizontalOffset < 0 Then
		    mHorizontalOffset = stripWidth - 1
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScrollStep()
		  Select Case ScrollDirection
		  Case LedScrollDirection.Left
		    ScrollLeftStep
		  Case LedScrollDirection.Right
		    ScrollRightStep
		  Case LedScrollDirection.Up
		    ScrollUpStep
		  Case LedScrollDirection.Down
		    ScrollDownStep
		  Else
		    // no scrolling
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScrollUpStep()
		  Var stripHeight As Integer
		  
		  If mFont Is Nil Then Return
		  stripHeight = VerticalStripHeight
		  If stripHeight <= 0 Then Return
		  
		  mVerticalOffset = mVerticalOffset + 1
		  If mVerticalOffset >= stripHeight Then
		    mVerticalOffset = 0
		  End If
		End Sub
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

	#tag Method, Flags = &h21
		Private Function VerticalStripHeight() As Integer
		  If mFont Is Nil Then Return 0
		  Return Rows * mFont.GlyphHeight
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CycleCompleted()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event WrapOccured()
	#tag EndHook


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
		Private mHorizontalOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLines() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mVerticalOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Rows As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ScrollDirection As LedScrollDirection
	#tag EndProperty


	#tag Using, Name = LedDisplayMod
	#tag EndUsing


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
		#tag ViewProperty
			Name="ScrollDirection"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="LedScrollDirection"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
