 ;; Set language environment to UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(require 'package)
(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
						 ("melpa" . "https://melpa.org/packages/")
))


(package-initialize)

; Fetch the list of packages available
(unless package-archive-contents (package-refresh-contents))

; Install use-package
(setq package-list '(use-package))
(dolist (package package-list)
(unless (package-installed-p package) (package-install package)))

(eval-and-compile
  (setq use-package-always-ensure t))

;; Change frame title to muu
(setq frame-title-format "muu Music Player")

;; Change all yes/no prompts to y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; Ignore case when completing filenames
(setq read-file-name-completion-ignore-case t)

;; Hide the toolbar
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;Disable blinking cursor
(blink-cursor-mode -1)

;; Disable alarm bell
(setq ring-bell-function 'ignore)

;;No startup message
(setq inhibit-startup-message t)

;Move to first/last line of buffer when hitting beginning/end.
(setq scroll-error-top-bottom t)

;Dired tweaks
(require 'dired )
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file) ;was dired-advertised-find-file
(define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file ".."))) ;was dired-up-directory
(put 'dired-find-alternate-file 'disabled nil)
(setq dired-listing-switches "-l --group-directories-first")
(setq dired-kill-when-opening-new-dired-buffer 1)

(defun dired-init ()
  "To be run as hook for 'dired-mode'."
  (dired-hide-details-mode 1))

(add-hook 'dired-mode-hook 'dired-init)

;;Make C-x k kill the current buffer without prompt
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;;Enable Wind Move
(windmove-default-keybindings)

;dired-narrow provides a nice narrowing functionality for dired.
(use-package dired-narrow :ensure t)

