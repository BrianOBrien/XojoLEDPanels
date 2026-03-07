Changed pieces for vertical + directional scrolling

Import:
- LedScrollDirection.xojo_code
- LedDisplayRenderer.xojo_code

In Window.Opening example:

mRenderer = New LedDisplayRenderer
mRenderer.Rows = 4
mRenderer.Columns = 32
mRenderer.ForegroundColor = &c0A84FF
mRenderer.ColorScheme = LedColorScheme.FromBaseColor(mRenderer.ForegroundColor)
mRenderer.SetFont("FNT18X21")
mRenderer.ScrollDirection = LedScrollDirection.Up
mRenderer.SetText(Array( _
  "XOJO LED DISPLAY DEMO", _
  "USE XOJO TO CREATE", _
  "CROSS PLATFORM APPS", _
  "LIKE THIS" _
))

LedDisplayCanvas1.Renderer = mRenderer
LedDisplayCanvas1.SizeToContent
LedDisplayCanvas1.Refresh

Timer Action:
mRenderer.ScrollStep
LedDisplayCanvas1.Refresh

Valid modes:
LedScrollDirection.None
LedScrollDirection.Left
LedScrollDirection.Right
LedScrollDirection.Up
LedScrollDirection.Down
