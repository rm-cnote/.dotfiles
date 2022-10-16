;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 120)
(defvar efs/default-variable-font-size 120)
(defvar efs/default-font-family "Fira Code")
(defvar efs/fixed-font-family "Fira Code")
(defvar efs/variable-font-family "Cantarell")

;; MacOS key bindings
(when (eq system-type 'darwin) ;; mac specific settings
  (message "adding %s inits" (system-name))

  ;; osx may require the following...
  ;;
  ;; brew install svn
  ;; brew tap homebrew/cask-fonts
  ;; brew install --cask font-fira-code font-fira-mono
  ;; brew install --cask font-cantarell
  ;; brew install coreutils

  ;; these mac-* settings assumes System->Keyboard->Modifier Keys...
  ;; Caps Lock Key: Control
  ;; Control Key  : Option
  ;; Option Key   : Command
  ;; Command Key  : Command
  (setq mac-control-modifier 'super)
  (setq mac-command-modifier 'control)
  (setq mac-option-modifier 'meta)
  (setq insert-directory-program "gls" dired-use-ls-dired t)

  ;; nice up the osx screen on 3440x1440 display 
  (setq efs/default-font-size 160)
  (setq efs/default-variable-font-size 160)

  ;; mysql v5.7
  (setenv "PATH" (concat "/usr/local/opt/mysql-client@5.7/bin:/usr/local/MacGPG2/bin:/usr/local/bin:/usr/local/Cellar/libpq/14.2/bin:" (getenv "PATH")))
  (setq exec-path (append '("/usr/local/opt/mysql-client@5.7/bin") '("/usr/local/MacGPG2/bin") '("/usr/local/bin") '("/usr/local/Cellar/libpq/14.2/bin") exec-path))

  ;; zsh
  (setenv "PS1" "\\u@\\h:\\w\$ ")
  
  ;; Java
  (setenv "JAVA_HOME" "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home"))
 
;; Make frame transparency overridable
(defvar efs/frame-transparency '(90 . 90))

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))
(setq read-process-output-max (* 1024 1024)) 

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; top level look/feel
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(display-time-mode 1)       ; Anyone know what time it is?
(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)
;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook
		dired-mode-hook
		org-agenda-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font efs/default-font-family :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font efs/fixed-font-family :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font efs/variable-font-family :height efs/default-variable-font-size :weight 'regular)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package no-littering)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(tsi quelpa-use-package quelpa tree-sitter-langs tree-sitter ob-go python-black golint go-lint go-rename go-mode ox-hugo ob-mermaid dir-treeview dockerfile-mode yaml-mode ox-gfm python-mode with-venv pipenv pyvenv typescript-mode company-box flycheck company dap-mode lsp-ivy lsp-treemacs lsp-ui lsp-mode exec-path-from-shell all-the-icons-dired dired-single eterm-256color eshell-git-prompt visual-fill-column org-bullets magit counsel-projectile projectile helpful rainbow-delimiters doom-modeline all-the-icons doom-themes command-log-mode ivy-rich counsel ivy which-key general no-littering use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; from https://www.fettesps.com/emacs-disable-suspend-button/
;; Unbind Pesky Sleep Button
(global-unset-key [(control z)])
(global-unset-key [(control x)(control z)])

;; Windows Style Undo
(global-set-key [(control z)] 'undo)

(use-package general)

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-partial-or-done)
         :map ivy-switch-buffer-map
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)
(define-key emacs-lisp-mode-map (kbd "C-x M-t") 'counsel-load-theme)

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package command-log-mode
  :commands command-log-mode)

;;(load-theme 'tango-dark)

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

;; NOTE: If icons are missing run following command:
;;
;; M-x all-the-icons-install-fonts
(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-branch-read-upstream-first 'fallback))

;; org mode
(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.4)
                  (org-level-2 . 1.3)
                  (org-level-3 . 1.2)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :pin org
  :commands (org-capture org-agenda)
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-image-actual-width (list 640))

  (setq org-directory "~/org")
  (setq org-agenda-files '("~/org"))

  (setq org-agenda-compact-blocks t)

  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-targets '((nil :maxlevel . 9)
                             (org-agenda-files :maxlevel . 9)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)
  
  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "IN-PROGRESS(i!)" "DELEGATED(D@)" "HELD-BLOCKED(h@/!)" "|" "DONE(d!)" "WONT-DO(w@)")
	  (sequence "BREAKDOWN(b)" "|" "PLANNED(p!)" "WONT-DO(w@)")))

  (setq org-todo-keyword-faces
      (quote (("TODO" :foreground "orange" :weight bold)
              ("BREAKDOWN" :foreground "dark orange" :weight bold)
              ("NEXT" :foreground "aqua" :weight bold)
              ("IN-PROGRESS" :foreground "forest green" :weight bold)
              ("HELD-BLOCKED" :foreground "red" :weight bold)
              ("DONE" :foreground "white" :weight bold)
              ("PLANNED" :foreground "white" :weight bold)
              ("WONT-DO" :foreground "grey" :weight bold))))
  
  (setq org-tag-alist
	'((:startgroup)
					; Put mutually exclusive tags here
	  (:endgroup)
	  ("project" . ?p)
	  ("agenda" . ?a)
	  ("meeting" . ?m)
	  ("reference" . ?n)
	  ("idea" . ?i)
	  ("research" . ?r)
	  ("goal" . ?g)))
  (setq org-fast-tag-selection-single-key t)
  
  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
	'(("d" "Dashboard"
	   ((agenda "" ((org-deadline-warning-days 7)))
	    (todo "IN-PROGRESS" ((org-agenda-overriding-header "Working on now")))
	    (todo "NEXT" ((org-agenda-overriding-header "Next up to work on")))
	    (todo "DELEGATED" ((org-agenda-overriding-header "Delgated tasks to track")))
	    (todo "HELD-BLOCKED" ((org-agenda-overriding-header "Stuck tasks")))))

	  ("b" "Task backlog & project planning triage"
	   ((todo "TODO" ((org-agenda-overriding-header "Task backlog")))
	    (todo "BREAKDOWN" ((org-agenda-overriding-header "Projects that need planning")))))

	  ("c" "Completed, planned, and wont-do tasks and projects"
	   ((todo "DONE"
		  ((org-agenda-overriding-header "Tasks done"))))
	   ((todo "PLANNED"
		  ((org-agenda-overriding-header "Projects planned"))))
	   ((todo "WONT-DO"
		  ((org-agenda-overriding-header "Tasks optioned to the minors")))))))

  ;; Define capture templates
  (setq org-capture-templates
	`(("t" "Task" entry (file+headline "inbox.org" "Tasks")
           (file "templates/task.org"))

	  ("h" "Habit" entry (file "habits.org")
           (file "templates/habit.org"))

	  ("p" "Project" entry (file+headline "projects.org" "New Projects")
           (file "templates/project.org"))
	  
	  ("n" "Note" entry (file+headline "reference.org" "Notes")
           (file "templates/note.org"))
	  
	  ("N" "Private note" entry (file "private.org")
           (file "templates/note.org"))
	  
	  ("j" "Journal" entry (file+olp+datetree "journal.org")
	   (file "templates/journal.org")
	   :tree-type week)
	   
	  ("m" "Meeting" entry (file+olp+datetree "meetings.org")
	   (file "templates/meeting.org")
	   :tree-type week)

	  ("1" "1-1 Meeting" entry (file+olp+datetree "meetings.org")
	   (file "templates/1-1_meeting.org")
	   :tree-type week)
	  
	  ("s" "Status" entry (file+olp+datetree "status.org")
	   (file "templates/status.org")
	   :tree-type week)))

  (efs/org-font-setup))

;; org mode code blocks
(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python")))

;; org mode key bindings
(define-key global-map (kbd "C-c c")
  (lambda () (interactive) (org-capture nil)))
;;(global-set-key (kbd "\C-cc") 'org-capture)
(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "↪" "→" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package ox-gfm)

(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package dockerfile-mode)

(use-package dir-treeview
  :config
  (load-theme 'dir-treeview-pleasant t))
(global-set-key (kbd "<f9>") 'dir-treeview)
(global-set-key (kbd "<f10>") 'dir-treeview-open)

;; eshell
(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :bind (("C-r" . 'counsel-esh-history))
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies nil)
    (setq eshell-visual-commands '("htop"
				   "zsh"
				   "vim"
				   "ntl"
				   "netlify"
				   "python"
				   "ipython"
				   "psql"
				   "ssh"
				   "mysql"
				   "poetry"
				   "docker"
				   "ansible-playbook"
				   "hugo"
				   "npm"
				   "yarn")))

  (eshell-git-prompt-use-theme 'powerline))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

;; make sure ncurses package is installed
;; test: echo "Hello world" | cowsay | lolcat -p 0.7
(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

;; dired
(defun my-dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
   loaded."
  ;; <add other stuff here>
  (define-key dired-mode-map [remap dired-find-file]
    'dired-single-buffer)
  (define-key dired-mode-map [remap dired-mouse-find-file-other-window]
    'dired-single-buffer-mouse)
  (define-key dired-mode-map [remap dired-up-directory]
    'dired-single-up-directory))

;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
    ;; we're good to go; just add our bindings
    (my-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'my-dired-init))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first")))

(use-package dired-single)
  ;; :commands (dired dired-jump)
  ;; :custom
  ;; (dired-single-use-magic-buffer t))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;; nvm needs special help with PATH
(setq nvm/dir (concat (getenv "HOME") "/.nvm/versions/node/v16.14.0"))
(setenv "NVM_DIR" nvm/dir)
(setenv "NVM_CD_FLAGS" "-q")
(setenv "NVM_RC_VERSION" "")
(setenv "NVM_BIN" (concat nvm/dir "/bin"))
(setenv "NVM_INC" (concat nvm/dir "/include/node"))
(setenv "PATH" (concat (getenv "NVM_BIN") ":" (getenv "PATH")))
(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))

;; language servers, language setups
;; see https://emacs-lsp.github.io/lsp-mode/page/languages/ for lsp support
(defun lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode)
  (setq lsp-log-io t))

;; lsp, dap mode tips
;; typescript: npm install -g typescript-language-server; npm install -g typescript
;; python: pipenv install --dev black mypy debugpy pylint python-lsp-server \
;;           python-lsp-black pyls-isort isort pylsp-mypy flake8
;; notes:
;; - pyls-flake8 breaks pylsp flake8 handling
;; - helpful lsp debug notes at https://www.mattduck.com/lsp-python-getting-started.html

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  (setq lsp-enable-snippet nil)
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  :config
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  (dap-ui-controls-mode 1)
  :commands dap-debug
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed
  ;; Set up Pythno debugging
  (require 'dap-python)

  ;; Bind `C-c l d` to `dap-hydra` for easy access
  (general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; npm install -g eslint
(use-package flycheck
  :diminish flycheck-mode
  :init
  (setq flycheck-check-syntax-automatically '(save new-line)
        flycheck-idle-change-delay 5.0
        flycheck-display-errors-delay 0.9
        flycheck-highlighting-mode 'symbols
        flycheck-indication-mode 'left-fringe
        flycheck-standard-error-navigation t
        flycheck-deferred-syntax-check nil)
  )

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(add-hook 'html-mode-hook 'lsp-deferred)
(add-hook 'js-mode-hook 'lsp-deferred)
(setq js-indent-level 2)

;; pyenv, pipenv, teach dap where to find virtualenv python
(use-package pyvenv
  :config
  (pyvenv-mode 1))

(use-package with-venv)

(use-package python-black
  :demand t
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim)
  :custom
  (python-black-command (with-venv (executable-find "black")))
  (python-black-on-save-mode 't))

(defun python-mode-setup()
  (lsp-deferred)
  (flycheck-mode)
  (add-hook 'before-save-hook 'lsp-format-buffer)
  (setq lsp-pylsp-plugins-flake8-enabled 't))

(use-package python-mode
  :ensure t
  :hook (python-mode . python-mode-setup)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  ;; (python-shell-interpreter "python3")
  (dap-python-debugger 'debugpy)
  (dap-python-executable (with-venv (executable-find "python")))
  (lsp-pylsp-server-command (with-venv (executable-find "pylsp")))
  (defun dap-python--pyenv-executable-find (command)
    (with-venv (executable-find command)))

  :config
  (require 'dap-python))

;; Custom commands

(defun now ()
  "Insert string for the current time formatted like '2:34 PM'."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%D %-I:%M %p")))

(defun today ()
  "Insert string for today's date nicely formatted in American style,
e.g. Sunday, September 17, 2000."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%A, %B %e, %Y")))

(put 'upcase-region 'disabled nil)

;; See https://github.com/emacs-lsp/dap-mode/issues/642 for dap template issue with :program
(defun python-debug-setup()
  (interactive)
  (defun dap-python--pyenv-executable-find (command)
    (with-venv
      (executable-find command)))
  (dap-register-debug-template
   "python :: workspace"
   (list :type "python"
         :args ""
         :cwd "${workspaceFolder}"
         :env '(("PYTHONPATH" . "${workspaceFolder}"))
         :request "launch"
         :jinja "true"
         :name "python :: workspace"))
  (dap-register-debug-template
   "pytest :: test_add_sprockets"
   (list :type "python"
         :args "-k test_add_sprockets"
         :cwd "${workspaceFolder}"
         :env '(("PYTHONPATH" . "${workspaceFolder}"))
	 :module "pytest"
         :request "launch"
         :jinja "true"
         :name "pytest :: test_add_sprockets"))
  (dap-register-debug-template
   "pytest :: workspace"
   (list :type "python"
         :args ""
         :cwd "${workspaceFolder}"
         :env '(("PYTHONPATH" . "${workspaceFolder}"))
	 :program (with-venv (executable-find "pytest"))
         :request "launch"
         :jinja "true"
         :name "pytest :: workspace")))


;; go mode section

;; go install golang.org/x/tools/gopls@latest
;; go install golang.org/x/lint/golint@latest
;; go install golang.org/x/tools/cmd/gorename@latest
;; go install github.com/go-delve/delve/cmd/dlv@latest

(use-package go-rename)
(use-package golint)
(require 'dap-dlv-go)
(defun go-mode-setup ()
  ;; (go-eldoc-setup)
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (local-set-key (kbd "M-.") 'godef-jump)
  (setq compile-command "echo Building... && go build -v && echo Testing... && go test -v && echo Linter... && golint")
  (setq compilation-read-command t)
  ;;  (define-key (current-local-map) "\C-c\C-c" 'compile)
  (local-set-key (kbd "M-,") 'compile)
  (setq tab-width 4))
(setenv "GOPATH" (concat (getenv "HOME") "/go"))
(setenv "GOROOT" (concat (getenv "HOME") "/.go"))

(use-package go-mode
  :hook (go-mode . go-mode-setup)
  :init (add-hook 'go-mode-hook #'lsp-deferred))

;;Smaller compilation buffer
(setq compilation-window-height 14)
(defun my-compilation-hook ()
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
        (let* ((w (split-window-vertically))
               (h (window-height w)))
          (select-window w)
          (switch-to-buffer "*compilation*")
          (shrink-window (- h compilation-window-height)))))))
(add-hook 'compilation-mode-hook 'my-compilation-hook)

;;Other Key bindings
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

;;Compilation autoscroll
(setq compilation-scroll-output t)

;; Mermaid
(defun mermaid-setup ()
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (mermaid . t)
     (shell . t)
     (python . t)
     (js . t)
     (go . t))))

(use-package ob-mermaid
  :hook (org-mode . mermaid-setup)
  :config
  (setq ob-mermaid-cli-path "/home/rod/.npm/_npx/668c188756b835f3/node_modules/.bin/mmdc"))

(use-package ob-go)

;; Hugo/blogging
(use-package ox-hugo
  :ensure t   ;Auto-install the package from Melpa
  :pin melpa  ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox)

;; typescript support?
;; https://vxlabs.com/2022/06/12/typescript-development-with-emacs-tree-sitter-and-lsp-in-2022/
(use-package tree-sitter
  :ensure t
  :config
  ;; activate tree-sitter on any buffer containing code for which it has a parser available
  (global-tree-sitter-mode)
  ;; you can easily see the difference tree-sitter-hl-mode makes for python, ts or tsx
  ;; by switching on and off
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter)

(use-package typescript-mode
  :after tree-sitter
  :config
  ;; we choose this instead of tsx-mode so that eglot can automatically figure out language for server
  ;; see https://github.com/joaotavora/eglot/issues/624 and https://github.com/joaotavora/eglot#handling-quirky-servers
  (define-derived-mode typescriptreact-mode typescript-mode
    "TypeScript TSX")

  ;; use our derived mode for tsx files
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))
  ;; by default, typescript-mode is mapped to the treesitter typescript parser
  ;; use our derived mode to map both .tsx AND .ts -> typescriptreact-mode -> treesitter tsx
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescriptreact-mode . tsx)))

;; https://github.com/quelpa/quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))

;; https://github.com/quelpa/quelpa-use-package
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

;; https://github.com/orzechowskid/tsi.el/
;; great tree-sitter-based indentation for typescript/tsx, css, json
(use-package tsi
  :after tree-sitter
  :quelpa (tsi :fetcher github :repo "orzechowskid/tsi.el")
  ;; define autoload definitions which when actually invoked will cause package to be loaded
  :commands (tsi-typescript-mode tsi-json-mode tsi-css-mode)
  :init
  (add-hook 'typescript-mode-hook (lambda () (tsi-typescript-mode 1)))
  (add-hook 'json-mode-hook (lambda () (tsi-json-mode 1)))
  (add-hook 'css-mode-hook (lambda () (tsi-css-mode 1)))
  (add-hook 'scss-mode-hook (lambda () (tsi-scss-mode 1))))
