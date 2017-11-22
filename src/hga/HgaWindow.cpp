
#include "HgaWindow.h"

#include "agg_bounding_rect.h"
#include "agg_renderer_base.h"
#include "agg_renderer_primitives.h"
#include "agg_renderer_scanline.h"
#include "agg_trans_affine.h"

#include "agg_freetype_harfbuzz.h"

namespace GUI
{
HgaWindow::HgaWindow(wxWindow* parent,
    wxWindowID id,
    const wxPoint& pos,
    const wxSize& size,
    long style)
    : AGGWindow(parent, id, pos, size, style)
{
}

HgaWindow::~HgaWindow()
{
}

void HgaWindow::draw()
{
  /// The AGG base renderer
  typedef agg::renderer_base<PixelFormat::AGGType> RendererBase;

  /// The AGG primitives renderer
  typedef agg::renderer_primitives<RendererBase> RendererPrimitives;

  /// The AGG solid renderer
  typedef agg::renderer_scanline_aa_solid<RendererBase> RendererSolid;

  PixelFormat::AGGType pixf(rBuf);
  RendererBase rbase(pixf);
  RendererPrimitives rprim(rbase);
  RendererSolid rsolid(rbase);

  // Draw a rectangle against a white background
  rbase.clear(PixelFormat::AGGType::color_type(0, 0, 0));
  rprim.fill_color(PixelFormat::AGGType::color_type(64, 64, 200));
  rprim.solid_rectangle(rBuf.width() / 4, rBuf.height() / 4,
      3 * rBuf.width() / 4, 3 * rBuf.height() / 4);

  // Text drawing with FreeType and HarfBuzz to AGG buffer
  agg_ft_hb_draw<PixelFormat::AGGType>(rbase);
}
}
