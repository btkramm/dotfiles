---
name: lit
description: Parse and extract text from documents using the `lit` CLI tool. Use this skill whenever the user wants to read, parse, or extract content from PDFs, DOCX, XLSX, PPTX, images, or any other document format — even if they just say "read this file" or "what's in this document". Also use it for OCR on images, batch processing multiple documents, or generating PDF screenshots. If a file is a document or image rather than plain code/text, prefer `lit` over the built-in Read tool.
allowed-tools: Bash(lit *)
---

# Parsing documents with `lit`

`lit` is installed locally and parses PDFs, DOCX, XLSX, PPTX, images, and other document formats into text or structured JSON.

## Commands

### Parse a single file

```bash
lit parse <file>
```

Key options:

- `--format text|json` — output format (default: text). Use `json` when you need structured data with bounding boxes or metadata.
- `-o <file>` — write output to a file instead of stdout.
- `--target-pages "1-5,10"` — parse only specific pages (useful for large PDFs).
- `--max-pages <n>` — limit how many pages to parse.
- `--no-ocr` — skip OCR (faster if you know the document has selectable text).
- `--ocr-language <lang>` — set OCR language (default: "en"). Use appropriate language codes for non-English documents.
- `--password <pw>` — for encrypted/protected documents.
- `--dpi <n>` — rendering resolution (default: 150). Higher values improve OCR accuracy but are slower.
- `-q` — suppress progress output for cleaner results.

### Screenshot PDF pages

```bash
lit screenshot <file> -o <output-dir>
```

Generates image files from PDF pages. Useful when the user needs to see the visual layout or when you need to analyze a PDF visually.

Key options:

- `--target-pages "1,3,5"` or `"1-5"` — select specific pages.
- `--format png|jpg` — image format (default: png).
- `--dpi <n>` — rendering resolution (default: 150).

### Batch process multiple files

```bash
lit batch-parse <input-dir> <output-dir>
```

Parses all supported documents in a directory.

Key options:

- `--recursive` — search subdirectories.
- `--extension ".pdf"` — only process files with this extension.
- `--format text|json` — output format.

## When to use each approach

- **Quick content extraction**: `lit parse file.pdf -q` — gets you the text directly.
- **Specific pages from a long PDF**: `lit parse file.pdf --target-pages "1-3" -q` — avoids parsing the entire document.
- **Spreadsheet data**: `lit parse data.xlsx -q` — extracts tabular content as text. Use `--format json` if you need structured cell data.
- **Image with text**: `lit parse photo.jpg -q` — uses OCR to extract text from images.
- **Non-English document**: `lit parse doc.pdf --ocr-language es -q` — set the appropriate language for better OCR results.
- **Visual inspection of a PDF**: `lit screenshot report.pdf --target-pages "1" -o /tmp/screenshots` — then read the generated image to see the layout.
- **Processing a folder of documents**: `lit batch-parse ./docs ./output --recursive --extension ".pdf"` — bulk extraction.

## Tips

- Always use `-q` when you only need the extracted content, so progress output doesn't clutter results.
- For large PDFs, start with `--target-pages "1-3"` to preview the structure before parsing the entire file.
- When the text output format doesn't preserve table structure well enough, try `--format json` for more structured data.
- If OCR results are poor, try increasing `--dpi` to 300.
