#tag Class
Protected Class BitmapFontBase
Inherits DesktopCanvas
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  Render(g)
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function CellHeight() As Integer
		  Return mCellHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CellWidth() As Integer
		  Return mCellWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CharacterMap() As String
		  Return mCharacters
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ColorizeGlyph(src As Picture) As Picture
		  If src Is Nil Then Return Nil
		  
		  Var p As New Picture(src.Width, src.Height)
		  Var s As RGBSurface = src.RGBSurface
		  Var d As RGBSurface = p.RGBSurface
		  
		  For y As Integer = 0 To src.Height - 1
		    For x As Integer = 0 To src.Width - 1
		      Var c As Color = s.Pixel(x, y)
		      Var lum As Integer = (c.Red + c.Green + c.Blue) / 3
		      Var ratio As Double = 1.0 - (lum / 255.0)
		      
		      Var rr As Integer = OffColor.Red + (OnColor.Red - OffColor.Red) * ratio
		      Var gg As Integer = OffColor.Green + (OnColor.Green - OffColor.Green) * ratio
		      Var bb As Integer = OffColor.Blue + (OnColor.Blue - OffColor.Blue) * ratio
		      
		      d.Pixel(x, y) = RGB(rr, gg, bb)
		    Next
		  Next
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Configure(fontSheet As Picture, chars As String, cellWidth As Integer, cellHeight As Integer, onColor As Color, offColor As Color, backColor As Color)
		  mFontSheet = fontSheet
		  mCharacters = chars
		  mCellWidth = cellWidth
		  mCellHeight = cellHeight
		  OnColor = onColor
		  OffColor = offColor
		  BackgroundColor = backColor
		  
		  Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DefaultControlHeight() As Integer
		  Return mCellHeight
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DefaultControlWidth() As Integer
		  Return mCellWidth * 8
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawBorder(g As Graphics)
		  Var darkColor  As Color = Color.RGB(0,0,0,70)
		  Var lightColor As Color = Color.RGB(100,100,100,50)
		  
		  Var w As Integer = g.Width
		  Var h As Integer = g.Height
		  
		  ' top
		  g.DrawingColor = darkColor
		  g.DrawLine(0, 0, w-1, 0)
		  
		  ' left
		  g.DrawLine(0, 0, 0, h-1)
		  
		  ' bottom (1px up)
		  g.DrawingColor = lightColor
		  g.DrawLine(0, h-1, w-1, h-1)
		  
		  ' right (1px left)
		  g.DrawLine(w-1, 0, w-1, h-1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawGlyph(g As Graphics, ch As String, dx As Double)
		  Var glyph As Picture = GlyphPictureForCharacter(ch)
		  If glyph = Nil Then Return
		  g.DrawPicture(glyph, dx, 0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawOverlay(g As Graphics)
		  Var h As Integer = g.Height
		  If h <= 1 Then Return
		  
		  Var topPct As Double = 0.15
		  Var midPct As Double = 0.65
		  Var botPct As Double = 0.20
		  
		  Var yTopEnd As Integer = h * topPct
		  Var yMidEnd As Integer = yTopEnd + (h * midPct)
		  
		  'Var topColor As Color = Color.RGBA(0, 0, 0, 250)
		  'Var midColor As Color = Color.RGBA(255, 255, 255, 200)
		  'Var botColor As Color = Color.RGBA(255, 255, 255, 190)
		  var topColor as color = Color.RGBA(0,0,0,235)        ' gentle shadow
		  var midColor as color = Color.RGBA(255,255,255,252)  ' almost invisible
		  var botColor as color = Color.RGBA(255,255,255,240)  ' soft highlight
		  For y As Integer = 0 To h - 1
		    If y < yTopEnd Then
		      g.DrawingColor = topColor
		    ElseIf y < yMidEnd Then
		      g.DrawingColor = midColor
		    Else
		      g.DrawingColor = botColor
		    End If
		    
		    g.DrawLine(0, y, g.Width - 1, y)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DrawWidthForCharacter(ch As String) As Integer
		  If ch = ":" Or ch = "." Then
		    Return mCellWidth / 2.0
		  End If
		  
		  Return mCellWidth
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GlyphIndexForCharacter(ch As String) As Integer
		  If ch = "" Then Return -1
		  
		  Var target As Integer = Asc(ch)
		  
		  For i As Integer = 0 To mCharacters.Length - 1
		    Var oneChar As String = mCharacters.Middle(i, 1)
		    If Asc(oneChar) = target Then
		      Return i
		    End If
		  Next
		  
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GlyphPictureForCharacter(ch As String) As Picture
		  If mFontSheet Is Nil Then Return Nil
		  
		  Var sx As Integer
		  Var sw As Integer
		  
		  If ch = ":" Then
		    sx = LastCellIndex * mCellWidth
		    sw = mCellWidth \ 2
		    
		  ElseIf ch = "." Then
		    sx = (LastCellIndex * mCellWidth) + (mCellWidth \ 2)
		    sw = mCellWidth - (mCellWidth \ 2)
		    
		  Else
		    Var idx As Integer = GlyphIndexForCharacter(ch)
		    If idx < 0 Then idx = 0
		    
		    sx = idx * mCellWidth
		    sw = mCellWidth
		  End If
		  
		  Var src As New Picture(sw, mCellHeight)
		  src.Graphics.DrawPicture(mFontSheet, 0, 0, sw, mCellHeight, sx, 0, sw, mCellHeight)
		  Return ColorizeGlyph(src)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function LastCellIndex() As Integer
		  // Characters string contains both : and . as logical display characters.
		  // The source PNG stores them together in the final physical cell.
		  Return 14
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshDisplay()
		  Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Render(g As Graphics)
		  g.DrawingColor = BackgroundColor
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  If DisplayValue = "" Then Return
		  
		  Var totalWidth As Double = 0
		  For i As Integer = 0 To DisplayValue.Length - 1
		    totalWidth = totalWidth + DrawWidthForCharacter(DisplayValue.Middle(i, 1))
		  Next
		  
		  If totalWidth <= 0 Then Return
		  
		  Var dx As Double = 0 - mScrollOffset
		  
		  // Shift starting point left until it is within one wrapped cycle
		  While dx > 0
		    dx = dx - totalWidth
		  Wend
		  
		  // Keep drawing wrapped copies until the control is filled
		  While dx < g.Width
		    For i As Integer = 0 To DisplayValue.Length - 1
		      Var ch As String = DisplayValue.Middle(i, 1)
		      DrawGlyph(g, ch, dx)
		      dx = dx + DrawWidthForCharacter(ch)
		      
		      If dx >= g.Width Then Exit
		    Next
		  Wend
		  
		  //DrawBorder(g)
		  DrawOverlay(g)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetOffset()
		  mScrollOffset = 0
		  Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetDisplayValue(value As String)
		  DisplayValue = value
		  Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Tick()
		  If DisplayValue = "" Then Return
		  
		  // --- determine step size ---
		  Var stepWidth As Integer = 1
		  
		  // LCD fonts advance by character width
		  If Self IsA BitmapLCDFont Then
		    
		    Var consumed As Integer = 0
		    
		    For i As Integer = 0 To DisplayValue.Length - 1
		      
		      Var ch As String = DisplayValue.Middle(i, 1)
		      Var w As Integer = DrawWidthForCharacter(ch)
		      
		      If consumed + w > mScrollOffset Then
		        stepWidth = w
		        Exit
		      End If
		      
		      consumed = consumed + w
		      
		    Next
		    
		  End If
		  
		  
		  // --- advance ---
		  mScrollOffset = mScrollOffset + stepWidth
		  
		  
		  // --- compute total width ---
		  Var totalWidth As Integer = 0
		  
		  For i As Integer = 0 To DisplayValue.Length - 1
		    totalWidth = totalWidth + DrawWidthForCharacter(DisplayValue.Middle(i,1))
		  Next
		  
		  
		  // --- wrap ---
		  If mScrollOffset >= totalWidth Then
		    mScrollOffset = 0
		  End If
		  
		  
		  Refresh(False)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BackgroundColor As Color = &c000000
	#tag EndProperty

	#tag Property, Flags = &h0
		DisplayValue As String = ""
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mCellHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mCellWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mCharacters As String = " 0123456789B_-:."
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mFontSheet As Picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mScrollOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		OffColor As Color = &c330000
	#tag EndProperty

	#tag Property, Flags = &h0
		OnColor As Color = &cFF0000
	#tag EndProperty

	#tag Property, Flags = &h0
		RespectAlpha As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		UpdatePeriod As Integer = 120
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
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
			InitialValue=""
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
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DisplayValue"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnColor"
			Visible=true
			Group="Behavior"
			InitialValue="&cFF0000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OffColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c330000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RespectAlpha"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UpdatePeriod"
			Visible=true
			Group="Behavior"
			InitialValue="120"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