;Adapted from https://blog.binchen.org/posts/how-to-use-emms-effectively/
;https://github.com/redguardtoo
(use-package emms
  :ensure t
  :pin elpa
  :config
  (with-eval-after-load 'emms
	;; minimum setup is more robust
	(emms-minimalistic)
	(eval-and-compile
      (require 'emms-playlist-mode)
      (require 'emms-metaplaylist-mode)
	  (require 'emms-volume)
	  (require 'emms-mode-line)
	  (require 'emms-cache)
	  (require 'emms-playing-time))
	  
	(setq emms-playlist-default-major-mode #'emms-playlist-mode)
	(add-hook 'emms-playlist-mode-hook #'display-line-numbers-mode)
	;; 'emms-info-native' supports mp3,flac and requires NO cli tools
	;; (unless (memq 'emms-info-native emms-info-functions)
	(require 'emms-info)
    (require 'emms-info-native)
    (push 'emms-info-native emms-info-functions)
	
	(emms-cache 1)
	(emms-mode-line 1)
	(emms-playing-time 1)
	;; extract track info when loading the playlist
	(push 'emms-info-initialize-track emms-track-initialize-functions)

	(setq emms-player-list '(emms-player-mpv))
	(setq emms-player-mpv-parameters '("--quiet" "--really-quiet" "--no-audio-display" "--force-window=no" "--vo=null" "--no-resume-playback"))
	(customize-set-variable 'emms-player-mpv-update-metadata t)
  ))


;EMMS Track progress bar, taken from:
;https://emacs.stackexchange.com/questions/21747/emms-how-can-i-have-a-progress-bar/21766#21766
;https://emacs.stackexchange.com/users/3889/xuchunyang
(defun chunyang-emms-indicate-seek (_sec)
  (let* ((total-playing-time (emms-track-get
                              (emms-playlist-current-selected-track)
                              'info-playing-time))
         (elapsed-total (round(/ (* 100 emms-playing-time) total-playing-time))))
    (with-temp-message (format "[%-100s] %2d%%"
                               (make-string elapsed-total ?=)
                               elapsed-total)
      (sit-for 5))))

(add-hook 'emms-player-seeked-functions #'chunyang-emms-indicate-seek 'append)

;Control EMMS/MPV volume, taken from:
;https://www.reddit.com/r/emacs/comments/syop1h/control_emmsmpv_volume/
;https://www.reddit.com/user/EcstaticBill2638/

(defvar emms-player-mpv-volume 100)

(defun emms-player-mpv-get-volume ()
  "Sets `emms-player-mpv-volume' to the current volume value
  and sends a message of the current volume status."
  (emms-player-mpv-cmd '(get_property volume)
                       #'(lambda (vol err)
                           (unless err
                             (let ((vol (truncate vol)))
                               (setq emms-player-mpv-volume vol)
                               (message "Music volume: %s%%"
                                        vol))))))

(defun emms-player-mpv-raise-volume (&optional amount)
  (interactive)
  (let* ((amount (or amount 10))
         (new-volume (+ emms-player-mpv-volume amount)))
    (if (> new-volume 100)
        (emms-player-mpv-cmd '(set_property volume 100))
      (emms-player-mpv-cmd `(add volume ,amount))))
  (emms-player-mpv-get-volume))

(defun emms-player-mpv-lower-volume (&optional amount)
  (interactive)
  (emms-player-mpv-cmd `(add volume ,(- (or amount '10))))
  (emms-player-mpv-get-volume))


;EMMS Track description configuration, taken from:
;https://github.com/seblemaguer/dotfiles/tree/main/emacs.d
;https://github.com/seblemaguer

;; Configure track description format
;; Note: Not used, just included as an example.
(defun track-description (track)
  "Return a description of the current TRACK."
  (if (and (emms-track-get track 'info-artist)
           (emms-track-get track 'info-title))
      (let ((pmin (emms-track-get track 'info-playing-time-min))
      		(psec (emms-track-get track 'info-playing-time-sec))
      		(ptot (emms-track-get track 'info-playing-time))
      		(art  (emms-track-get track 'info-artist))
      		(tit  (emms-track-get track 'info-title))
      		(alb  (emms-track-get track 'info-album)))
        (cond ((and pmin psec) (format "%s - %s - %s [%02d:%02d]" art alb tit pmin psec))
      		  (ptot (format  "%s - %s - %s [%02d:%02d]" art alb tit (/ ptot 60) (% ptot 60)))
      		  (t (emms-track-simple-description track))))
    (progn
      (emms-track-simple-description track))))

(defun track-description-just-filename (track)
  "Description will just be the filename (without path) of TRACK."
;this is very fast since metadata is not read at all.
  (file-name-nondirectory (emms-track-get track 'name))
  )

(defun track-description-title (track)
  "Description will be Title of TRACK, or filename if failed to get Title."
  (if (emms-track-get track 'info-title)(emms-track-get track 'info-title)
	(file-name-nondirectory (emms-track-get track 'name))
	))


(setq emms-track-description-function 'track-description-title)


;;Create playlist, they will be named 1,2,3 ... et.c.
(setq counter 1)
(defun create-playlist ()
  "create-playlist"
  (interactive)
  (setq counter (+ counter 1))
  (emms-playlist-new (format "%S" counter)))


;Just a wrapper around emms-toggle-random-playlist to display a better message.
(defun toggle-random ()
"Toggle random."
(interactive)
(emms-toggle-random-playlist)
(if emms-random-playlist (message "Random ON")
  (message "Random OFF"))
)

;Next track - Random track if random is on, otherwise the next track in playlist.
(defun next-track ()
"Next Track."
(interactive)
(if emms-random-playlist (progn (emms-random) (emms-playlist-mode-center-current))
  (emms-next))
)


;emms-add-dired-improved - Improved version of emms-add-dired that also handles playlist files (.pls, .m3u).
;;;###autoload (autoload 'emms-add-dired "emms-source-file" nil t)
(define-emms-source dired-improved ()
  "Return all marked files of a dired buffer"
  (interactive)
  (mapc (lambda (file)
          (cond ((file-directory-p file) (emms-source-directory-tree file))
				((string-equal (file-name-extension file) "pls") (emms-add-playlist file))
				((string-equal (file-name-extension file) "m3u") (emms-add-playlist file))
				(t (emms-source-file file))))
          (with-current-buffer emms-source-old-buffer
			(dired-get-marked-files))))


;left/right arrow keys will be used for seeking.
(define-key global-map (kbd "<left>") nil)
(define-key global-map (kbd "<right>") nil)

;Strip-down dired functionality.
(define-key dired-mode-map (kbd "SPC") nil)
(define-key dired-mode-map "i" nil)
(define-key dired-mode-map "!" nil)
(define-key dired-mode-map "#" nil)
(define-key dired-mode-map "$" nil)
(define-key dired-mode-map "&" nil)
(define-key dired-mode-map "(" nil)
(define-key dired-mode-map "+" nil)
(define-key dired-mode-map "-" nil)
(define-key dired-mode-map "." nil)
(define-key dired-mode-map "0" nil)
(define-key dired-mode-map "=" nil)

(define-key dired-mode-map "A" nil)
(define-key dired-mode-map "B" nil)
(define-key dired-mode-map "C" nil)
(define-key dired-mode-map "D" nil)
(define-key dired-mode-map "G" nil)
(define-key dired-mode-map "H" nil)
(define-key dired-mode-map "I" nil)
(define-key dired-mode-map "L" nil)
(define-key dired-mode-map "M" nil)
(define-key dired-mode-map "N" nil)
(define-key dired-mode-map "O" nil)
(define-key dired-mode-map "P" nil)
(define-key dired-mode-map "Q" nil)
(define-key dired-mode-map "R" nil)
(define-key dired-mode-map "S" nil)
(define-key dired-mode-map "T" nil)
(define-key dired-mode-map "W" nil)
(define-key dired-mode-map "X" nil)
(define-key dired-mode-map "Z" nil)

(define-key dired-mode-map "c" nil)
(define-key dired-mode-map "d" nil)
(define-key dired-mode-map "e" nil)
(define-key dired-mode-map "h" nil)
(define-key dired-mode-map "j" nil)
(define-key dired-mode-map "k" nil)
(define-key dired-mode-map "m" nil)
(define-key dired-mode-map "n" nil)
(define-key dired-mode-map "o" nil)
(define-key dired-mode-map "q" nil)
(define-key dired-mode-map "s" nil)
(define-key dired-mode-map "t" nil)
(define-key dired-mode-map "v" nil)
(define-key dired-mode-map "w" nil)
(define-key dired-mode-map "x" nil)
(define-key dired-mode-map "y" nil)
(define-key dired-mode-map "~" nil)

(load "~/.muu/settings.el")
(load "~/.muu/keybindings.el")

;Startup
(dired startup-dir)
(split-window-right)
(other-window 1)
(emms-playlist-new "1")
(switch-to-buffer "1")
(emms-playlist-set-playlist-buffer)
(other-window 1)


(message "Welcome to muu, a music player built on GNU Emacs and EMMS.")
(sit-for 15)
