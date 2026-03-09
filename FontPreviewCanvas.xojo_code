#tag Class
Public Class FontPreviewCanvas Inherits DesktopCanvas
	#tag Property, Flags = &h0
		Public FontObject As BitmapFontBase
	#tag EndProperty

	#tag Property, Flags = &h0
		Public PreviewText As String
	#tag EndProperty

	#tag Method, Flags = &h0
		Public Sub SetFont(f As BitmapFontBase)
		  FontObject = f
		  Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AdvanceForChar(ch As String) As Integer
		  If FontObject Is Nil Then Return 0

		  If FontObject IsA BitmapLCDFont Then
		    Return BitmapLCDFont(FontObject).GlyphAdvance(ch)
		  Else
		    Return FontObject.GlyphAdvance(ch)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ColorizeGlyph(glyph As Picture) As Picture
		  If glyph Is Nil Then Return Nil
		  If FontObject Is Nil Then Return glyph

		  Var p As New Picture(glyph.Width, glyph.Height)
		  Var src As RGBSurface = glyph.RGBSurface
		  Var dst As RGBSurface = p.RGBSurface

		  For py As Integer = 0 To glyph.Height - 1
		    For px As Integer = 0 To glyph.Width - 1
		      Var c As Color = src.Pixel(px, py)
		      Var brightness As Integer = c.Red + c.Green + c.Blue

		      If brightness < 384 Then
		        dst.Pixel(px, py) = FontObject.OnColor
		      Else
		        dst.Pixel(px, py) = FontObject.OffColor
		      End If
		    Next
		  Next

		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InternalDrawText(g As Graphics, txt As String)
		  If FontObject Is Nil Then Return

		  Var x As Integer = 0
		  Var y As Integer = 0

		  For i As Integer = 0 To txt.Length - 1
		    Var ch As String = txt.Middle(i,1)
		    Var glyph As Picture = FontObject.GlyphPicture(ch)

		    If glyph <> Nil Then
		      Var p As Picture = ColorizeGlyph(glyph)
		      g.DrawPicture(p, x, y)
		    End If

		    x = x + AdvanceForChar(ch)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Public Sub Render(g As Graphics)
		  If FontObject Is Nil Then Return

		  If FontObject IsA BitmapLCDFont Then
		    g.DrawingColor = FontObject.OffColor
		  Else
		    g.DrawingColor = FontObject.BackgroundColor
		  End If
		  g.FillRectangle(0, 0, g.Width, g.Height)

		  If FontObject IsA BitmapLCDFont Then
		    Var lcd As BitmapLCDFont = BitmapLCDFont(FontObject)
		    If lcd.Message = "" Then Return
		    If lcd.ScrollIndex < 0 Then lcd.ScrollIndex = 0
		    If lcd.ScrollIndex >= lcd.Message.Length Then lcd.ScrollIndex = 0
		    InternalDrawText(g, lcd.Message.Middle(lcd.ScrollIndex))
		    Return
		  End If

		  If FontObject IsA BitmapFNTFont Then
		    Var fnt As BitmapFNTFont = BitmapFNTFont(FontObject)
		    If fnt.Message = "" Then Return

		    Var totalWidth As Integer = 0
		    For i As Integer = 0 To fnt.Message.Length - 1
		      totalWidth = totalWidth + AdvanceForChar(fnt.Message.Middle(i,1))
		    Next
		    If totalWidth <= 0 Then Return

		    Var drawX As Integer = -(fnt.ScrollX Mod totalWidth)

		    While drawX < g.Width
		      For i As Integer = 0 To fnt.Message.Length - 1
		        Var ch As String = fnt.Message.Middle(i,1)
		        Var glyph As Picture = FontObject.GlyphPicture(ch)

		        If glyph <> Nil Then
		          Var p As Picture = ColorizeGlyph(glyph)
		          g.DrawPicture(p, drawX, 0)
		        End If

		        drawX = drawX + AdvanceForChar(ch)
		        If drawX >= g.Width Then Exit
		      Next
		    Wend
		    Return
		  End If

		  If PreviewText <> "" Then
		    InternalDrawText(g, PreviewText)
		  End If
		End Sub
	#tag EndMethod
End Class
#tag EndClass
