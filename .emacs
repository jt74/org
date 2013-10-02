;;;;;; Org Mode;;;
(add-to-list 'load-path (expand-file-name "~/emacs"))

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org-install)

;;;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-agenda-files (quote ("~/emacs/org/")))
			      ; "~/emacs/org/alaska.org"
			      ; "~/emacs/org/todo.org")))

;; Custom Key Bindings
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "<f5>") 'bh/org-todo)
(global-set-key (kbd "<S-f5>") 'bh/widen)
(global-set-key (kbd "<f7>") 'bh/set-truncate-lines)
(global-set-key (kbd "<f8>") 'org-cycle-agenda-files)
(global-set-key (kbd "<f9> <f9>") 'bh/show-org-agenda)
(global-set-key (kbd "<f9> b") 'bbdb)
(global-set-key (kbd "<f9> c") 'calendar)
(global-set-key (kbd "<f9> f") 'boxquote-insert-file)
(global-set-key (kbd "<f9> g") 'gnus)
(global-set-key (kbd "<f9> h") 'bh/hide-other)
(global-set-key (kbd "<f9> n") 'org-narrow-to-subtree)
(global-set-key (kbd "<f9> w") 'widen)
(global-set-key (kbd "<f9> u") 'bh/narrow-up-one-level)

(global-set-key (kbd "<f9> I") 'bh/punch-in)
(global-set-key (kbd "<f9> O") 'bh/punch-out)

(global-set-key (kbd "<f9> o") 'bh/make-org-scratch)

(global-set-key (kbd "<f9> r") 'boxquote-region)
(global-set-key (kbd "<f9> s") 'bh/switch-to-scratch)

(global-set-key (kbd "<f9> t") 'bh/insert-inactive-timestamp)
(global-set-key (kbd "<f9> T") 'tabify)
(global-set-key (kbd "<f9> U") 'untabify)

(global-set-key (kbd "<f9> v") 'visible-mode)
(global-set-key (kbd "<f9> SPC") 'bh/clock-in-last-task)
(global-set-key (kbd "C-<f9>") 'previous-buffer)
(global-set-key (kbd "M-<f9>") 'org-toggle-inline-images)
(global-set-key (kbd "C-x n r") 'narrow-to-region)
(global-set-key (kbd "C-<f10>") 'next-buffer)
(global-set-key (kbd "<f11>") 'org-clock-goto)
(global-set-key (kbd "C-<f11>") 'org-clock-in)
(global-set-key (kbd "C-s-<f12>") 'bh/save-then-publish)
(global-set-key (kbd "C-M-r") 'org-capture)
(global-set-key (kbd "C-c r") 'org-capture)

(defun bh/hide-other ()
  (interactive)
  (save-excursion
    (org-back-to-heading 'invisible-ok)
    (hide-other)
    (org-cycle)
    (org-cycle)
    (org-cycle)))

(defun bh/set-truncate-lines ()
  "Toggle value of truncate-lines and refresh window display."
  (interactive)
  (setq truncate-lines (not truncate-lines))
  ;; now refresh window display (an idiom from simple.el):
  (save-excursion
    (set-window-start (selected-window)
                      (window-start (selected-window)))))

(defun bh/make-org-scratch ()
  (interactive)
  (find-file "/tmp/publish/scratch.org")
  (gnus-make-directory "/tmp/publish"))

(defun bh/switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

; Fast Todo Selection
(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING" . t) ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

; Org-capture set up
(setq org-directory "~/emacs/org")
;(setq org-default-notes-file "~/emacs/org/refile.org")

;; I use C-M-r to start capture mode
;(global-set-key (kbd "C-M-r") 'org-capture)
;; I use C-c r to start capture mode when using SSH from my Android phone
;(global-set-key (kbd "C-c r") 'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/emacs/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/emacs/org/refile.org")
               "* TODO Respond to %:from on %:subject\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/emacs/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/emacs/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/emacs/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("p" "Phone call" entry (file "~/emacs/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/emacs/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

;; 7. REFILING TASKS %%
;;refile set up
; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)


;; Agenda set up
;; Dim blocked tasks
(setq org-agenda-dim-blocked-tasks t)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              (" " "Agenda"
               ((agenda "" nil)
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
                (tags-todo "-CANCELLED/!"
                           ((org-agenda-overriding-header "Stuck Projects")
                            (org-agenda-skip-function 'bh/skip-non-stuck-projects)))
                (tags-todo "-WAITING-CANCELLED/!NEXT"
                           ((org-agenda-overriding-header "Next Tasks")
                            (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                            (org-agenda-todo-ignore-scheduled t)
                            (org-agenda-todo-ignore-deadlines t)
                            (org-agenda-todo-ignore-with-date t)
                            (org-tags-match-list-sublevels t)
                            (org-agenda-sorting-strategy
                             '(todo-state-down effort-up category-keep))))
                (tags-todo "-REFILE-CANCELLED/!-HOLD-WAITING"
                           ((org-agenda-overriding-header "Tasks")
                            (org-agenda-skip-function 'bh/skip-project-tasks-maybe)
                            (org-agenda-todo-ignore-scheduled t)
                            (org-agenda-todo-ignore-deadlines t)
                            (org-agenda-todo-ignore-with-date t)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-HOLD-CANCELLED/!"
                           ((org-agenda-overriding-header "Projects")
                            (org-agenda-skip-function 'bh/skip-non-projects)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-CANCELLED+WAITING/!"
                           ((org-agenda-overriding-header "Waiting and Postponed Tasks")
                            (org-agenda-skip-function 'bh/skip-stuck-projects)
                            (org-tags-match-list-sublevels nil)
                            (org-agenda-todo-ignore-scheduled 'future)
                            (org-agenda-todo-ignore-deadlines 'future)))
                (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                       (org-tags-match-list-sublevels nil))))
               nil)
              ("r" "Tasks to Refile" tags "REFILE"
               ((org-agenda-overriding-header "Tasks to Refile")
                (org-tags-match-list-sublevels nil)))
              ("#" "Stuck Projects" tags-todo "-CANCELLED/!"
               ((org-agenda-overriding-header "Stuck Projects")
                (org-agenda-skip-function 'bh/skip-non-stuck-projects)))
              ("n" "Next Tasks" tags-todo "-WAITING-CANCELLED/!NEXT"
               ((org-agenda-overriding-header "Next Tasks")
                (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                (org-agenda-todo-ignore-scheduled t)
                (org-agenda-todo-ignore-deadlines t)
                (org-agenda-todo-ignore-with-date t)
                (org-tags-match-list-sublevels t)
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              ("R" "Tasks" tags-todo "-REFILE-CANCELLED/!-HOLD-WAITING"
               ((org-agenda-overriding-header "Tasks")
                (org-agenda-skip-function 'bh/skip-project-tasks-maybe)
                (org-agenda-sorting-strategy
                 '(category-keep))))
              ("p" "Projects" tags-todo "-HOLD-CANCELLED/!"
               ((org-agenda-overriding-header "Projects")
                (org-agenda-skip-function 'bh/skip-non-projects)
                (org-agenda-sorting-strategy
                 '(category-keep))))
              ("w" "Waiting Tasks" tags-todo "-CANCELLED+WAITING/!"
               ((org-agenda-overriding-header "Waiting and Postponed tasks"))
               (org-tags-match-list-sublevels nil))
              ("A" "Tasks to Archive" tags "-REFILE/"
               ((org-agenda-overriding-header "Tasks to Archive")
                (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                (org-tags-match-list-sublevels nil))))))
	; hide default stuck projects agenda
	(setq org-stuck-projects (quote ("" nil nil "")))
;; 9.1 Clocks
;;
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot sof clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 36)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq bh/keep-clock-running nil)

(defun bh/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
           (bh/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
           (bh/is-project-p))
      "TODO"))))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun bh/punch-in (arg)
  "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
  (interactive "p")
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in the agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-hd-marker))
             (tags (org-with-point-at marker (org-get-tags-at))))
        (if (and (eq arg 4) tags)
            (org-agenda-clock-in '(16))
          (bh/clock-in-organization-task-as-default)))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
      ; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
          (org-clock-in '(16))
        (bh/clock-in-organization-task-as-default)))))

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
        (widen)
        (while (and (not parent-task) (org-up-heading-safe))
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq parent-task (point))))
        (if parent-task
            (org-with-point-at parent-task
              (org-clock-in))
          (when bh/keep-clock-running
            (bh/clock-in-default-task)))))))

(defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find bh/organization-task-id 'marker)
    (org-clock-in '(16))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
             (not org-clock-clocking-in)
             (marker-buffer org-clock-default-task)
             (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)
;%%
(require 'org-id)
(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))

(defun bh/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
         (cond
          ((eq arg 4) org-clock-default-task)
          ((and (org-clock-is-active)
                (equal org-clock-default-task (cadr org-clock-history)))
           (caddr org-clock-history))
          ((org-clock-is-active) (cadr org-clock-history))
          ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
          (t (car org-clock-history)))))
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))

;; round to nearest minute
(setq org-time-stamp-rounding-minutes (quote (1 1)))

;; shows 1 minute clocking gaps
(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
              :min-duration 0
              :max-gap 0
              :gap-ok-around ("4:00"))))

;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

(setq org-agenda-span 'day)
;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))

;; Task Estimates And Column View
; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

; global Effort estimate values
; global STYLE property values for completion
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                    ("STYLE_ALL" . "habit"))))

;; Providing Progress Reports To Others
;; Agenda log mode items to display (closed and state changes by default)
(setq org-agenda-log-mode-items (quote (closed state)))
;%% 
;; 11. Tags
; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@errand" . ?e)
                            ("@office" . ?o)
                            ("@/home" . ?H)
                            ("@knik" . ?k)
			    ("@hope" . ?q)
                            (:endgroup)
                            ("PHONE" . ?p)
                            ("WAITING" . ?w)
                            ("HOLD" . ?h)
                            ("PERSONAL" . ?P)
                            ("WORK" . ?W)
			    ("HOPE" . ?Q)
			    ("LATIMER" . ?l)
			    ("ALPINE" . ?a)
                            ("ORG" . ?O)
                            ("NORANG" . ?N)
                            ("crypt" . ?E)
                            ("MARK" . ?M)
                            ("NOTE" . ?n)
                            ("BZFLAG" . ?B)
                            ("CANCELLED" . ?c)
                            ("FLAGGED" . ??))))

; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

 (defun bh/is-project-p ()
  "Any task with a todo keyword subtask" 
(save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task has-subtask))))

(defun bh/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                              (point))))
    (save-excursion
      (bh/find-project-task)
      (if (equal (point) task)
          nil
        t))))

(defun bh/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun bh/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun bh/list-sublevels-for-projects-indented ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels 'indented)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun bh/list-sublevels-for-projects ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels t)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun bh/skip-stuck-projects ()
  "Skip trees that are not stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next ))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                nil
              next-headline)) ; a stuck project, has subtasks but no next task
        nil))))

(defun bh/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  (bh/list-sublevels-for-projects-indented)
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next ))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                next-headline
              nil)) ; a stuck project, has subtasks but no next task
        next-headline))))

(defun bh/skip-non-projects ()
  "Skip trees that are not projects"
  (bh/list-sublevels-for-projects-indented)
  (if (save-excursion (bh/skip-non-stuck-projects))
      (save-restriction
        (widen)
        (let ((subtree-end (save-excursion (org-end-of-subtree t))))
          (cond
           ((and (bh/is-project-p)
                 (marker-buffer org-agenda-restrict-begin))
            nil)
           ((and (bh/is-project-p)
                 (not (marker-buffer org-agenda-restrict-begin))
                 (not (bh/is-project-subtree-p)))
            nil)
           (t
            subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun bh/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun bh/skip-projects-and-habits-and-single-tasks ()
  "Skip trees that are projects, tasks that are habits, single non-project tasks"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
        next-headline)
       ((bh/is-project-p)
        next-headline)
       ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
        next-headline)
       (t
        nil)))))

(defun bh/skip-project-tasks-maybe ()
  "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline (save-excursion (or (outline-next-heading) (point-max))))
           (limit-to-project (marker-buffer org-agenda-restrict-begin)))
      (cond
       ((bh/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (not limit-to-project)
             (bh/is-project-subtree-p))
        subtree-end)
       ((and limit-to-project
             (bh/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       (t
        nil)))))

(defun bh/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun bh/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (bh/is-subproject-p)
        nil
      next-headline)))
(setq org-agenda-tags-todo-honor-ignore-options t)

;%% BBDB

(add-to-list 'load-path "~/emacs/elisp/bbdb-2.35/lisp")    ;; (1)
(add-to-list 'load-path "~/emacs/elisp/bbdb/lisp")         ;; (2)

(require 'bbdb) ;; (3)
(require 'bbdb-com)		
(bbdb-initialize 'gnus 'message)   ;; (4)
(setq bbdb-north-american-phone-numbers-p nil)   ;; (5)

(global-set-key (kbd "<f9> p") 'bh/phone-call)

;;
;; Phone capture template handling with BBDB lookup
;; Adapted from code by Gregory J. Grubbs
(defun bh/phone-call ()
  "Return name and company info for caller from bbdb lookup"
  (interactive)
  (let* (name rec caller)
    (setq name (completing-read "Who is calling? "
                                (bbdb-hashtable)
                                'bbdb-completion-predicate
                                'confirm))
    (when (> (length name) 0)
      ; Something was supplied - look it up in bbdb
      (setq rec
            (or (first
                 (or (bbdb-search (bbdb-records) name nil nil)
                     (bbdb-search (bbdb-records) nil name nil)))
                name)))

    ; Build the bbdb link if we have a bbdb record, otherwise just return the name
    (setq caller (cond ((and rec (vectorp rec))
                        (let ((name (bbdb-record-name rec))
                              (company (bbdb-record-company rec)))
                          (concat "[[bbdb:"
                                  name "]["
                                  name "]]"
                                  (when company
                                    (concat " - " company)))))
                       (rec)
                       (t "NameOfCaller")))
    (insert caller)))
;; Diary, presently not used
;(setq org-agenda-include-diary t) 
(setq org-agenda-include-diary nil) 
(setq org-agenda-diary-file "~/emacs/org/diary.org")
(setq org-agenda-insert-diary-extract-time t)

;; MobileOrg
(defcustom org-mobile-checksum-binary (or (executable-find "shasum")
                                          (executable-find "c:/cygwin/bin/sha1sum")
                                          (executable-find "c:/cygwin/bin/md5sum")
                                          (executable-find "md5"))
  "Executable used for computing checksums of agenda files."
  :group 'org-mobile
  :type 'string)
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "c:/documents and settings/leslie cayco/my documents/downloads/dropboxportableahk/dropboxportableahk/dropbox/emacs/mobileorg")
;; set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "c:/documents and settings/leslie cayco/my documents/downloads/dropboxportableahk/dropboxportableahk/dropbox/emacs/mobileorg/flagged.org")

;; org-sync orgsync
;(add-to-list 'load-path "~/emacs/elisp/org-sync")
;(mapc 'load
;      '("org-element" "os" "os-bb" "os-github" "os-rmine" "os-rtm"))

;; Enable habit tracking
;;(require 'org-habit)
(add-to-list 'org-modules 'org-habit)
(require 'org-habit)

;;org-collector
(add-to-list 'load-path "~/emacs/elisp")    ;; 
(require 'org-collector)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (misterioso)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;17.1 Reminder set up
;;;;;;; Org Mode;;;
;(add-to-list 'load-path (expand-file-name "~/emacs/org-mode/lisp"))
;
;(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
;(require 'org-install)
;
;;;;; Standard key bindings
;(global-set-key "\C-cl" 'org-store-link)
;(global-set-key "\C-ca" 'org-agenda)
;(global-set-key "\C-cb" 'org-iswitchb)
;
;(setq org-agenda-files (quote ("~/emacs/org")))
;			      ; "~/emacs/org/alaska.org"
;			      ; "~/emacs/org/todo.org")))
;
;;; Custom Key Bindings
;(global-set-key (kbd "<f12>") 'org-agenda)
;(global-set-key (kbd "<f5>") 'bh/org-todo)
;(global-set-key (kbd "<S-f5>") 'bh/widen)
;(global-set-key (kbd "<f7>") 'bh/set-truncate-lines)
;(global-set-key (kbd "<f8>") 'org-cycle-agenda-files)
;(global-set-key (kbd "<f9> <f9>") 'bh/show-org-agenda)
;(global-set-key (kbd "<f9> b") 'bbdb)
;(global-set-key (kbd "<f9> c") 'calendar)
;(global-set-key (kbd "<f9> f") 'boxquote-insert-file)
;(global-set-key (kbd "<f9> g") 'gnus)
;(global-set-key (kbd "<f9> h") 'bh/hide-other)
;(global-set-key (kbd "<f9> n") 'org-narrow-to-subtree)
;(global-set-key (kbd "<f9> w") 'widen)
;(global-set-key (kbd "<f9> u") 'bh/narrow-up-one-level)
;
;(global-set-key (kbd "<f9> I") 'bh/punch-in)
;(global-set-key (kbd "<f9> O") 'bh/punch-out)
;
;(global-set-key (kbd "<f9> o") 'bh/make-org-scratch)
;
;(global-set-key (kbd "<f9> r") 'boxquote-region)
;(global-set-key (kbd "<f9> s") 'bh/switch-to-scratch)
;
;(global-set-key (kbd "<f9> t") 'bh/insert-inactive-timestamp)
;(global-set-key (kbd "<f9> T") 'tabify)
;(global-set-key (kbd "<f9> U") 'untabify)
;
;(global-set-key (kbd "<f9> v") 'visible-mode)
;(global-set-key (kbd "<f9> SPC") 'bh/clock-in-last-task)
;(global-set-key (kbd "C-<f9>") 'previous-buffer)
;(global-set-key (kbd "M-<f9>") 'org-toggle-inline-images)
;(global-set-key (kbd "C-x n r") 'narrow-to-region)
;(global-set-key (kbd "C-<f10>") 'next-buffer)
;(global-set-key (kbd "<f11>") 'org-clock-goto)
;(global-set-key (kbd "C-<f11>") 'org-clock-in)
;(global-set-key (kbd "C-s-<f12>") 'bh/save-then-publish)
;(global-set-key (kbd "C-M-r") 'org-capture)
;(global-set-key (kbd "C-c r") 'org-capture)
;
;(defun bh/hide-other ()
;  (interactive)
;  (save-excursion
;    (org-back-to-heading 'invisible-ok)
;    (hide-other)
;    (org-cycle)
;    (org-cycle)
;    (org-cycle)))
;
;(defun bh/set-truncate-lines ()
;  "Toggle value of truncate-lines and refresh window display."
;  (interactive)
;  (setq truncate-lines (not truncate-lines))
;  ;; now refresh window display (an idiom from simple.el):
;  (save-excursion
;    (set-window-start (selected-window)
;                      (window-start (selected-window)))))
;
;(defun bh/make-org-scratch ()
;  (interactive)
;  (find-file "/tmp/publish/scratch.org")
;  (gnus-make-directory "/tmp/publish"))
;
;(defun bh/switch-to-scratch ()
;  (interactive)
;  (switch-to-buffer "*scratch*"))
;
;(setq org-todo-keywords
;      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!/!)")
;              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE"))))
;
;(setq org-todo-keyword-faces
;      (quote (("TODO" :foreground "red" :weight bold)
;              ("NEXT" :foreground "blue" :weight bold)
;              ("DONE" :foreground "forest green" :weight bold)
;              ("WAITING" :foreground "orange" :weight bold)
;              ("HOLD" :foreground "magenta" :weight bold)
;              ("CANCELLED" :foreground "forest green" :weight bold)
;              ("PHONE" :foreground "forest green" :weight bold))))
;
;; Fast Todo Selection
;(setq org-use-fast-todo-selection t)
;(setq org-treat-S-cursor-todo-selection-as-state-change nil)
;
;(setq org-todo-state-tags-triggers
;      (quote (("CANCELLED" ("CANCELLED" . t))
;              ("WAITING" ("WAITING" . t))
;              ("HOLD" ("WAITING" . t) ("HOLD" . t))
;              (done ("WAITING") ("HOLD"))
;              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
;              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
;              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
;
;; Org-capture set up
;;(setq org-directory "~/emacs/org")
;;(setq org-default-notes-file "~/emacs/org/refile.org")
;
;;; I use C-M-r to start capture mode
;;(global-set-key (kbd "C-M-r") 'org-capture)
;;; I use C-c r to start capture mode when using SSH from my Android phone
;;(global-set-key (kbd "C-c r") 'org-capture)
;
;;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
;(setq org-capture-templates
;      (quote (("t" "todo" entry (file "~/emacs/org/refile.org")
;               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
;              ("r" "respond" entry (file "~/emacs/org/refile.org")
;               "* TODO Respond to %:from on %:subject\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
;              ("n" "note" entry (file "~/emacs/org/refile.org")
;               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
;              ("j" "Journal" entry (file+datetree "~/emacs/org/diary.org")
;               "* %?\n%U\n" :clock-in t :clock-resume t)
;              ("w" "org-protocol" entry (file "~/emacs/org/refile.org")
;               "* TODO Review %c\n%U\n" :immediate-finish t)
;              ("p" "Phone call" entry (file "~/emacs/org/refile.org")
;               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
;              ("h" "Habit" entry (file "~/emacs/org/refile.org")
;               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))
;
;;; Remove empty LOGBOOK drawers on clock out
;(defun bh/remove-empty-drawer-on-clock-out ()
;  (interactive)
;  (save-excursion
;    (beginning-of-line 0)
;    (org-remove-empty-drawer-at "LOGBOOK" (point))))
;
;(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)
;
;;;refile set up
;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
;(setq org-refile-targets (quote ((nil :maxlevel . 9)
;                                 (org-agenda-files :maxlevel . 9))))
;
;; Use full outline paths for refile targets - we file directly with IDO
;(setq org-refile-use-outline-path t)
;
;; Targets complete directly with IDO
;(setq org-outline-path-complete-in-steps nil)
;
;; Allow refile to create parent tasks with confirmation
;(setq org-refile-allow-creating-parent-nodes (quote confirm))
;
;; Use IDO for both buffer and file completion and ido-everywhere to t
;(setq org-completion-use-ido t)
;(setq ido-everywhere t)
;(setq ido-max-directory-size 100000)
;(ido-mode (quote both))
;
;;;;; Refile settings
;; Exclude DONE state tasks from refile targets
;(defun bh/verify-refile-target ()
;  "Exclude todo keywords with a done state from refile targets"
;  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
;
;(setq org-refile-target-verify-function 'bh/verify-refile-target)
;
;
;;; Agenda set up
;;; Dim blocked tasks
;(setq org-agenda-dim-blocked-tasks t)
;
;;; Compact the block agenda view
;(setq org-agenda-compact-blocks t)
;
;;; Custom agenda command definitions
;(setq org-agenda-custom-commands
;      (quote (("N" "Notes" tags "NOTE"
;               ((org-agenda-overriding-header "Notes")
;                (org-tags-match-list-sublevels t)))
;              ("h" "Habits" tags-todo "STYLE=\"habit\""
;               ((org-agenda-overriding-header "Habits")
;                (org-agenda-sorting-strategy
;                 '(todo-state-down effort-up category-keep))))
;              (" " "Agenda"
;               ((agenda "" nil)
;                (tags "REFILE"
;                      ((org-agenda-overriding-header "Tasks to Refile")
;                       (org-tags-match-list-sublevels nil)))
;                (tags-todo "-CANCELLED/!"
;                           ((org-agenda-overriding-header "Stuck Projects")
;                            (org-agenda-skip-function 'bh/skip-non-stuck-projects)))
;                (tags-todo "-WAITING-CANCELLED/!NEXT"
;                           ((org-agenda-overriding-header "Next Tasks")
;                            (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
;                            (org-agenda-todo-ignore-scheduled t)
;                            (org-agenda-todo-ignore-deadlines t)
;                            (org-agenda-todo-ignore-with-date t)
;                            (org-tags-match-list-sublevels t)
;                            (org-agenda-sorting-strategy
;                             '(todo-state-down effort-up category-keep))))
;                (tags-todo "-REFILE-CANCELLED/!-HOLD-WAITING"
;                           ((org-agenda-overriding-header "Tasks")
;                            (org-agenda-skip-function 'bh/skip-project-tasks-maybe)
;                            (org-agenda-todo-ignore-scheduled t)
;                            (org-agenda-todo-ignore-deadlines t)
;                            (org-agenda-todo-ignore-with-date t)
;                            (org-agenda-sorting-strategy
;                             '(category-keep))))
;                (tags-todo "-HOLD-CANCELLED/!"
;                           ((org-agenda-overriding-header "Projects")
;                            (org-agenda-skip-function 'bh/skip-non-projects)
;                            (org-agenda-sorting-strategy
;                             '(category-keep))))
;                (tags-todo "-CANCELLED+WAITING/!"
;                           ((org-agenda-overriding-header "Waiting and Postponed Tasks")
;                            (org-agenda-skip-function 'bh/skip-stuck-projects)
;                            (org-tags-match-list-sublevels nil)
;                            (org-agenda-todo-ignore-scheduled 'future)
;                            (org-agenda-todo-ignore-deadlines 'future)))
;                (tags "-REFILE/"
;                      ((org-agenda-overriding-header "Tasks to Archive")
;                       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
;                       (org-tags-match-list-sublevels nil))))
;               nil)
;              ("r" "Tasks to Refile" tags "REFILE"
;               ((org-agenda-overriding-header "Tasks to Refile")
;                (org-tags-match-list-sublevels nil)))
;              ("#" "Stuck Projects" tags-todo "-CANCELLED/!"
;               ((org-agenda-overriding-header "Stuck Projects")
;                (org-agenda-skip-function 'bh/skip-non-stuck-projects)))
;              ("n" "Next Tasks" tags-todo "-WAITING-CANCELLED/!NEXT"
;               ((org-agenda-overriding-header "Next Tasks")
;                (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
;                (org-agenda-todo-ignore-scheduled t)
;                (org-agenda-todo-ignore-deadlines t)
;                (org-agenda-todo-ignore-with-date t)
;                (org-tags-match-list-sublevels t)
;                (org-agenda-sorting-strategy
;                 '(todo-state-down effort-up category-keep))))
;              ("R" "Tasks" tags-todo "-REFILE-CANCELLED/!-HOLD-WAITING"
;               ((org-agenda-overriding-header "Tasks")
;                (org-agenda-skip-function 'bh/skip-project-tasks-maybe)
;                (org-agenda-sorting-strategy
;                 '(category-keep))))
;              ("p" "Projects" tags-todo "-HOLD-CANCELLED/!"
;               ((org-agenda-overriding-header "Projects")
;                (org-agenda-skip-function 'bh/skip-non-projects)
;                (org-agenda-sorting-strategy
;                 '(category-keep))))
;              ("w" "Waiting Tasks" tags-todo "-CANCELLED+WAITING/!"
;               ((org-agenda-overriding-header "Waiting and Postponed tasks"))
;               (org-tags-match-list-sublevels nil))
;              ("A" "Tasks to Archive" tags "-REFILE/"
;               ((org-agenda-overriding-header "Tasks to Archive")
;                (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
;                (org-tags-match-list-sublevels nil))))))
;	; hide default stuck projects agenda
;	(setq org-stuck-projects (quote ("" nil nil "")))
;;; Clocks
;;;
;;; Resume clocking task when emacs is restarted
;(org-clock-persistence-insinuate)
;;;
;;; Show lot sof clocking history so it's easy to pick items off the C-F11 list
;(setq org-clock-history-length 36)
;;; Resume clocking task on clock-in if the clock is open
;(setq org-clock-in-resume t)
;;; Change tasks to NEXT when clocking in
;(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;;; Separate drawers for clocking and logs
;(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;;; Save clock data and state changes and notes in the LOGBOOK drawer
;(setq org-clock-into-drawer t)
;;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
;(setq org-clock-out-remove-zero-time-clocks t)
;;; Clock out when moving task to a done state
;(setq org-clock-out-when-done t)
;;; Save the running clock and all clock history when exiting Emacs, load it on startup
;(setq org-clock-persist t)
;;; Do not prompt to resume an active clock
;(setq org-clock-persist-query-resume nil)
;;; Enable auto clock resolution for finding open clocks
;(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;;; Include current clocking task in clock reports
;(setq org-clock-report-include-clocking-task t)
;
;(setq bh/keep-clock-running nil)
;
;(defun bh/clock-in-to-next (kw)
;  "Switch a task from TODO to NEXT when clocking in.
;Skips capture tasks, projects, and subprojects.
;Switch projects and subprojects from NEXT back to TODO"
;  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
;    (cond
;     ((and (member (org-get-todo-state) (list "TODO"))
;           (bh/is-task-p))
;      "NEXT")
;     ((and (member (org-get-todo-state) (list "NEXT"))
;           (bh/is-project-p))
;      "TODO"))))
;
;(defun bh/find-project-task ()
;  "Move point to the parent (project) task if any"
;  (save-restriction
;    (widen)
;    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
;      (while (org-up-heading-safe)
;        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
;          (setq parent-task (point))))
;      (goto-char parent-task)
;      parent-task)))
;
;(defun bh/punch-in (arg)
;  "Start continuous clocking and set the default task to the
;selected task.  If no task is selected set the Organization task
;as the default task."
;  (interactive "p")
;  (setq bh/keep-clock-running t)
;  (if (equal major-mode 'org-agenda-mode)
;      ;;
;      ;; We're in the agenda
;      ;;
;      (let* ((marker (org-get-at-bol 'org-hd-marker))
;             (tags (org-with-point-at marker (org-get-tags-at))))
;        (if (and (eq arg 4) tags)
;            (org-agenda-clock-in '(16))
;          (bh/clock-in-organization-task-as-default)))
;    ;;
;    ;; We are not in the agenda
;    ;;
;    (save-restriction
;      (widen)
;      ; Find the tags on the current task
;      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
;          (org-clock-in '(16))
;        (bh/clock-in-organization-task-as-default)))))
;
;(defun bh/punch-out ()
;  (interactive)
;  (setq bh/keep-clock-running nil)
;  (when (org-clock-is-active)
;    (org-clock-out))
;  (org-agenda-remove-restriction-lock))
;
;(defun bh/clock-in-default-task ()
;  (save-excursion
;    (org-with-point-at org-clock-default-task
;      (org-clock-in))))
;
;(defun bh/clock-in-parent-task ()
;  "Move point to the parent (project) task if any and clock in"
;  (let ((parent-task))
;    (save-excursion
;      (save-restriction
;        (widen)
;        (while (and (not parent-task) (org-up-heading-safe))
;          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
;            (setq parent-task (point))))
;        (if parent-task
;            (org-with-point-at parent-task
;              (org-clock-in))
;          (when bh/keep-clock-running
;            (bh/clock-in-default-task)))))))
;
;(defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")
;
;(defun bh/clock-in-organization-task-as-default ()
;  (interactive)
;  (org-with-point-at (org-id-find bh/organization-task-id 'marker)
;    (org-clock-in '(16))))
;
;(defun bh/clock-out-maybe ()
;  (when (and bh/keep-clock-running
;             (not org-clock-clocking-in)
;             (marker-buffer org-clock-default-task)
;             (not org-clock-resolving-clocks-due-to-idleness))
;    (bh/clock-in-parent-task)))
;
;(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)
;;%%
;(require 'org-id)
;(defun bh/clock-in-task-by-id (id)
;  "Clock in a task by id"
;  (org-with-point-at (org-id-find id 'marker)
;    (org-clock-in nil)))
;
;(defun bh/clock-in-last-task (arg)
;  "Clock in the interrupted task if there is one
;Skip the default task and get the next one.
;A prefix arg forces clock in of the default task."
;  (interactive "p")
;  (let ((clock-in-to-task
;         (cond
;          ((eq arg 4) org-clock-default-task)
;          ((and (org-clock-is-active)
;                (equal org-clock-default-task (cadr org-clock-history)))
;           (caddr org-clock-history))
;          ((org-clock-is-active) (cadr org-clock-history))
;          ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
;          (t (car org-clock-history)))))
;    (org-with-point-at clock-in-to-task
;      (org-clock-in nil))))
;
;;; round to nearest minute
;(setq org-time-stamp-rounding-minutes (quote (1 1)))
;
;;; shows 1 minute clocking gaps
;(setq org-agenda-clock-consistency-checks
;      (quote (:max-duration "4:00"
;              :min-duration 0
;              :max-gap 0
;              :gap-ok-around ("4:00"))))
;
;;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
;(setq org-clock-out-remove-zero-time-clocks t)
;
;(setq org-agenda-span 'day)
;;; Agenda clock report parameters
;(setq org-agenda-clockreport-parameter-plist
;      (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))
;
;;; Task Estimates And Column View
;; Set default column view headings: Task Effort Clock_Summary
;(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")
;
;; global Effort estimate values
;; global STYLE property values for completion
;(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
;                                    ("STYLE_ALL" . "habit"))))
;
;;; Providing Progress Reports To Others
;;; Agenda log mode items to display (closed and state changes by default)
;(setq org-agenda-log-mode-items (quote (closed state)))
;;%% 
;;; Tags
;; Tags with fast selection keys
;(setq org-tag-alist (quote ((:startgroup)
;                            ("@errand" . ?e)
;                            ("@office" . ?o)
;                            ("@/home" . ?H)
;                            ("@knik" . ?k)
;			    ("@hope" . ?q)
;                            (:endgroup)
;                            ("PHONE" . ?p)
;                            ("WAITING" . ?w)
;                            ("HOLD" . ?h)
;                            ("PERSONAL" . ?P)
;                            ("WORK" . ?W)
;                            ("KNIK" . ?K)
;			    ("HOPE" . ?Q)
;			    ("LATIMER" . ?l)
;			    ("ALPINE" . ?a)
;                            ("ORG" . ?O)
;                            ("NORANG" . ?N)
;                            ("crypt" . ?E)
;                            ("MARK" . ?M)
;                            ("NOTE" . ?n)
;                            ("BZFLAG" . ?B)
;                            ("CANCELLED" . ?c)
;                            ("FLAGGED" . ??))))
;
;; Allow setting single tags without the menu
;(setq org-fast-tag-selection-single-key (quote expert))
;
; (defun bh/is-project-p ()
;  "Any task with a todo keyword subtask" 
;(save-restriction
;    (widen)
;    (let ((has-subtask)
;          (subtree-end (save-excursion (org-end-of-subtree t)))
;          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
;      (save-excursion
;        (forward-line 1)
;        (while (and (not has-subtask)
;                    (< (point) subtree-end)
;                    (re-search-forward "^\*+ " subtree-end t))
;          (when (member (org-get-todo-state) org-todo-keywords-1)
;            (setq has-subtask t))))
;      (and is-a-task has-subtask))))
;
;(defun bh/is-project-subtree-p ()
;  "Any task with a todo keyword that is in a project subtree.
;Callers of this function already widen the buffer view."
;  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
;                              (point))))
;    (save-excursion
;      (bh/find-project-task)
;      (if (equal (point) task)
;          nil
;        t))))
;
;(defun bh/is-task-p ()
;  "Any task with a todo keyword and no subtask"
;  (save-restriction
;    (widen)
;    (let ((has-subtask)
;          (subtree-end (save-excursion (org-end-of-subtree t)))
;          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
;      (save-excursion
;        (forward-line 1)
;        (while (and (not has-subtask)
;                    (< (point) subtree-end)
;                    (re-search-forward "^\*+ " subtree-end t))
;          (when (member (org-get-todo-state) org-todo-keywords-1)
;            (setq has-subtask t))))
;      (and is-a-task (not has-subtask)))))
;
;(defun bh/is-subproject-p ()
;  "Any task which is a subtask of another project"
;  (let ((is-subproject)
;        (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
;    (save-excursion
;      (while (and (not is-subproject) (org-up-heading-safe))
;        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
;          (setq is-subproject t))))
;    (and is-a-task is-subproject)))
;
;(defun bh/list-sublevels-for-projects-indented ()
;  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
;  This is normally used by skipping functions where this variable is already local to the agenda."
;  (if (marker-buffer org-agenda-restrict-begin)
;      (setq org-tags-match-list-sublevels 'indented)
;    (setq org-tags-match-list-sublevels nil))
;  nil)
;
;(defun bh/list-sublevels-for-projects ()
;  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
;  This is normally used by skipping functions where this variable is already local to the agenda."
;  (if (marker-buffer org-agenda-restrict-begin)
;      (setq org-tags-match-list-sublevels t)
;    (setq org-tags-match-list-sublevels nil))
;  nil)
;
;(defun bh/skip-stuck-projects ()
;  "Skip trees that are not stuck projects"
;  (save-restriction
;    (widen)
;    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
;      (if (bh/is-project-p)
;          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
;                 (has-next ))
;            (save-excursion
;              (forward-line 1)
;              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
;                (unless (member "WAITING" (org-get-tags-at))
;                  (setq has-next t))))
;            (if has-next
;                nil
;              next-headline)) ; a stuck project, has subtasks but no next task
;        nil))))
;
;(defun bh/skip-non-stuck-projects ()
;  "Skip trees that are not stuck projects"
;  (bh/list-sublevels-for-projects-indented)
;  (save-restriction
;    (widen)
;    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
;      (if (bh/is-project-p)
;          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
;                 (has-next ))
;            (save-excursion
;              (forward-line 1)
;              (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
;                (unless (member "WAITING" (org-get-tags-at))
;                  (setq has-next t))))
;            (if has-next
;                next-headline
;              nil)) ; a stuck project, has subtasks but no next task
;        next-headline))))
;
;(defun bh/skip-non-projects ()
;  "Skip trees that are not projects"
;  (bh/list-sublevels-for-projects-indented)
;  (if (save-excursion (bh/skip-non-stuck-projects))
;      (save-restriction
;        (widen)
;        (let ((subtree-end (save-excursion (org-end-of-subtree t))))
;          (cond
;           ((and (bh/is-project-p)
;                 (marker-buffer org-agenda-restrict-begin))
;            nil)
;           ((and (bh/is-project-p)
;                 (not (marker-buffer org-agenda-restrict-begin))
;                 (not (bh/is-project-subtree-p)))
;            nil)
;           (t
;            subtree-end))))
;    (save-excursion (org-end-of-subtree t))))
;
;(defun bh/skip-project-trees-and-habits ()
;  "Skip trees that are projects"
;  (save-restriction
;    (widen)
;    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
;      (cond
;       ((bh/is-project-p)
;        subtree-end)
;       ((org-is-habit-p)
;        subtree-end)
;       (t
;        nil)))))
;
;(defun bh/skip-projects-and-habits-and-single-tasks ()
;  "Skip trees that are projects, tasks that are habits, single non-project tasks"
;  (save-restriction
;    (widen)
;    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
;      (cond
;       ((org-is-habit-p)
;        next-headline)
;       ((bh/is-project-p)
;        next-headline)
;       ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
;        next-headline)
;       (t
;        nil)))))
;
;(defun bh/skip-project-tasks-maybe ()
;  "Show tasks related to the current restriction.
;When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
;When not restricted, skip project and sub-project tasks, habits, and project related tasks."
;  (save-restriction
;    (widen)
;    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
;           (next-headline (save-excursion (or (outline-next-heading) (point-max))))
;           (limit-to-project (marker-buffer org-agenda-restrict-begin)))
;      (cond
;       ((bh/is-project-p)
;        next-headline)
;       ((org-is-habit-p)
;        subtree-end)
;       ((and (not limit-to-project)
;             (bh/is-project-subtree-p))
;        subtree-end)
;       ((and limit-to-project
;             (bh/is-project-subtree-p)
;             (member (org-get-todo-state) (list "NEXT")))
;        subtree-end)
;       (t
;        nil)))))
;
;(defun bh/skip-projects-and-habits ()
;  "Skip trees that are projects and tasks that are habits"
;  (save-restriction
;    (widen)
;    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
;      (cond
;       ((bh/is-project-p)
;        subtree-end)
;       ((org-is-habit-p)
;        subtree-end)
;       (t
;        nil)))))
;
;(defun bh/skip-non-subprojects ()
;  "Skip trees that are not projects"
;  (let ((next-headline (save-excursion (outline-next-heading))))
;    (if (bh/is-subproject-p)
;        nil
;      next-headline)))
;(setq org-agenda-tags-todo-honor-ignore-options t)
;
;;; Phone calls %%
;;: BBDB
;;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
; (setq org-capture-templates
;       (quote (...
;		("p" "Phone call" entry (file "~/git/org/refile.org")
;		 "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
;		...)))
;
;(add-to-list 'load-path "~/emacs/elisp/bbdb-2.35/lisp")    ;; (1)
;(add-to-list 'load-path "~/emacs/elisp/bbdb/lisp")         ;; (2)
;
;(require 'bbdb) ;; (3)
;(require 'bbdb-com)		
;(bbdb-initialize 'gnus 'message)   ;; (4)
;(setq bbdb-north-american-phone-numbers-p nil)   ;; (5)
;
;(global-set-key (kbd "<f9> p") 'bh/phone-call)
;
;;;
;;; Phone capture template handling with BBDB lookup
;;; Adapted from code by Gregory J. Grubbs
;(defun bh/phone-call ()
;  "Return name and company info for caller from bbdb lookup"
;  (interactive)
;  (let* (name rec caller)
;    (setq name (completing-read "Who is calling? "
;                                (bbdb-hashtable)
;                                'bbdb-completion-predicate
;                                'confirm))
;    (when (> (length name) 0)
;      ; Something was supplied - look it up in bbdb
;      (setq rec
;            (or (first
;                 (or (bbdb-search (bbdb-records) name nil nil)
;                     (bbdb-search (bbdb-records) nil name nil)))
;                name)))
;    ;
;    ; Build the bbdb link if we have a bbdb record, otherwise just return the name
;    ;
;    (setq caller (cond ((and rec (vectorp rec))
;                        (let ((name (bbdb-record-name rec))
;                              (company (bbdb-record-company rec)))
;                          (concat "[[bbdb:"
;                                  name "]["
;                                  name "]]"
;                                  (when company
;                                    (concat " - " company)))))
;                       (rec)
;                       (t "NameOfCaller")))
;    (insert caller)))
;;; Diary, presently not used
;;(setq org-agenda-include-diary t) 
;(setq org-agenda-include-diary nil) 
;(setq org-agenda-diary-file "~/emacs/org/diary.org")
;(setq org-agenda-insert-diary-extract-time t)
;
;;; MobileOrg
;(defcustom org-mobile-checksum-binary (or (executable-find "shasum")
;                                          (executable-find "c:/cygwin/bin/sha1sum")
;                                          (executable-find "c:/cygwin/bin/md5sum")
;                                          (executable-find "md5"))
;  "Executable used for computing checksums of agenda files."
;  :group 'org-mobile
;  :type 'string)
;;; Set to <your Dropbox root directory>/MobileOrg.
;(setq org-mobile-directory "~/emacs/mobileorg")
;;; Set to the name of the file where new notes will be stored
;(setq org-mobile-inbox-for-pull "~/emacs/org/flagged.org")
;
;;; Enable habit tracking
;;;(require 'org-habit)
;(add-to-list 'org-modules 'org-habit)
;(require 'org-habit)
;
;;;org-collector
;(add-to-list 'load-path "~/emacs/elisp")    ;; 
;(require 'org-collector)
;
;(custom-set-variables
; ;; custom-set-variables was added by Custom.
; ;; If you edit it by hand, you could mess it up, so be careful.
; ;; Your init file should contain only one such instance.
; ;; If there is more than one, they won't work right.
; '(custom-enabled-themes (quote (misterioso)))
; '(show-paren-mode t))
;(custom-set-faces
; ;; custom-set-faces was added by Custom.
; ;; If you edit it by hand, you could mess it up, so be careful.
; ;; Your init file should contain only one such instance.
; ;; If there is more than one, they won't work right.
; )
;
;;; 17. Reminders %%
;;;17.1 Reminder set up
;; Erase all reminders and rebuilt reminders for today from the agenda
;(defun bh/org-agenda-to-appt ()
;  (interactive)
;  (setq appt-time-msg-list nil)
;  (org-agenda-to-appt))
;
;; Rebuild the reminders everytime the agenda is displayed
;(add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt 'append)
;
;; This is at the end of my .emacs - so appointments are set up when Emacs starts
;(bh/org-agenda-to-appt)
;
;; Activate appointments so we get notifications
;(appt-activate t)
;
;; If we leave Emacs running overnight - reset the appointments one minute after midnight
;(run-at-time "24:01" nil 'bh/org-agenda-to-appt)

;;toodledo set up
;       (push "~/emacs/elisp/org-toodledo" load-path)
;       (require 'org-toodledo)
;       (setq org-toodledo-userid "td4d014eabd8a69")   ;   << *NOT* your email!
;       (setq org-toodledo-password "QHnZb5ly5heA")
    
       ;; Useful key bindings for org-mode
;       (add-hook 'org-mode-hook
;              (lambda ()
;                (local-unset-key "\C-o")
;                (local-set-key "\C-od" 'org-toodledo-mark-task-deleted)
;                (local-set-key "\C-os" 'org-toodledo-sync)
;                )
;              )
;       (add-hook 'org-agenda-mode-hook
;              (lambda ()
;                (local-unset-key "\C-o")
;                (local-set-key "\C-od" 'org-toodledo-agenda-mark-task-deleted)
;                )
;              )
;
