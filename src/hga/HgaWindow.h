#ifndef WX_AGG_HGA_WINDOW_H
#define WX_AGG_HGA_WINDOW_H

#include "AGGWindow.h"

#include "agg_color_rgba.h"
#include "agg_path_storage.h"

#include "agg_rasterizer_scanline_aa.h"
#include "agg_scanline_p.h"

namespace GUI
{
/// An example of an application-specific subclass of AGGWindow,
/// in this case, a window that draws the lion example from AGG.
class HgaWindow : public AGGWindow
{
public:
  /// Initialize a lion window.
  /// Defaults are taken from AGGWindow::AGGWindow(), see that
  /// documentation for more information.
  HgaWindow(wxWindow* parent,
      wxWindowID id = wxID_ANY,
      const wxPoint& pos = wxDefaultPosition,
      const wxSize& size = wxDefaultSize,
      long style = wxTAB_TRAVERSAL);

  /// Clean up any resources held.
  virtual ~HgaWindow();

  /// Draw the bitmap with the lion.
  virtual void draw();

protected:
};
}

#endif
