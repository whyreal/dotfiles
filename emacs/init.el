(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; Disable default mode
;; (electric-indent-mode -1)
;; (global-auto-composition-mode -1)
;; (auto-compression-mode -1)
;; (auto-encryption-mode -1)
;; (blink-cursor-mode -1)

;; (tool-bar-mode -1)
;; (tooltip-mode -1)
;; (line-number-mode -1)
(prefer-coding-system 'utf-8) 
(set-language-environment "UTF-8")

(setq markdown-command "/usr/local/bin/pandoc")

(add-hook 'after-init-hook 'global-company-mode)

(use-package lsp-mode
  :ensure t
  :commands lsp
  :hook ((lua-mode) . lsp)
  :config
  )

(use-package company-lsp
  :ensure t
  :after lsp-mode
  :config
  (setq company-lsp-enable-recompletion t)
  (setq lsp-auto-configure nil)         ;该功能会自动执行(push company-lsp company-backends)
  )

(use-package lsp-lua-emmy
  :demand
  :ensure nil
  :load-path "~/code/lsp-lua-emmy"
  :hook (lua-mode . lsp)
  :config
  (setq lsp-lua-emmy-jar-path (expand-file-name "EmmyLua-LS-all.jar" user-emacs-directory))
  )

(defun set-company-backends-for-lua()
  "Set lua company backend."
  (setq-local company-backends '(
                                 (
                                  company-lsp
                                  company-lua
                                  company-keywords
                                  company-gtags
                                  company-yasnippet
                                  )
                                 company-capf
                                 company-dabbrev-code
                                 company-files
                                 )))

(use-package lua-mode
  :ensure t
  :mode "\\.lua$"
  :interpreter "lua"
  :hook (lua-mode . set-company-backends-for-lua)
  :config
  (setq lua-indent-level 4)
  (setq lua-indent-string-contents t)
  (setq lua-prefix-key nil)
  )

(setq company-minimum-prefix-length 2)
(setq company-idle-delay 0.2)

;; temp file
(setq make-backup-files nil)

;; $PATH
;;(add-to-list 'my-packages 'exec-path-from-shell)
;; (when (memq window-system '(mac ns))
;;   (setenv "SHELL" "/bin/zsh")
;;   (exec-path-from-shell-initialize)
;;   (exec-path-from-shell-copy-envs
;;    '("PATH" "LC_ALL")))

;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(markdown-command "/usr/local/bin/pandoc -s -f markdown -t html -c /Users/Real/.emacs.d/markdown.css")
;;  '(ns-pop-up-frames nil)
;;  '(package-selected-packages (quote (jedi jinja2-mode yasnippet markdown-mode))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

(setq default-directory "~/")

;;(setenv "PATH" (concat "/usr/local/bin/:"  (getenv "PATH")))
;;(setq exec-path (append exec-path '("/usr/local/bin")))
;;
;;(setenv "PATH" (concat "/usr/local/sbin/:" (getenv "PATH")))
;;(setq exec-path (append exec-path '("/usr/local/sbin")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay 0.2)
 '(package-selected-packages
   (quote
    (yasnippet-classic-snippets yasnippet-snippets lua-mode company-lsp lsp-mode markdown-mode yasnippet neotree jinja2-mode jedi))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
