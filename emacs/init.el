(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

(require 'yasnippet)
(yas-reload-all)

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-command "/usr/local/bin/pandoc")
 '(package-selected-packages (quote (jedi jinja2-mode yasnippet markdown-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq default-directory "/")
(setenv "PATH" (concat "/usr/local/bin/:"  (getenv "PATH")))
(setq exec-path (append exec-path '("/usr/local/bin")))
(setenv "PATH" (concat "/usr/local/sbin/:" (getenv "PATH")))
(setq exec-path (append exec-path '("/usr/local/sbin")))
