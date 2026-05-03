#!/usr/bin/env bash
# Run ox-hugo over every file in org/, with org-auto-id-mode enabled
# (so headings without :CUSTOM_ID: get deterministic anchors via advice).

set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p content

emacs --batch \
  -L /Users/logan/dev/emacs-config/lisp \
  --eval "(require 'org-auto-id)" \
  --eval "(org-auto-id-mode 1)" \
  --eval "(require 'package)" \
  --eval "(setq package-archives '((\"melpa\" . \"https://melpa.org/packages/\")))" \
  --eval "(package-initialize)" \
  --eval "(unless (package-installed-p 'ox-hugo) (package-refresh-contents) (package-install 'ox-hugo))" \
  --eval "(require 'ox-hugo)" \
  --eval "(setq org-export-with-broken-links 'mark)" \
  --eval "(setq org-confirm-babel-evaluate nil)" \
  --eval "(let ((failures 0) (successes 0))
            (dolist (f (directory-files \"org\" t \"\\\\.org\\\\'\"))
              (condition-case err
                  (progn
                    (message \"export %s\" f)
                    (find-file f)
                    (org-hugo-export-to-md)
                    (kill-buffer)
                    (setq successes (1+ successes)))
                (error
                 (message \"FAIL %s :: %s\" f (error-message-string err))
                 (setq failures (1+ failures)))))
            (message \"=== exports: %d ok, %d failed\" successes failures))"

# Post-process: rewrite ./foo (relative-from-page) to /foo (root-absolute).
# ox-hugo emits img/link targets relative to the org file; under Hugo's
# post URL `/foo/' this resolves wrong.  Assets live at static root.
# Patterns covered:
#   <img src="./...">    <a href="./...">    [text](./...)
for f in content/posts/*.md; do
  sed -e 's|src="\./|src="/|g' \
      -e 's|href="\./|href="/|g' \
      -e 's|](\./|](/|g' \
      "$f" > "$f.tmp"
  mv "$f.tmp" "$f"
done
