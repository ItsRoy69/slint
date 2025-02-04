// Copyright © SixtyFPS GmbH <info@slint-ui.com>
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Slint-commercial

use cfg_aliases::cfg_aliases;

fn main() {
    // Setup cfg aliases
    cfg_aliases! {
       enable_skia_renderer: { any(feature = "renderer-winit-skia", feature = "renderer-winit-skia-opengl")},
       use_winit_theme: { any(target_family = "windows", target_os = "macos", target_os = "ios", target_arch = "wasm32") },
    }
}
