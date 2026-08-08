0.1.0 (2026-08-09)
------------------

Initial release, including modules:

* Point: Provides fundamental 2D vector arithmetic (addition, scaling, rotation, distance calculation, etc.).
* Matrix: 2x2 matrix transformations for handling rotation and coordinate system changes.
* Bezier: Provides Bézier curve interpolation algorithms to convert curves into point sequences.
* Line: Handles line intersection calculations and vector-based line segment operations.
* Path: Defines basic path data types (supporting Line, Qcurve, Ccurve, etc.) and provides core geometric algorithms such as translation, scaling, and bounding box fitting.
* Svg\_path: Handles the mapping and conversion between SVG path commands (e.g., M, L, C, Q, A) and the internal Path structure.
* Svg: Manages SVG container structures. Note: Only supports `<path>` element, its `d` attribute, and optional `<g>` container. Provides ViewBox auto-reset and fitting functionality.
* Glif: UFO Glif Path Module. Specifically designed to parse glyph path data from the Unified Font Object (UFO) format and convert them into the internal path model.

