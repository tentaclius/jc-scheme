(use-modules (ice-9 match))

(define pi 3.141592653589793)
(define (seconds t) (/ t (sample-rate)))

(define (Sin f)
  (let ((phase 0)
        (t1 0)
        (freq f))
    (match args
           (('freq) freq)
           (('set-freq f) (set! freq f) freq)
           (('phase) phase)
           (('set-phase p) (set! phase p) phase)

           ((t)
            (set! phase (+ phase (* 2 pi freq (seconds (- t t1)))))
            (set! t1 t)
            (sin phase) ) )))

(define carrier (Sin 440))
(define modulator (Sin 20))

(define (f t)
  (modulator 'set-freq (* 60 (mouse-x)))
  (carrier 'set-freq (+ 440 (* 100 (mouse-y) (modulator t))))

  (* 0.3 (carrier t)) )
