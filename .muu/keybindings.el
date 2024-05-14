;muu keybindings

(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

(global-set-key (kbd "TAB") 'other-window)
(define-key global-map (kbd "<left>") 'emms-seek-backward)
(define-key global-map (kbd "<right>") 'emms-seek-forward)


(define-key dired-mode-map (kbd "SPC") 'emms-pause)
(define-key dired-mode-map (kbd "a") (lambda () (interactive) (progn (emms-add-dired-improved) (dired-next-line 1))))
(define-key dired-mode-map "s" 'emms-stop)
(define-key dired-mode-map "n" 'next-track)
(define-key dired-mode-map "b" 'emms-previous)

(define-key dired-mode-map "," (lambda () (interactive) (emms-player-mpv-lower-volume 5)))
(define-key dired-mode-map "." (lambda () (interactive) (emms-player-mpv-raise-volume 5)))

(define-key dired-mode-map "+" (lambda () (interactive) (emms-player-mpv-raise-volume 5)))
(define-key dired-mode-map "-" (lambda () (interactive) (emms-player-mpv-lower-volume 5)))

(define-key dired-mode-map "J" 'dired) ;jump to folder.
(define-key dired-mode-map "S" 'toggle-random)
(define-key dired-mode-map "C" 'emms-playlist-current-clear)

(define-key dired-mode-map (kbd "C-w") 'emms-playlist-save)

(define-key dired-mode-map (kbd "u") 'dired-up-directory)
(define-key dired-mode-map (kbd "f") 'dired-narrow)
(define-key dired-mode-map (kbd "/") 'dired-narrow)
(define-key dired-mode-map (kbd "\\") 'dired-narrow)

;Jump to directory hotkeys
(define-key dired-mode-map (kbd "1") (lambda () (interactive) (dired jump-dir1)))
(define-key dired-mode-map (kbd "2") (lambda () (interactive) (dired jump-dir2)))
(define-key dired-mode-map (kbd "3") (lambda () (interactive) (dired jump-dir3)))
(define-key dired-mode-map (kbd "4") (lambda () (interactive) (dired jump-dir4)))
(define-key dired-mode-map (kbd "5") (lambda () (interactive) (dired jump-dir5)))
(define-key dired-mode-map (kbd "6") (lambda () (interactive) (dired jump-dir6)))
(define-key dired-mode-map (kbd "7") (lambda () (interactive) (dired jump-dir7)))
(define-key dired-mode-map (kbd "8") (lambda () (interactive) (dired jump-dir8)))
(define-key dired-mode-map (kbd "9") (lambda () (interactive) (dired jump-dir9)))
(define-key dired-mode-map (kbd "0") (lambda () (interactive) (dired jump-dir10)))

(define-key emms-playlist-mode-map (kbd "TAB") 'other-window)
(define-key emms-playlist-mode-map (kbd "SPC") 'emms-pause)
(define-key emms-playlist-mode-map "s" 'emms-stop)
(define-key emms-playlist-mode-map "d" 'emms-playlist-mode-kill-track)
(define-key emms-playlist-mode-map "n" 'next-track)
(define-key emms-playlist-mode-map "b" 'emms-previous)

(define-key emms-playlist-mode-map "," (lambda () (interactive) (emms-player-mpv-lower-volume 5)))
(define-key emms-playlist-mode-map "." (lambda () (interactive) (emms-player-mpv-raise-volume 5)))

(define-key emms-playlist-mode-map "+" (lambda () (interactive) (emms-player-mpv-raise-volume 5)))
(define-key emms-playlist-mode-map "-" (lambda () (interactive) (emms-player-mpv-lower-volume 5)))

(define-key emms-playlist-mode-map "S" 'toggle-random)
(define-key emms-playlist-mode-map "C" 'emms-playlist-clear)
(define-key emms-playlist-mode-map (kbd "C-d") 'kill-this-buffer) ;kill playlist

(define-key emms-playlist-mode-map (kbd "P") 'create-playlist)
(define-key emms-playlist-mode-map (kbd "]") (lambda () (interactive) (progn (emms-playlist-mode-next 1) (emms-playlist-set-playlist-buffer))))
(define-key emms-playlist-mode-map (kbd "[") (lambda () (interactive) (progn (emms-playlist-mode-previous 1) (emms-playlist-set-playlist-buffer))))

(define-key emms-playlist-mode-map (kbd "}") 'rename-buffer) ;rename playlist

(define-key emms-playlist-mode-map (kbd "C-w") 'emms-playlist-save)
