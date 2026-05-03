# -*- mode: Just; dtrt-indent-mode: 0; tab-width: 2; standard-indent: 2; -*-

build:
  hugo \
    --logLevel debug \
    --environment production

serve:
  hugo \
    server \
    --baseURL 'http://localhost:1313/' \
    --logLevel debug \
    --environment production

resume-stamp:
  # TODO: Use actual date.
  cp resume.pdf logan-barnett-resume-2026-01-14.pdf
