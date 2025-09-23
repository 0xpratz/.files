
; Inject markdown into block comments
((comment) @injection.content
 (#match? @injection.content "^/\\*[\\s\\S]*\\*/$")
 (#set! injection.language "markdown")
 (#set! injection.include-children))
