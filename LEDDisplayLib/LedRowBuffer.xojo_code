#tag Class
Protected Class LedRowBuffer

#tag Property, Flags = &h21
	Private mColumns As Integer
#tag EndProperty

#tag Property, Flags = &h21
	Private mMessage As String
#tag EndProperty

#tag Property, Flags = &h21
	Private mOffset As Integer
#tag EndProperty


#tag ComputedProperty, Flags = &h0
	#tag Getter
		Get
		  Return mColumns
		End Get
	#tag EndGetter
	#tag Setter
		Set
		  mColumns = value
		  If mColumns < 1 Then mColumns = 1
		End Set
	#tag EndSetter
	DisplayWidth As Integer
#tag EndComputedProperty

#tag ComputedProperty, Flags = &h0
	#tag Getter
		Get
		  Return mMessage
		End Get
	#tag EndGetter
	#tag Setter
		Set
		  mMessage = value
		End Set
	#tag EndSetter
	Message As String
#tag EndComputedProperty


#tag Method, Flags = &h0
	Sub Constructor(columns As Integer, message As String)
	  mColumns = columns
	  If mColumns < 1 Then mColumns = 1
	  mMessage = message
	  mOffset = 0
	End Sub
#tag EndMethod

#tag Method, Flags = &h0
	Sub Reset()
	  mOffset = 0
	End Sub
#tag EndMethod

#tag Method, Flags = &h0
	Sub ScrollStep()
	  Var src As String

	  src = ScrollSource
	  If src = "" Then Return

	  mOffset = mOffset + 1
	  If mOffset >= src.Length Then
	    mOffset = 0
	  End If
	End Sub
#tag EndMethod

#tag Method, Flags = &h0
	Function VisibleText() As String
	  Var src As String
	  Var s As String

	  src = ScrollSource
	  If src = "" Then Return ""

	  If mOffset >= src.Length Then
	    mOffset = 0
	  End If

	  s = src.Middle(mOffset)

	  While s.Length < mColumns
	    s = s + src
	  Wend

	  Return s.Left(mColumns)
	End Function
#tag EndMethod

#tag Method, Flags = &h21
	Private Function ScrollSource() As String
	  Var s As String

	  s = mMessage
	  If s = "" Then s = " "

	  While s.Length < mColumns
	    s = s + " "
	  Wend

	  Return s + " "
	End Function
#tag EndMethod

End Class
#tag EndClass
