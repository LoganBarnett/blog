# -*- mode: Just; dtrt-indent-mode: 0; tab-width: 2; standard-indent: 2; -*-

# Re-export org files to markdown via ox-hugo when the .org (or
# anything it #+include's) is newer than the corresponding .md.
# See scripts/build-md.el for the timestamp logic.
hugo-md:
  emacs \
    --batch \
    --load scripts/build-md.el

build: hugo-md resume-pdf
  hugo \
    --logLevel debug \
    --environment production

serve:
  hugo \
    server \
    --baseURL 'http://localhost:1313/' \
    --logLevel debug \
    --environment production

# Build static/resume.pdf from org/resume.org via the configured Emacs
# in the devshell.  org/resume.org is itself a thin wrapper around
# ../employment/resume.org (private repo, source of truth).
resume-pdf:
  emacs \
    --batch \
    --eval "(require 'ox-latex)" \
    --visit org/resume.org \
    --funcall org-latex-export-to-pdf
  mv org/resume.pdf static/resume.pdf
  rm --force \
    org/resume.aux \
    org/resume.log \
    org/resume.out \
    org/resume.toc

# Snapshot the current resume PDF with today's date so we have a
# stable artifact to attach to applications.
resume-stamp: resume-pdf
  cp static/resume.pdf "static/logan-barnett-resume-$(date +%Y-%m-%d).pdf"
