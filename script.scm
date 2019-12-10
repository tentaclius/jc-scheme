(use-modules (ice-9 match))

(define pi 3.141592653589793)
(define (seconds t) (/ t (sample-rate)))

(define Sin (make-record-type "Sin-generator" '(freq phase t1)))
(define (make-sin f) ((record-constructor Sin '(freq phase t1)) f 0 0))
(define sin-freq        (record-accessor Sin 'freq))
(define sin-set-freq    (record-modifier Sin 'freq))
(define sin-phase       (record-accessor Sin 'phase))
(define sin-set-phase   (record-modifier Sin 'phase))
(define sin-t1          (record-accessor Sin 't1))
(define sin-set-t1      (record-modifier Sin 't1))
(define (sin-calc s t)
  (sin-set-phase s (+ (sin-phase s) (* 2 pi (sin-freq s) (seconds (- t (sin-t1 s))))))
  (sin-set-t1 s t)
  (sin (sin-phase s)) )

(define carrier (make-sin 440))
(define modulator (make-sin 20))

(define (f t)
  (sin-set-freq modulator (* 60 (mouse-x)))
  (sin-set-freq carrier (+ 440 (* 100 (mouse-y) (sin-calc modulator t))))

  (* 0.3 (sin-calc carrier t)) )
