;;; vagrant-tramp.el --- vagrant method for TRAMP

(require 'tramp)
(require 'tramp-sh)

;;;###autoload
(defconst vagrant-tramp-method "vagrant"
  "TRAMP method for vagrant boxes.")

(defcustom vagrant-tramp-ssh
  (or (executable-find "vagrant-tramp-ssh")
      (concat (file-name-directory (locate-library "vagrant-tramp"))
              "vagrant-tramp-ssh"))
  "The vagrant-tramp-ssh executable"
  :group 'tramp
  :type 'file)

(defgroup vagrant-tramp nil
  "Vagrant TRAMP method."
  :group 'tramp)

(defun vagrant-tramp-parse (cmd)
  (with-temp-buffer
    (shell-command cmd t)
    (mapcar (lambda (name)
              (list nil name))
            (split-string (buffer-string) "\n" t))))

;;;###autoload
(eval-after-load 'tramp
  '(progn
     (add-to-list 'tramp-methods
                  `(,vagrant-tramp-method
                    (tramp-login-program     ,vagrant-tramp-ssh)
                    (tramp-login-args        (("%h")))
                    (tramp-remote-shell      "/bin/sh")
                    (tramp-remote-shell-args ("-c"))))
     (tramp-set-completion-function vagrant-tramp-method
                                    `((vagrant-tramp-parse ,vagrant-tramp-ssh)))))

(provide 'vagrant-tramp)
;;; vagrant-tramp.el ends here
