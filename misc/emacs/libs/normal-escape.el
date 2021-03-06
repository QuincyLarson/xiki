(setq normal-escape-enabled t)   ; Makes sure we enable escape checking at the very beginning

; 1. define function for when esc is pressed:
(defun normal-escape () (interactive)

  (let ((event (read-event nil nil 0.15)))

    ; No event soon after, so just escape out...

    (if (not event)
      (progn
        (setq normal-escape-enabled t)   ; Makes sure we re-enable escape checking

        ; In the minibuffer, so just quit
        (cond
          ; Not sure if we get called when in the minibuffer?
          ((window-minibuffer-p)
            (keyboard-quit)
          )
          (mark-active
            (goto-char (mark))
            (deactivate-mark)
            (message "")   ; So it doesn't show "Cleared Mark"
          )
          (t
            (el4r-ruby-eval "Xiki::ControlTab.go :from_escape=>1")
          )
        )

      )

      ; Recent event happened right after, so just put it back in effect...

      (setq unread-command-events (cons event unread-command-events))
      (setq unread-command-events (cons 27 unread-command-events))
      (setq normal-escape-enabled nil)   ; Disable intercepting esc for a moment, so it'll go through as normal
    )
  )
)

; 2. turn on before each command:
(defun normal-escape-pre-command-handler () (interactive)
  (setq normal-escape-enabled t)
)
(add-hook 'pre-command-hook 'normal-escape-pre-command-handler)

; 3. Define map:
(setq normal-escape-map
  '((normal-escape-enabled keymap
    (27 . normal-escape))
  )
)

; 4. Add to end:
(add-to-ordered-list 'emulation-mode-map-alists 'normal-escape-map 300)


(provide 'normal-escape)
