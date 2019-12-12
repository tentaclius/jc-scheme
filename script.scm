(use-modules (ice-9 match))
(use-modules (srfi srfi-9))
(use-modules (oop goops))

(define pi 3.141592653589793)
(define (seconds t) (/ t (sample-rate)))

;; Closure with pattern matching
;(define (Sin f)
;  (let ((freq f)
;        (phase 0)
;        (t1 0))
;    (match-lambda*
;      (('freq) freq)
;      (('set-freq f) (set! freq f) freq)
;      (('phase) phase)
;      (('set-phase p) (set! phase p) phase)
;      (('t1) t1)
;      (('set-t1 t) (set! t1 t) t1)
;      ((t)
;       (set! phase (+ phase (* 2 pi freq (seconds (- t t1)))))
;       (set! t1 t)
;       (sin phase)) )))

;; Closure with methods hashtable
;(define (Sin f)
;  (let ((freq f)
;        (phase 0)
;        (t1 0)
;        (methods (make-hash-table)))
;    (hash-set! methods 'freq (λ () freq))
;    (hash-set! methods 'set-freq (λ (f) (set! freq f) freq))
;    (hash-set! methods 'phase (λ () phase))
;    (hash-set! methods 'set-phase (λ (p) (set! phase p) phase))
;    (hash-set! methods 't1 (λ () t1))
;    (hash-set! methods 'set-t1 (λ (t) (set! t1 t) t1))
;    (hash-set! methods 'calc
;               (λ (t)
;                  (set! phase (+ phase (* 2 pi freq (seconds (- t t1)))))
;                  (set! t1 t)
;                  (sin phase) ))
;    (lambda args
;      (apply (hash-ref methods (car args)) (cdr args)) )))

;(define carrier (Sin 440))
;(define modulator (Sin 20))
;
;(define (f t)
;  (modulator 'set-freq (* 60 (mouse-x)))
;  (carrier 'set-freq (+ 440 (* 100 (mouse-y) (modulator 'calc t))))
;
;  (* 0.3 (carrier 'calc t)) )

;; Records
;(define-record-type <sin>
;  (sin-constructor freq phase t1)
;  sin-osc?
;  (freq sin-freq sin-set-freq)
;  (phase sin-phase sin-set-phase)
;  (t1 sin-t1 sin-set-t1))
;(define (make-sin f)
;  (sin-constructor f 0 0))
;(define (sin-calc s t)
;  (sin-set-phase s (+ (sin-phase s) (* 2 pi (sin-freq s) (seconds (- t (sin-t1 s))))))
;  (sin-set-t1 s t)
;  (sin (sin-phase s)) )

;(define carrier (make-sin 440))
;(define modulator (make-sin 20))
;
;(define (f t)
;  (sin-set-freq modulator (* 60 (mouse-x)))
;  (sin-set-freq carrier (+ 440 (* 100 (mouse-y) (sin-calc modulator t))))
;
;  (* 0.3 (sin-calc carrier t)) )

(define-class <SinOsc> ()
  (freq  #:init-value 0 #:init-keyword #:freq #:getter freq #:setter set-freq)
  (phase #:init-value 0 #:init-keyword #:phase #:getter phase #:setter set-phase) )

(define-method (calc (osc <SinOsc>) (t <number>))
  (set-phase osc (+ (phase osc) (* 2 pi (freq osc) (seconds 1))))
  (sin (phase osc)) ) 

(define carrier (make <SinOsc> #:freq 440))
(define modulator (make <SinOsc> #:freq 20))

(define (f t)
  (set-freq modulator (* 60 (mouse-x)))
  (set-freq carrier (+ 440 (* 100 (mouse-y) (calc modulator t))))

  (* 0.3 (calc carrier t)) )
