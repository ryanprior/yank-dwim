## How to use yank-dwim

- put the directory in your emacs lisp path
- put `(require 'yank-dwim)` in your init configuration
- copy a URL to your clipboard (kill-ring, in Emacs parlance)
- select a region of text
- <kbd>M-x</kbd> `yank-dwim-md` to create a Markdown link; or
- <kbd>M-x</kbd> `yank-dwim-org` to create an org-mode link

## Inspiration

In recent months I've noticed that a number of desktop applications treat
"paste" (yank in Emacs parlance) specially when you select a region of text and
paste a URL: it creates a link with the selected region as the link text and the
pasted URL as the destination. I've found that feature very convenient and
you can use this package to conveniently create links in Emacs.

## Contributing

This is meant as a temporary home for the package; I'm not interested in
accepting contributions here. I'll be contacting upstreams (markdown-mode and
org-mode to start) and ask if they're interested in this functionality; if they
are, development will continue upstream. If not, I'll decide on some path
forward.
