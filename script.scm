(define pi 3.141592653589793)
(define (seconds t) (/ t (sample-rate)))

(define (Sin freq)
  (let ((phase 0)
        (t1 0)
        (f freq))
    (lambda t
      (cond
        ((number? (car t))
         (set! phase (+ phase (* 2 pi f (seconds (- (car t) t1)))))
         (set! t1 (car t))
         (sin phase) )

        ((equal? (car t) 'freq) f)
        ((equal? (car t) 'set-freq) (set! f (cadr t)) f) ))))

(define carrier (Sin 440))
(define modulator (Sin 20))

(define (f t)
  (modulator 'set-freq (* 60 (mouse-x)))
  (carrier 'set-freq (+ 440 (* 100 (mouse-y) (modulator t))))

  (* 0.3 (carrier t)) )
