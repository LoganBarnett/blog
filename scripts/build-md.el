;;; build-md.el --- Incremental ox-hugo export with #+include awareness  -*- lexical-binding: t; -*-
;;;
;;; Re-exports every org file in `build-md-org-dir' whose markdown
;;; counterpart is missing or older than the org source -- or older
;;; than anything that org source #+include's.  The include check is
;;; what keeps `resume.org' in sync with `../../employment/resume.org',
;;; since editing the included file does not bump the wrapper's mtime.
;;;
;;; Post-processes each fresh markdown to rewrite ox-hugo's relative
;;; `./asset' references to root-absolute `/asset'.  Hugo's
;;; `canonifyURLs: true' also handles this, but doing it at export
;;; time keeps the on-disk markdown self-consistent and matches what
;;; `scripts/export-all.sh' has historically done.
;;;
;;; Invoked from the blog Justfile's `hugo-md' recipe via
;;; `emacs --batch --load scripts/build-md.el'.

(require 'ox-hugo)

;; Batch mode would otherwise prompt or hang on these.
(setq enable-local-variables :safe)
(setq org-confirm-babel-evaluate nil)
(setq org-export-with-broken-links 'mark)

(defvar build-md-org-dir "org"
  "Directory containing the org source files.")

(defvar build-md-content-dir "content/posts"
  "Directory ox-hugo writes the markdown into.")

(defun build-md--md-path-for (org-file)
  "Return the expected content/posts path for ORG-FILE."
  (expand-file-name
   (concat (file-name-base org-file) ".md")
   build-md-content-dir))

(defun build-md--exportable-p (org-file)
  "Return non-nil if ORG-FILE declares the metadata ox-hugo needs.
Looks for #+hugo_base_dir (a keyword) or :HUGO_BASE_DIR: (a property).
Files lacking both are treated as drafts-in-progress and skipped rather
than failing the build."
  (with-temp-buffer
    (insert-file-contents org-file)
    (goto-char (point-min))
    (or (re-search-forward "^#\\+hugo_base_dir:" nil t)
        (progn
          (goto-char (point-min))
          (re-search-forward "^[[:space:]]*:HUGO_BASE_DIR:" nil t)))))

(defun build-md--include-files (org-file)
  "Return absolute paths of files referenced by #+INCLUDE from ORG-FILE.
Strips ::*Heading anchors from the captured path."
  (let ((includes nil)
        (dir (file-name-directory (expand-file-name org-file))))
    (with-temp-buffer
      (insert-file-contents org-file)
      (goto-char (point-min))
      (while (re-search-forward "^#\\+include:\\s-+\"\\([^\"]+\\)\"" nil t)
        (let ((raw (match-string 1)))
          (push (expand-file-name
                 (replace-regexp-in-string "::.*\\'" "" raw)
                 dir)
                includes))))
    (nreverse includes)))

(defun build-md--latest-mtime (files)
  "Return the latest mtime among existing FILES, or nil if none exist."
  (let ((times (delq nil
                     (mapcar (lambda (f)
                               (when (file-exists-p f)
                                 (file-attribute-modification-time
                                  (file-attributes f))))
                             files))))
    (when times
      (car (sort times (lambda (a b) (not (time-less-p a b))))))))

(defun build-md--needs-export-p (org-file md-file)
  "Return non-nil if ORG-FILE (or anything it includes) is newer than MD-FILE."
  (or (not (file-exists-p md-file))
      (let ((md-mtime (file-attribute-modification-time
                       (file-attributes md-file)))
            (src-mtime (build-md--latest-mtime
                        (cons org-file
                              (build-md--include-files org-file)))))
        (and src-mtime (time-less-p md-mtime src-mtime)))))

(defun build-md--fixup-relative-links (md-file)
  "Rewrite ox-hugo's ./asset refs to /asset in MD-FILE."
  (when (file-exists-p md-file)
    (with-temp-buffer
      (insert-file-contents md-file)
      (goto-char (point-min))
      (while (re-search-forward "\\(src\\|href\\)=\"\\./" nil t)
        (replace-match "\\1=\"/"))
      (goto-char (point-min))
      (while (re-search-forward "](\\./" nil t)
        (replace-match "](/"))
      (write-region (point-min) (point-max) md-file nil 'silent))))

(defun build-md--report-orphans ()
  "Warn about .md files in `build-md-content-dir' with no matching .org source.
Hugo will keep building these into the site until they are removed, so a
deleted org page sticks around until you also `git rm' the markdown.  No
files are deleted automatically -- some sites legitimately mix authored
markdown alongside ox-hugo output."
  (let ((md-files (directory-files build-md-content-dir t "\\.md\\'"))
        (org-bases (mapcar #'file-name-base
                           (directory-files build-md-org-dir nil "\\.org\\'"))))
    (dolist (md md-files)
      (unless (member (file-name-base md) org-bases)
        (message "build-md: ORPHAN %s (no matching .org -- remove or keep deliberately)"
                 md)))))

(defun build-md-run ()
  "Re-export org files whose markdown is stale.  Exits non-zero on any failure."
  (let ((updated 0)
        (skipped 0)
        (unconfigured 0)
        (failed 0))
    (dolist (org-file (directory-files build-md-org-dir t "\\.org\\'"))
      (let ((md-file (build-md--md-path-for org-file)))
        (cond
         ((not (build-md--exportable-p org-file))
          (message "build-md: SKIP %s (no #+hugo_base_dir; draft-in-progress?)"
                   org-file)
          (setq unconfigured (1+ unconfigured)))
         ((build-md--needs-export-p org-file md-file)
          (condition-case err
              (progn
                (message "build-md: exporting %s" org-file)
                (with-current-buffer (find-file-noselect org-file)
                  (org-hugo-export-to-md)
                  (kill-buffer))
                (build-md--fixup-relative-links md-file)
                (setq updated (1+ updated)))
            (error
             (message "build-md: FAIL %s :: %s"
                      org-file (error-message-string err))
             (setq failed (1+ failed)))))
         (t
          (setq skipped (1+ skipped))))))
    (message "build-md: %d updated, %d up-to-date, %d unconfigured, %d failed"
             updated skipped unconfigured failed)
    (when (> failed 0)
      (kill-emacs 1))))

(build-md--report-orphans)
(build-md-run)
