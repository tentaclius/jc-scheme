(define pi 3.141592653589793)
(define (seconds t) (/ t (sample-rate)))

(define (make-Sin freq)
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
        ((equal? (car t) 'set-freq) (set! f (cadr t))) ))))

;(define (f t)
;  (* 0.3 (sin (+ (* 2 pi 440 (seconds t))
;                 (* 40 (mouse-x) (sin (* 2 pi (* 100 (mouse-y)) (seconds t))))))) )

(define carrier (make-Sin 440))
(define modulator (make-Sin 0))

(define (f t)
  (modulator 'set-freq (* 100 (+ 1 (mouse-x))))
  (carrier 'set-freq (+ 440 (* 20 (modulator t))))

  (* 0.3 (carrier t)) )
