
;Load some theme for better Emacs appearance. Here deeper-blue
(load-theme 'deeper-blue)

;Startup directory
(setq startup-dir "~/")

(setq jump-dir1 'nil)
(setq jump-dir2 'nil)
(setq jump-dir3 'nil)
(setq jump-dir4 'nil)
(setq jump-dir5 'nil)
(setq jump-dir6 'nil)
(setq jump-dir7 'nil)
(setq jump-dir8 'nil)
(setq jump-dir9 'nil)
(setq jump-dir10 'nil)

;Random on/off at startup.
(customize-set-variable 'emms-random-playlist t) ;ON
;(customize-set-variable 'emms-random-playlist 'nil) ;OFF

;Default playlist format when saving. pls and m3u supported.
;Note: EMMS also automatically checks the file extension when saving and will save in the corresponding format.
(setq emms-source-playlist-default-format 'pls)
