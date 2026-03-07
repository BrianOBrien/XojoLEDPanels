Fresh LED classes
=================

Import order:
1. LedColorScheme.xojo_code
2. LedFontInfo.xojo_code
3. LedFontCatalog.xojo_code
4. LedDisplayRenderer.xojo_code
5. LedDisplayCanvas.xojo_code

Delete any older versions of those classes/modules first.

Expected picture resources in the project:
- FNT18X21
- LCD08X13
- LCD09X13
- LCD13X20
- LCD15X24
- LCD39X51
- LCD55X81

Window usage:

Private mRenderer As LedDisplayRenderer

Sub Opening()
  mRenderer = New LedDisplayRenderer
  mRenderer.Rows = 4
  mRenderer.Columns = 32
  mRenderer.ForegroundColor = &c8B5CF6
  mRenderer.ColorScheme = LedColorScheme.FromBaseColor(mRenderer.ForegroundColor)
  mRenderer.BackgroundColor = &c000000
  mRenderer.SetFont("FNT18X21")
  mRenderer.SetText(Array( _
    "NUMBER OF PATIENTS:  1234567890", _
    "NUMBER OF STUDIES:   1234567890", _
    "NUMBER OF SERIES:    1234567890", _
    "NUMBER OF INSTANCES: 1234567890" _
  ))
  LedDisplayCanvas1.Renderer = mRenderer
  LedDisplayCanvas1.SizeToContent
  LedDisplayCanvas1.Refresh
End Sub

Timer Action:
  mRenderer.ScrollStep
  LedDisplayCanvas1.Refresh

Notes:
- text is forced to uppercase because the bitmap fonts are uppercase-oriented
- scrolling is pixel-column based
- font tinting uses the font bitmap as a mask
