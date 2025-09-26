;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package meow
  :ensure t
  :config
  (setq meow-use-clipboard t)
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     ;; '("j" . meow-next)
     ;; '("k" . meow-prev)
     '("<escape>" . ignore))
    (meow-leader-define-key
     ;; Use SPC (0-9) for digit arguments.
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("?" . meow-cheatsheet)
     
     ;; Stuff
     '("M" . magit-status)
     '("w" . other-window)
     '("q" . kill-buffer-and-window)
     '("o" . org-agenda)
     '("r" . consult-recent-file)
     '("p" . projectile-switch-project)
     '("b" . consult-buffer)
     '("SPC" . projectile-find-file)
     '("/"   . consult-ripgrep))
    
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '(";" . meow-reverse)
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("d" . meow-delete)
     '("D" . meow-backward-delete)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("g" . meow-cancel-selection)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("n" . meow-search)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("q" . meow-quit)
     '("Q" . meow-goto-line)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("s" . meow-kill)
     '("t" . meow-till)
     '("u" . meow-undo)
     '("U" . meow-undo-in-selection)
     '("/" . meow-visit)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . meow-goto-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("z" . meow-pop-selection)
     '("'" . repeat)
     '("<escape>" . ignore))
    )
  (meow-setup)
  (meow-global-mode 1)
  (meow-keypad-mode -1))

(use-package cursor-undo
  :ensure t
  :config
  (cursor-undo 1))

;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(use-package autorevert
  :ensure nil
  :commands (auto-revert-mode global-auto-revert-mode)
  :hook
  (after-init . global-auto-revert-mode)
  :custom
  (auto-revert-interval 3)
  (auto-revert-remote-files nil)
  (auto-revert-use-notify t)
  (auto-revert-avoid-polling nil)
  (auto-revert-verbose t))

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(use-package recentf
  :ensure nil
  :commands (recentf-mode recentf-cleanup)
  :hook
  (after-init . recentf-mode)

  :custom
  (recentf-auto-cleanup (if (daemonp) 300 'never))
  (recentf-exclude
   (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
         "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
         "\\.7z$" "\\.rar$"
         "COMMIT_EDITMSG\\'"
         "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
         "-autoloads\\.el$" "autoload\\.el$"))

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :custom
  (savehist-autosave-interval 600)
  (savehist-additional-variables
   '(kill-ring                        ; clipboard
     register-alist                   ; macros
     mark-ring global-mark-ring       ; marks
     search-ring regexp-search-ring)))

(use-package super-save
  :ensure t
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

;; Flexible fuzzy matching
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))

;; Annotations in minibuffer (extra info)
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Telescope-like commands
(use-package consult
  :ensure t)

;; Completion UI
(use-package vertico
  :ensure t
  :init
  (vertico-mode +1))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

;; Install org-ics-import from SourceHut
;; (straight-use-package
;;    '(org-ics-import
;;      :type git
;;      :host nil
;;      :repo "https://git.sr.ht/~struanr/org-ics-import.el"))
;; 
;; ;; Customize org-ics-import variables
;; (setq org-ics-import-update-interval 300
;;       org-ics-import-calendars-alist
;;       '(("https://calendar.google.com/calendar/ical/trung.hoang%40angi.com/public/basic.ics"
;;          . "~/org/angi.org")
;;         ("https://outlook.office365.com/owa/calendar/6b98af2d87424c5ea3fcf0c097992d39@synergieglobal.com/0d88e1d293d24a57a29e0da00612baba11801247480162881145/calendar.ics"
;;          . "~/org/synergieglobal.org")
;;         ("https://calendar.google.com/calendar/ical/wanbicoi123%40gmail.com/public/basic.ics"
;;          . "~/org/wanbicoi123.org")))
;; (setq org-ics-import-exclude-strings '("Cancelled")
;;       org-ics-import-exclude-passed-events t)

(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t) 
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-one-light t)
  (doom-themes-org-config))

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))
(setq org-startup-indented t)
(setq org-todo-repeat-to-state "TODO")

(use-package alert
  :commands (alert)
  :config (setq alert-default-style 'toast))
  
(use-package alert-toast
  :after alert)

(use-package org-alert
  :ensure t
  :config
  (setq org-alert-interval 180)
  (org-alert-enable))

(setq org-refile-targets
      '((nil :maxlevel . 4)))

(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode))

(use-package magit
  :ensure t)

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.0))

(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode) ; enable for all programming modes
  :init
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-character ?\│  ; vertical line
        highlight-indent-guides-auto-enabled t) ; auto adjust
  )

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

;; --- Editing helpers ---
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; --- Web languages ---
(use-package web-mode
  :mode ("\\.html?\\'" "\\.jsx?\\'" "\\.tsx\\'" "\\.vue\\'" "\\.php\\'" "\\.aspx\\'" )
  :config
  (setq web-mode-enable-auto-pairing t
        web-mode-enable-auto-closing t
        web-mode-enable-auto-quoting t))

