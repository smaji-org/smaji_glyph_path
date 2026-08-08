# Smaji Glyph Path

An OCaml library for manipulation of font glyph outlines. It provides a suite of tools for analyzing, transforming, composing, and converting glyph paths between different formats.

This library supports two primary path description standards:

1. SVG Path: Supports `<path>` element (including its `d` attribute) and optional `<g>` element as containers.
2. Glif Format: Supports the data used to describe glyph outlines in the Unified Font Object (UFO) format.

Note, this project is specifically designed for glyph path manipulation and is not a general-purpose SVG library. It focuses on the specific subset of SVG features used to describe glyph paths.

## Key Features

* 2D Geometry Foundations: Includes modules for points (Point), 2x2 matrices (Matrix), and line representations based on slope and intercept (Line).
* Bézier Curves: Supports linear, quadratic, cubic, and any degree Bézier curves.
* Path Transformations:
    * Basic Operations: Translate and scale complex paths.
    * Bounding Box Calculations: Automatically calculate path boundaries and provide tools to accurately fit paths into specific ViewBox or frame.
* Multi-Format Support:
    * SVG Path Processing
    * Glif Path Processing
* Format convertion between Svg.t, Glif.t, Path.t.


## Module Overview

* Point: Provides fundamental 2D vector arithmetic (addition, scaling, rotation, distance calculation, etc.).
* Matrix: 2x2 matrix transformations for handling rotation and coordinate system changes.
* Bezier: Provides Bézier curve interpolation algorithms to convert curves into point sequences.
* Line: Handles line intersection calculations and vector-based line segment operations.
* Path: Defines basic path data types (supporting Line, Qcurve, Ccurve, etc.) and provides core geometric algorithms such as translation, scaling, and bounding box fitting.
* Svg\_path: Handles the mapping and conversion between SVG path commands (e.g., M, L, C, Q, A) and the internal Path structure.
* Svg: Manages SVG container structures. Note: Only supports `<path>` element, its `d` attribute, and optional `<g>` container. Provides ViewBox auto-reset and fitting functionality.
* Glif: UFO Glif Path Module. Specifically designed to parse glyph path data from the Unified Font Object (UFO) format and convert them into the internal path model.

## Related projects 

* [Smaji GSD: Glyph Stroke Description markup language](https://github.com/smaji-org/smaji_gsd)
* [Smaji GOD: Glyph Outline Description markup language](https://github.com/smaji-org/smaji_god)
