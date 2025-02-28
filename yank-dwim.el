;;; yank-dwim.el --- Select a region and yank a URL to create a link -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Ryan Prior

;; Author: Ryan Prior <rprior@protonmail.com>
;; Maintainer: Ryan Prior <rprior@protonmail.com>
;; Created: Feb 26, 2025
;; Package-Version: 20250227.0
;; Package-Revision: 0
;; Package-Requires: ((emacs "28.1"))
;; Keywords: Markdown, GitHub Flavored Markdown, org-mode, note-taking
;; URL: https://github.com/ryanprior/yank-dwim

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the README.md file for details.


;;; Code:

(require 'org-macs)
(require 'simple)

;;; yank-dwim for markdown ====================================================

(defun yank-dwim-md (&optional arg)
  (interactive "*P")
  (setq yank-window-start (window-start))
  ;; If we don't get all the way thru, make last-command indicate that
  ;; for the following command.
  (setq this-command t)
  (let ((yank-insert-text
         (current-kill (cond
                        ((listp arg) 0)
                        ((eq arg '-) -2)
                        (t (1- arg))))))
    (if (and (region-active-p) (org-url-p yank-insert-text))
        (let ((selected-text (buffer-substring (mark) (point))))
          (delete-region (mark) (point))
          (push-mark)
          (insert-for-yank (concat "[" selected-text "](" yank-insert-text ")")))
      (progn
        (when (and (region-active-p) delete-selection-mode)
          (delete-region (mark) (point)))
        (push-mark)
        (insert-for-yank yank-insert-text)))
    )
  (if (consp arg)
      ;; This is like exchange-point-and-mark, but doesn't activate the mark.
      ;; It is cleaner to avoid activation, even though the command
      ;; loop would deactivate the mark because we inserted text.
      (goto-char (prog1 (mark t)
                   (set-marker (mark-marker) (point) (current-buffer)))))
  ;; If we do get all the way thru, make this-command indicate that.
  (if (eq this-command t)
      (setq this-command 'yank-dwim-md))
  nil)

(with-eval-after-load 'markdown-mode
  (bind-key (kbd "C-y") #'yank-dwim-md markdown-mode-map))

(with-eval-after-load 'slack-mode
  (bind-key (kbd "C-y") #'yank-dwim-md slack-message-buffer-mode-map))


;;; yank-dwim for org-mode ====================================================

(defun yank-dwim-org (&optional arg)
  (interactive "*P")
  (setq yank-window-start (window-start))
  ;; If we don't get all the way thru, make last-command indicate that
  ;; for the following command.
  (setq this-command t)
  (let ((yank-insert-text
         (current-kill (cond
                        ((listp arg) 0)
                        ((eq arg '-) -2)
                        (t (1- arg))))))
    (if (and (region-active-p) (org-url-p yank-insert-text))
        (let ((selected-text (buffer-substring (mark) (point))))
          (delete-region (mark) (point))
          (push-mark)
          (insert-for-yank (concat "[[" yank-insert-text "][" selected-text "]]")))
      (progn
        (when (and (region-active-p) delete-selection-mode)
          (delete-region (mark) (point)))
        (push-mark)
        (insert-for-yank yank-insert-text))))
  (if (consp arg)
      ;; This is like exchange-point-and-mark, but doesn't activate the mark.
      ;; It is cleaner to avoid activation, even though the command
      ;; loop would deactivate the mark because we inserted text.
      (goto-char (prog1 (mark t)
                   (set-marker (mark-marker) (point) (current-buffer)))))
  ;; If we do get all the way thru, make this-command indicate that.
  (if (eq this-command t)
      (setq this-command 'yank-dwim-org))
  nil)

(with-eval-after-load 'org-mode
  (defun org-yank (&optional arg)
    (interactive "P")
    (org-yank-generic #'yank-dwim-org arg)))


(provide 'yank-dwim)

;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:
;;; yank-dwim.el ends here
