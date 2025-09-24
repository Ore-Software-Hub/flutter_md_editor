# Changelog

## 0.1.2
### Changed
- Added functionality to the applyStyle method to allow users to unapply markdown formatting (bold, italic, title) from selected text.

### Fixed
- The `onTextChanged` callback is now of type `void Function(String)`, no longer returning a String.

## 0.1.1
### Fixed
- Removed `SizedBox` from `Column`.

## 0.1.0
### Added
- Integrated the `flutter_markdown` library for rendering markdown content.
- Implemented a `TextField` for live markdown editing.
- Created a toolbar with primary formatting options: **Bold**, *Italic*, and Header.

### Notes
- Initial release with core functionality for markdown editing and preview.
- Basic UI components for editing and formatting markdown.


## 0.0.1
* Initial release.