(use-package css-mode
  :ensure nil ;; built-in
  :mode "\\.css\\'")

(use-package scss-mode
  :mode "\\.scss\\'")

(use-package less-css-mode
  :mode "\\.less\\'")

(use-package js
  :ensure nil ;; built-in js-mode
  :mode ("\\.js\\'" . js-mode)
  :config (setq js-indent-level 2))

(use-package typescript-mode
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :hook (typescript-mode . (lambda () (setq typescript-indent-level 2))))

(use-package json-mode
  :mode "\\.json\\'")

;; (use-package yaml-mode
;;   :mode "\\.ya?ml\\'")


;; SETTINGS

(set-face-attribute 'help-key-binding nil :family "Cascadia Code NF" :height 120 :weight 'normal)
(set-face-attribute 'default nil :family "Cascadia Code NF" :height 110 :weight 'normal)
;; (set-face-attribute 'variable-pitch nil :family "Cascadia Code" :height 120 :weight: 'normal)

(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Set initial window size
(setq initial-frame-alist
      '((top . 50)    ;; distance from top of screen
        (left . 400)  ;; distance from left of screen
        (width . 140) ;; character columns
        (height . 40))) ;; number of lines

;; Optional: make all new frames the same size
(setq default-frame-alist initial-frame-alist)

(defvar +org-capture-notes-file (expand-file-name "~/org/notes.org")
  "Default file for storing Org capture notes.")

(defvar +org-capture-todo-file (expand-file-name "~/org/todo.org")
  "Default file for storing Org capture TODOs.")

(setq org-capture-templates
      '(
        ;; Jira Ticket under Inbox
        ("j" "Jira MHD" entry (file+headline +org-capture-todo-file "Inbox")
         "* TODO [/] %:annotation :mhd:"
         :immediate-finish t
         :prepend t
         :jump-to-captured t)
        ;; Ticket Action as subtask of matching ticket
        ("a" "Jira MHD Action :mhd:" entry
          (file+function +org-capture-todo-file
                        (lambda ()
                          (let* ((url (plist-get org-store-link-plist :link))
                                 (ticket-id (when (string-match "/\\([A-Z]+-[0-9]+\\)" url)
                                              (match-string 1 url))))
                            (goto-char (point-min))
                            ;; Search for the ticket ID in the buffer
                            (if (and ticket-id (search-forward ticket-id nil t))
                                (org-back-to-heading)
                              ;; If not found, go to Inbox
                              (goto-char (point-min))
                              (search-forward "* Inbox" nil t)))))
         "** TODO %:description"
         :prepend t
         :jump-to-captured t
         :immediate-finish t)
        ;; Personal todo
        ("t" "Personal todo" entry
         (file+headline +org-capture-todo-file "Inbox")
         "* TODO %?" :prepend t)
        ;; Notes
        ("n" "Personal notes" entry
         (file +org-capture-notes-file)
         "* %U %?" :prepend t)))

(setq org-enforce-todo-checkbox-dependencies t)
(setq org-enforce-todo-dependencies t)
(setq org-agenda-dim-blocked-tasks t)

(setq org-agenda-files
      (list +org-capture-todo-file
            ;; "~/org/wanbicoi123.org"
            ;; "~/org/angi.org"
            ;; "~/org/synergieglobal.org"
            ))

(defun my/skip-future-scheduled-entries ()
  "Skip entries scheduled more than 8 hours in the future."
  (let* ((scheduled (org-get-scheduled-time (point)))
         (eight-hours-future (time-add (current-time) 
                                       (seconds-to-time 28800)))
         (should-skip (and scheduled
                          (time-less-p eight-hours-future scheduled))))
    (when should-skip
      (progn (outline-next-heading) (point)))))
(setq org-agenda-custom-commands
      '(("f" "Focus Tasks"
         ((tags "focus"
                ((org-agenda-overriding-header "Focus TODOs")))
          (agenda "" ((org-agenda-span 'week)))))
        ("j" "MHD Tasks"
         ((agenda "" ((org-agenda-span 'day)))
          (tags-todo "mhd"
                     ((org-agenda-overriding-header "MHD Tasks (within 8h or unscheduled)")
                      (org-agenda-sorting-strategy '(scheduled-up priority-down))
                      (org-agenda-skip-function 'my/skip-future-scheduled-entries)))))))

(setq org-agenda-sorting-strategy
      '((agenda habit-down time-up urgency-down category-keep)
        (todo timestamp-up priority-down)
        (tag timestamp-up priority-down)
        (search category-keep)))
(setq org-agenda-window-setup 'current-window)
(setq org-return-follows-link t)

(global-set-key (kbd "<f5>") 'org-capture)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)))
(setq org-confirm-babel-evaluate nil)

;; (global-visual-line-mode)
(electric-pair-mode 1)
(electric-quote-mode 1)

;; For org-protocol
(require 'server)
(unless (server-running-p)
  (server-start))
(require 'org-protocol)
