#tag Class
Public Class BitmapLCDFont Inherits BitmapFontBase
	#tag Property, Flags = &h0
		Public Message As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Public ScrollIndex As Integer
	#tag EndProperty

	#tag Method, Flags = &h0
		Public Sub LoadMessage(value As String)
		  Message = value
		  ResetScroll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Public Sub ResetScroll()
		  ScrollIndex = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Public Sub ClockTick()
		  If Message = "" Then Return

		  ScrollIndex = ScrollIndex + 1
		  If ScrollIndex >= Message.Length Then
		    ScrollIndex = 0
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Public Function GlyphAdvance(ch As String) As Integer
		  Select Case ch
		  Case ":", "."
		    Return Max(1, CellWidth \ 2)
		  Else
		    Return CellWidth
		  End Select
		End Function
	#tag EndMethod
End Class
#tag EndClass
